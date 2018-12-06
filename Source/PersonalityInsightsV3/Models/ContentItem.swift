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

/** ContentItem. */
public struct ContentItem: Codable, Equatable {

    /**
     The MIME type of the content. The default is plain text. The tags are stripped from HTML content before it is
     analyzed; plain text is processed as submitted.
     */
    public enum Contenttype: String {
        case textPlain = "text/plain"
        case textHTML = "text/html"
    }

    /**
     The language identifier (two-letter ISO 639-1 identifier) for the language of the content item. The default is `en`
     (English). Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. A
     language specified with the **Content-Type** parameter overrides the value of this parameter; any content items
     that specify a different language are ignored. Omit the **Content-Type** parameter to base the language on the most
     prevalent specification among the content items; again, content items that specify a different language are
     ignored. You can specify any combination of languages for the input and response content.
     */
    public enum Language: String {
        case ar = "ar"
        case en = "en"
        case es = "es"
        case ja = "ja"
        case ko = "ko"
    }

    /**
     The content that is to be analyzed. The service supports up to 20 MB of content for all `ContentItem` objects
     combined.
     */
    public var content: String

    /**
     A unique identifier for this content item.
     */
    public var id: String?

    /**
     A timestamp that identifies when this content was created. Specify a value in milliseconds since the UNIX Epoch
     (January 1, 1970, at 0:00 UTC). Required only for results that include temporal behavior data.
     */
    public var created: Int?

    /**
     A timestamp that identifies when this content was last updated. Specify a value in milliseconds since the UNIX
     Epoch (January 1, 1970, at 0:00 UTC). Required only for results that include temporal behavior data.
     */
    public var updated: Int?

    /**
     The MIME type of the content. The default is plain text. The tags are stripped from HTML content before it is
     analyzed; plain text is processed as submitted.
     */
    public var contenttype: String?

    /**
     The language identifier (two-letter ISO 639-1 identifier) for the language of the content item. The default is `en`
     (English). Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. A
     language specified with the **Content-Type** parameter overrides the value of this parameter; any content items
     that specify a different language are ignored. Omit the **Content-Type** parameter to base the language on the most
     prevalent specification among the content items; again, content items that specify a different language are
     ignored. You can specify any combination of languages for the input and response content.
     */
    public var language: String?

    /**
     The unique ID of the parent content item for this item. Used to identify hierarchical relationships between
     posts/replies, messages/replies, and so on.
     */
    public var parentid: String?

    /**
     Indicates whether this content item is a reply to another content item.
     */
    public var reply: Bool?

    /**
     Indicates whether this content item is a forwarded/copied version of another content item.
     */
    public var forward: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case content = "content"
        case id = "id"
        case created = "created"
        case updated = "updated"
        case contenttype = "contenttype"
        case language = "language"
        case parentid = "parentid"
        case reply = "reply"
        case forward = "forward"
    }

    /**
     Initialize a `ContentItem` with member variables.

     - parameter content: The content that is to be analyzed. The service supports up to 20 MB of content for all
       `ContentItem` objects combined.
     - parameter id: A unique identifier for this content item.
     - parameter created: A timestamp that identifies when this content was created. Specify a value in milliseconds
       since the UNIX Epoch (January 1, 1970, at 0:00 UTC). Required only for results that include temporal behavior
       data.
     - parameter updated: A timestamp that identifies when this content was last updated. Specify a value in
       milliseconds since the UNIX Epoch (January 1, 1970, at 0:00 UTC). Required only for results that include temporal
       behavior data.
     - parameter contenttype: The MIME type of the content. The default is plain text. The tags are stripped from
       HTML content before it is analyzed; plain text is processed as submitted.
     - parameter language: The language identifier (two-letter ISO 639-1 identifier) for the language of the content
       item. The default is `en` (English). Regional variants are treated as their parent language; for example, `en-US`
       is interpreted as `en`. A language specified with the **Content-Type** parameter overrides the value of this
       parameter; any content items that specify a different language are ignored. Omit the **Content-Type** parameter
       to base the language on the most prevalent specification among the content items; again, content items that
       specify a different language are ignored. You can specify any combination of languages for the input and response
       content.
     - parameter parentid: The unique ID of the parent content item for this item. Used to identify hierarchical
       relationships between posts/replies, messages/replies, and so on.
     - parameter reply: Indicates whether this content item is a reply to another content item.
     - parameter forward: Indicates whether this content item is a forwarded/copied version of another content item.

     - returns: An initialized `ContentItem`.
    */
    public init(
        content: String,
        id: String? = nil,
        created: Int? = nil,
        updated: Int? = nil,
        contenttype: String? = nil,
        language: String? = nil,
        parentid: String? = nil,
        reply: Bool? = nil,
        forward: Bool? = nil
    )
    {
        self.content = content
        self.id = id
        self.created = created
        self.updated = updated
        self.contenttype = contenttype
        self.language = language
        self.parentid = parentid
        self.reply = reply
        self.forward = forward
    }

}
