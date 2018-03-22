/**
 * Copyright IBM Corporation 2016-2017
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

/// An error from processing a network request or response.
public enum RestError: Error {

    /// No response was received from the server.
    case noResponse

    /// No data was returned from the server.
    case noData

    /// Failed to serialize value(s) to data.
    case serializationError

    /// Failed to replace special characters in the
    /// URL path with percent encoded characters.
    case encodingError

    /// FileManager failed to handle the given file.
    /// (The file may already exist or the disk may be full.)
    case fileManagerError

    /// Failed to load the given file.
    case invalidFile

    /// An HTTP error with a status code and description.
    case failure(Int, String)

}
