/**
 * Copyright IBM Corporation 2016
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

#import <UIKit/UIKit.h>

//! Project version number for SpeechToTextV1.
FOUNDATION_EXPORT double SpeechToTextV1VersionNumber;

//! Project version string for SpeechToTextV1.
FOUNDATION_EXPORT const unsigned char SpeechToTextV1VersionString[];

// Import ogg and opus headers to access C code from Swift
#import "ogg.h"
#import "opus.h"
#import "opus_multistream.h"