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

import Foundation

/** The status of a translation model. */
public enum TrainingStatus: String {

    /// Training has completed and this translation model is
    /// ready for use with the Language Translator service.
    case available = "available"

    /// Training has just started.
    case starting = "starting"

    /// Training is still in progress.
    case training = "training"

    /// Training is uploading.
    case uploading = "uploading"

    /// Training has been uploaded.
    case uploaded = "uploaded"

    /// Training did not complete because of an error.
    case error = "error"
}
