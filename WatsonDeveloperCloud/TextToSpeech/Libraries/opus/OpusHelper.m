/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import "OpusHelper.h"
#import "opus.h"
#import "opus_multistream.h"
#import "opus_defines.h"
#import "ogg.h"
#import "opus_header.h"

/* 120ms at 48000 */
#define MAX_FRAME_SIZE (960 * 6)
#define float2int(flt) ((int)(floor(.5 + flt)))

@interface OpusHelper ()

@property (nonatomic) OpusEncoder* encoder;
@property (nonatomic) uint8_t* encoderOutputBuffer;
@property (nonatomic) NSUInteger encoderBufferLength;

@end

@implementation OpusHelper

- (void)dealloc
{
    if (_encoder) {
        opus_encoder_destroy(_encoder);
    }
    if (_encoderOutputBuffer) {
        free(_encoderOutputBuffer);
    }
}

- (void)setBitrate:(NSUInteger)bitrate
{
    if (!_encoder) {
        return;
    }
    _bitrate = bitrate;
    dispatch_async(self.processingQueue, ^{
        opus_encoder_ctl(_encoder, OPUS_SET_BITRATE(bitrate));
    });
}

/**
 *  Create Opus encoder
 *
 *  @param sampleRate Audio sample rate
 *
 *  @return BOOL
 */
- (BOOL)createEncoder:(int)sampleRate
{
    if (self.encoder) {
        return YES;
    }
    int opusError = OPUS_OK;

    // sample rates are 8000,12000,16000,24000,48000
    // number of channels 1 or 2 mono stereo
    // app type choices OPUS_APPLICATION_VOIP,OPUS_APPLICATION_AUDIO,OPUS_APPLICATION_RESTRICTED_LOWDELAY
    self.encoder = opus_encoder_create(sampleRate, 1, OPUS_APPLICATION_VOIP, &opusError);
    if (opusError != OPUS_OK) {
        NSLog(@"Error setting up opus encoder, error code is %@", [self opusErrorMessage:opusError]);
        return NO;
    }

    self.encoderBufferLength = 16000;
    self.encoderOutputBuffer = malloc(_encoderBufferLength * sizeof(uint8_t));

    return YES;
}

- (NSString*)opusErrorMessage:(int)errorCode
{
    switch (errorCode) {
    case OPUS_BAD_ARG:
        return @"One or more invalid/out of range arguments";
    case OPUS_BUFFER_TOO_SMALL:
        return @"The mode struct passed is invalid";
    case OPUS_INTERNAL_ERROR:
        return @"The compressed data passed is corrupted";
    case OPUS_INVALID_PACKET:
        return @"Invalid/unsupported request number";
    case OPUS_INVALID_STATE:
        return @"An encoder or decoder structure is invalid or already freed.";
    case OPUS_UNIMPLEMENTED:
        return @"Invalid/unsupported request number.";
    case OPUS_ALLOC_FAIL:
        return @"Memory allocation has failed.";
    default:
        return nil;
        break;
    }
}

/**
 *  Opus data encoding
 *
 *  @param pcmData   PCM data
 *  @param frameSize Frame size
 *
 *  @return NSMutableData
 */
- (NSData*)encode:(NSData*)pcmData frameSize:(int)frameSize
{

    opus_int16* data = (opus_int16*)[pcmData bytes];
    uint8_t* outBuffer = malloc(pcmData.length * sizeof(uint8_t));

    // The length of the encoded packet
    opus_int32 encodedByteCount = opus_encode(_encoder, data, frameSize, outBuffer, (opus_int32)pcmData.length);

    if (encodedByteCount < 0) {
        NSLog(@"encoding error %@", [self opusErrorMessage:encodedByteCount]);
        return nil;
    }

    // Opus data initialized with size in the first byte
    NSMutableData* outputData = [[NSMutableData alloc] initWithCapacity:frameSize * 2];
    // Append Opus data
    [outputData appendData:[NSData dataWithBytes:outBuffer length:encodedByteCount]];

    return outputData;
}

/**
 *  opusToPCM
 *
 *  @param oggopus - NSData object containing opus audio in ogg container
 *
 *  @return NSData = raw PCM
 */
- (NSData*)opusToPCM:(NSData*)oggOpus sampleRate:(long)sampleRate
{

    return [self decodeOggOpus:oggOpus sampleRate:sampleRate];
}

/**
 *  decodeOggOpus
 *
 *  @param oggopus NSData containing ogg opus audio
 *
 *  @return NSData - contains PCM audio
 */
