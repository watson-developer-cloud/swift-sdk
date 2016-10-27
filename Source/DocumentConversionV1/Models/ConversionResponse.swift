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
import RestKit

/**
 
 **ConversionResponse**
 
 Response object for Document Conversion calls
 
*/
public struct ConversationResponse: JSONDecodable {
    
    /** Id of the source document */
    public let sourceDocId: String?
    
    /** Time of document conversion */
    public let timestamp: String?
    
    /** The type of media autodetected by the service */
    public let detectedMediaType: String?
    
    /** see **ConversionMetadata** */
    public let metadata: [ConversionMetadata]?
    
    /** see **AnswerUnits**/
    public let answerUnits: [AnswerUnits]?
    
    /** used inernally to initialize ConversationResponse objects */
    public init(json: JSON) throws {
        sourceDocId = try? json.getString(at: "source_document_id")
        timestamp = try? json.getString(at: "timestamp")
        detectedMediaType = try? json.getString(at: "media_type_detected")
        metadata = try? json.decodedArray(at: "metadata", type: ConversionMetadata.self)
        answerUnits = try? json.decodedArray(at: "answer_units", type: AnswerUnits.self)
    }
    
}
