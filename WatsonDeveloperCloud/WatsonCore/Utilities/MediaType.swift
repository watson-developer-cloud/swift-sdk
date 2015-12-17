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

import Foundation

/// Common MIME media types for use in HTTP headers.
public enum MediaType: String {
    case Plain = "text/plain"
    case HTML = "text/html"
    case JSON = "application/json"
    case CSV = "text/csv"
    case OctetStream = "application/octet-stream"
    case WDSJSON = "application/wds+json"
    case WDSXML = "application/wds+xml"
    case OPUS = "audio/ogg; codecs=opus"
    case WAV = "audio/wav"
    case FLAC = "audio/flac"
    case PCM = "audio/l16"
}