- (NSData*)decodeOggOpus:(NSData*)oggopus sampleRate:(long)sampleRate
{

    NSMutableData* pcmOut = [[NSMutableData alloc] init];

    ogg_sync_state oy;
    ogg_page og;
    ogg_packet op;
    ogg_stream_state os;
    ogg_int64_t audio_size = 0;
    ogg_int32_t opus_serialno = 0;
    ogg_int64_t page_granule = 0;
    ogg_int64_t link_out = 0;
    OpusMSDecoder* st = NULL;
    opus_int64 packet_count = 0;

    int eos = 0;
    int channels = -1;
    int mapping_family;
    int rate = (int)sampleRate;
    int wav_format = 0;
    int preskip = 0;
    int gran_offset = 0;
    int has_opus_stream = 0;
    int has_tags_packet = 0;
    int fp = 0;
    int streams = 0;
    int frame_size = 0;
    int total_links = 0;
    int stream_init = 0;
    float manual_gain = 0;
    float gain = 1;
    float* output = 0;

    ogg_sync_init(&oy);

    int processedByteCount = 0;
    int opusLength = [[NSNumber numberWithLong:[oggopus length]] intValue];

    while (processedByteCount < opusLength) {
        char* data;
        int buffersize = (200 < opusLength - processedByteCount) ? 200 : opusLength - processedByteCount;
        data = ogg_sync_buffer(&oy, buffersize);

        NSRange range = { processedByteCount, buffersize };
        [oggopus getBytes:data range:range];
        processedByteCount += buffersize;

        ogg_sync_wrote(&oy, buffersize);

        /*Loop for all complete pages we got (most likely only one)*/
        while (ogg_sync_pageout(&oy, &og) == 1) {
            if (stream_init == 0) {
                ogg_stream_init(&os, ogg_page_serialno(&og));
                stream_init = 1;
            }
            if (ogg_page_serialno(&og) != os.serialno) {
                /* so all streams are read. */
                ogg_stream_reset_serialno(&os, ogg_page_serialno(&og));
            }
            /*Add page to the bitstream*/
            ogg_stream_pagein(&os, &og);
            page_granule = ogg_page_granulepos(&og);

            /*Extract all available packets*/
            while (ogg_stream_packetout(&os, &op) == 1) {
                /*OggOpus streams are identified by a magic string in the initial
                 stream header.*/
                if (op.b_o_s && op.bytes >= 8 && !memcmp(op.packet, "OpusHead", 8)) {
                    if (has_opus_stream && has_tags_packet) {
                        /*If we're seeing another BOS OpusHead now it means
                         the stream is chained without an EOS.*/
                        has_opus_stream = 0;
                        if (st)
                            opus_multistream_decoder_destroy(st);
                        st = NULL;
                        NSLog(@"Warning: stream ended without EOS and a new stream began");
                    }
                    if (!has_opus_stream) {
                        if (packet_count > 0 && opus_serialno == os.serialno) {
                            NSLog(@"Apparent chaining without changing serial number");
                            return nil;
                        }
                        opus_serialno = (ogg_int32_t)os.serialno;
                        has_opus_stream = 1;
                        has_tags_packet = 0;
                        link_out = 0;
                        packet_count = 0;
                        eos = 0;
                        total_links++;
                    }
                    else {
                        NSLog(@"Warning: ignoring opus stream");
                    }
                }

                if (!has_opus_stream || os.serialno != opus_serialno)
                    break;
                /*If first packet in a logical stream, process the Opus header*/
                if (packet_count == 0) {
                    st = process_header(&op, &rate, &mapping_family, &channels, &preskip, &gain, manual_gain, &streams, wav_format);
                    if (!st)
                        return nil;

                    if (ogg_stream_packetout(&os, &op) != 0 || og.header[og.header_len - 1] == 255) {
                        /*The format specifies that the initial header and tags packets are on their
                         own pages. To aid implementors in discovering that their files are wrong
                         we reject them explicitly here. In some player designs files like this would
                         fail even without an explicit test.*/
                        fprintf(stderr, "Extra packets on initial header page. Invalid stream.\n");
                        return nil;
                    }

                    /*Remember how many samples at the front we were told to skip
                     so that we can adjust the timestamp counting.*/
                    gran_offset = preskip;

                    if (!output)
                        output = malloc(sizeof(float) * MAX_FRAME_SIZE * channels);
                }
                else if (packet_count == 1) {
                    has_tags_packet = 1;
                    if (ogg_stream_packetout(&os, &op) != 0 || og.header[og.header_len - 1] == 255) {
                        NSLog(@"Extra packets on initial tags page. Invalid stream.");
                        return nil;
                    }
                }
                else {
                    int ret;
                    opus_int64 maxout;
                    opus_int64 outsamp;

                    /*Decode Opus packet*/
                    ret = opus_multistream_decode_float(st, (unsigned char*)op.packet, (opus_int32)op.bytes, output, MAX_FRAME_SIZE, 0);

                    /*If the decoder returned less than zero, we have an error.*/
                    if (ret < 0) {
                        fprintf(stderr, "Decoding error: %s\n", opus_strerror(ret));
                        break;
                    }
                    frame_size = ret;

                    /*This handles making sure that our output duration respects
                     the final end-trim by not letting the output sample count
                     get ahead of the granpos indicated value.*/
                    maxout = ((page_granule - gran_offset) * rate / 48000) - link_out;
                    outsamp = audio_write(output, channels, frame_size, pcmOut, &preskip, 1, 0 > maxout ? 0 : maxout, fp);
                    link_out += outsamp;
                    audio_size += (fp ? 4 : 2) * outsamp * channels;
                }
                packet_count++;
            }
        }
    }

    if (!total_links)
        fprintf(stderr, "This doesn't look like a Opus file\n");
    opus_multistream_decoder_destroy(st);
    if (stream_init)
        ogg_stream_clear(&os);
    ogg_sync_clear(&oy);
    if (output) {
        free(output);
    }

    return pcmOut;
}

