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

#import "OggHelper.h"

@implementation OggHelper

/**
 *  Initialize OggHelper instance
 *
 *  @return OggHelper instance
 */
- (OggHelper *) init{
    if (self = [super init]) {
        granulePos = 0;
        packetCount = 0;
        
        ogg_stream_init(&streamState, arc4random()%8888);
        
        return self;
    }
    return nil;
}

/**
 *  Write int - Little-endian
 *
 *  @param dest   Destination
 *  @param offset Offset
 *  @param value  Value
 */
void writeInt(unsigned char *dest, int offset, int value) {
    for(int i = 0;i < 4;i++) {
        dest[offset + i]=(unsigned char)(0xff & ((unsigned int)value)>>(i*8));
    }
}

/**
 *  Write short - Little-endian
 *
 *  @param dest   Destination
 *  @param offset Offset
 *  @param value  Value
 */
void writeShort(unsigned char *dest, int offset, int value) {
    for(int i = 0;i < 2;i++) {
        dest[offset + i]=(unsigned char)(0xff & ((unsigned int)value)>>(i*8));
    }
}

/**
 *  Write string - Little-endian
 *
 *  @param dest   Destination
 *  @param offset Offset
 *  @param value  Value
 *  @param length Length
 */
void writeString(unsigned char *dest, int offset, unsigned char *value, int length) {
    unsigned char *tempPointr = dest + offset;
    memcpy(tempPointr, value, length);
}

/**
 *  Get data of OggOpus packet
 *
 *  @param sampleRate Audio sample rate
 *
 *  @return NSMutableData instance
 */
- (NSData *) getOggOpusHeader:(int) sampleRate{
    packetCount = 0, granulePos = 0;
    long headerSize = 19;
    unsigned char opusHeader[headerSize];
    int offset = 0;
    // 0 - 7: OpusHead
    writeString(opusHeader, offset + 0, (unsigned char *)"OpusHead", 8);
    // Version, MUST The version number MUST always be '1' for this version of the encapsulation specification.
    opusHeader[offset + 8] = 1;
    // Output Channel Count
    opusHeader[offset + 9] = 1;
    // Pre-skip
    writeShort(opusHeader, offset + 10, 0);
    // Input Sample Rate (Hz)
    writeInt(opusHeader, offset + 12, sampleRate);
    // Output Gain (Q7.8 in dB), +/- 128 dB
    writeShort(opusHeader, offset + 16, 0);
    // Mapping Family (For channel mapping family 0, this value defaults to C-1 (i.e., 0 for mono and 1 for stereo), and is not coded.)
    opusHeader[offset + 18] = 0;

    ogg_packet opusHeaderPacket;
    opusHeaderPacket.packet = opusHeader;
    opusHeaderPacket.bytes = headerSize;
    opusHeaderPacket.b_o_s = 1;
    opusHeaderPacket.e_o_s = 0;
    opusHeaderPacket.granulepos = granulePos;
    opusHeaderPacket.packetno = packetCount++;
    ogg_stream_packetin(&streamState, &opusHeaderPacket);
    ogg_stream_flush(&streamState, &oggPage);
    
    NSMutableData *newData = [[NSMutableData alloc] initWithCapacity:0];
    [newData appendBytes:oggPage.header length:oggPage.header_len];
    [newData appendBytes:oggPage.body length:oggPage.body_len];
    
    NSLog(@"[Encoder] Ogg header, %ld bytes are written\n", opusHeaderPacket.bytes);

    offset = 0;
    NSString *comments = @"libopus";
    
    int commentsLength = (int)[comments lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Comments length=%d", commentsLength);
    unsigned char opusComments[commentsLength + 28];
    writeString(opusComments, offset, (unsigned char *)"OpusTags", 8);
    
    NSString *vendorString = @"IBM";
    int vendorStringLength = (int) vendorString.length;
    // Vendor String Length
    writeInt(opusComments, offset + 8, (int) vendorStringLength);
    // Vendor String
    writeString(opusComments, offset + 12, (unsigned char*)[comments cStringUsingEncoding:NSUTF8StringEncoding], vendorStringLength);
    // User Comment List Length
    writeInt(opusComments, offset + 20, 1);
    // Vendor comment size
    writeInt(opusComments, offset + 24, commentsLength);
    // Vendor comment
    writeString(opusComments, offset + 28, (unsigned char*)[comments cStringUsingEncoding:NSUTF8StringEncoding], commentsLength);
    
    ogg_packet opusCommentsPacket;
    opusCommentsPacket.packet = opusComments;
    opusCommentsPacket.bytes = commentsLength + 8;
    opusCommentsPacket.b_o_s = 0;
    opusCommentsPacket.e_o_s = 0;
    opusCommentsPacket.granulepos = 0;
    opusCommentsPacket.packetno = packetCount++;
    ogg_stream_packetin(&streamState, &opusCommentsPacket);
    ogg_stream_flush(&streamState, &oggPage);
    
    [newData appendBytes:oggPage.header length:oggPage.header_len];
    [newData appendBytes:oggPage.body length:oggPage.body_len];

    NSLog(@"[Encoder] Ogg comments, %ld bytes are written\n", opusCommentsPacket.bytes);
    
    return newData;
}

/**
 *  Write OggOpus packet
 *
 *  @param data      Opus data
 *  @param frameSize Frame size
 *
 *  @return NSMutableData instance or nil
 */
- (NSMutableData *) writePacket: (NSData*) data frameSize:(int) frameSize{
    ogg_packet packet;
    packet.packet = (unsigned char *)[data bytes];
    packet.bytes = (long)([data length]);
    packet.b_o_s = 0;
    packet.e_o_s = 0;
    granulePos += (frameSize * 2);
    packet.granulepos = granulePos;
    packet.packetno = packetCount++;
    ogg_stream_packetin(&streamState, &packet);

    if (ogg_stream_pageout(&streamState, &oggPage)) {
        NSMutableData *newData = [NSMutableData new];
        [newData appendBytes:oggPage.header length:oggPage.header_len];
        [newData appendBytes:oggPage.body length:oggPage.body_len];
        return newData;
    }
    return nil;
}

@end
