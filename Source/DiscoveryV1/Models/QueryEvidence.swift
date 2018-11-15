/**
 * Copyright IBM Corporation 2018
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

/**
 Description of evidence location supporting Knoweldge Graph query result.
 */
public struct QueryEvidence: Codable, Equatable {

    /**
     The docuemnt ID (as indexed in Discovery) of the evidence location.
     */
    public var documentID: String?

    /**
     The field of the document where the supporting evidence was identified.
     */
    public var field: String?

    /**
     The start location of the evidence in the identified field. This value is inclusive.
     */
    public var startOffset: Int?

    /**
     The end location of the evidence in the identified field. This value is inclusive.
     */
    public var endOffset: Int?

    /**
     An array of entity objects that show evidence of the result.
     */
    public var entities: [QueryEvidenceEntity]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case field = "field"
        case startOffset = "start_offset"
        case endOffset = "end_offset"
        case entities = "entities"
    }

}