#pragma mark static methods

/*Process an Opus header and setup the opus decoder based on it.
 It takes several pointers for header values which are needed
 elsewhere in the code.*/
static OpusMSDecoder* process_header(ogg_packet* op, opus_int32* rate,
    int* mapping_family, int* channels, int* preskip, float* gain,
    float manual_gain, int* streams, int wav_format)
{
    int err;
    OpusMSDecoder* st;
    OpusHeader header;

    if (opus_header_parse(op->packet, (ogg_int32_t)op->bytes, &header) == 0) {
        fprintf(stderr, "Cannot parse header\n");
        return NULL;
    }

    *mapping_family = header.channel_mapping;
    *channels = header.channels;

    if (!*rate)
        *rate = header.input_sample_rate;
    /*If the rate is unspecified we decode to 48000*/
    if (*rate == 0)
        *rate = 48000;
    if (*rate < 8000 || *rate > 192000) {
        fprintf(stderr, "Warning: Crazy input_rate %d, decoding to 48000 instead.\n", *rate);
        *rate = 48000;
    }

    if (header.input_sample_rate != *rate)
        fprintf(stderr, "\n\n\n*** Sample rate detected: %d, using: %d ***\n\n\n", header.input_sample_rate, *rate);

    *preskip = header.preskip;
    st = opus_multistream_decoder_create(48000, header.channels, header.nb_streams, header.nb_coupled, header.stream_map, &err);
    if (err != OPUS_OK) {
        fprintf(stderr, "Cannot create decoder: %s\n", opus_strerror(err));
        return NULL;
    }
    if (!st) {
        fprintf(stderr, "Decoder initialization failed: %s\n", opus_strerror(err));
        return NULL;
    }

    *streams = header.nb_streams;

    fprintf(stderr, "Decoding to %d Hz (%d channel%s)", *rate,
        *channels, *channels > 1 ? "s" : "");
    if (header.version != 1)
        fprintf(stderr, ", Header v%d", header.version);
    fprintf(stderr, "\n");

    if (header.gain != 0)
        fprintf(stderr, "Playback gain: %f dB\n", header.gain / 256.);
    if (manual_gain != 0)
        fprintf(stderr, "Manual gain: %f dB\n", manual_gain);

    return st;
}

static opus_int64 audio_write(float* pcm, int channels, int frame_size, NSMutableData* fout,
    int* skip, int file, opus_int64 maxout, int fp)
{
    opus_int64 sampout = 0;
    int i, tmp_skip;
    unsigned out_len;
    short* out;
    float* output;
    out = alloca(sizeof(short) * MAX_FRAME_SIZE * channels);
    maxout = maxout < 0 ? 0 : maxout;

    if (skip) {
        tmp_skip = (*skip > frame_size) ? (int)frame_size : *skip;
        *skip -= tmp_skip;
    }
    else {
        tmp_skip = 0;
    }

    output = pcm + channels * tmp_skip;
    out_len = frame_size - tmp_skip;
    frame_size = 0;

    for (i = 0; i < (int)out_len * channels; i++) {
        out[i] = (short)float2int(fmaxf(-32768, fminf(output[i] * 32768.f, 32767)));
    }

    if (maxout > 0) {
        [fout appendBytes:out length:out_len * 2];
        sampout += out_len;
        maxout -= out_len;
    }

    return sampout;
}

@end