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
 Object containing source parameters for the configuration.
 */
public struct Source: Codable, Equatable {

    /**
     The type of source to connect to.
     -  `box` indicates the configuration is to connect an instance of Enterprise Box.
     -  `salesforce` indicates the configuration is to connect to Salesforce.
     -  `sharepoint` indicates the configuration is to connect to Microsoft SharePoint Online.
     */
    public enum TypeEnum: String {
        case box = "box"
        case salesforce = "salesforce"
        case sharepoint = "sharepoint"
    }

    /**
     The type of source to connect to.
     -  `box` indicates the configuration is to connect an instance of Enterprise Box.
     -  `salesforce` indicates the configuration is to connect to Salesforce.
     -  `sharepoint` indicates the configuration is to connect to Microsoft SharePoint Online.
     */
    public var type: String?

    /**
     The **credential_id** of the credentials to use to connect to the source. Credentials are defined using the
     **credentials** method. The **source_type** of the credentials used must match the **type** field specified in this
     object.
     */
    public var credentialID: String?

    /**
     Object containing the schedule information for the source.
     */
    public var schedule: SourceSchedule?

    /**
     The **options** object defines which items to crawl from the source system.
     */
    public var options: SourceOptions?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case credentialID = "credential_id"
        case schedule = "schedule"
        case options = "options"
    }

    /**
     Initialize a `Source` with member variables.

     - parameter type: The type of source to connect to.
       -  `box` indicates the configuration is to connect an instance of Enterprise Box.
       -  `salesforce` indicates the configuration is to connect to Salesforce.
       -  `sharepoint` indicates the configuration is to connect to Microsoft SharePoint Online.
     - parameter credentialID: The **credential_id** of the credentials to use to connect to the source. Credentials
       are defined using the **credentials** method. The **source_type** of the credentials used must match the **type**
       field specified in this object.
     - parameter schedule: Object containing the schedule information for the source.
     - parameter options: The **options** object defines which items to crawl from the source system.

     - returns: An initialized `Source`.
    */
    public init(
        type: String? = nil,
        credentialID: String? = nil,
        schedule: SourceSchedule? = nil,
        options: SourceOptions? = nil
    )
    {
        self.type = type
        self.credentialID = credentialID
        self.schedule = schedule
        self.options = options
    }

}
