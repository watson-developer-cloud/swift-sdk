/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import WatsonCore

/**
 * Combined returned by the {@link AlchemyLanguage} service.
 *
 */
public final class CombinedResults: AlchemyLanguageGenericModel {

    var author: String!
    var concepts: [Concepts]! = []
    var entities: [Entities]! = []
    var feeds: [Feed]! = []
    var image: String!
    var imageKeywords: [Keyword]! = []
    var keywords: [Keyword]! = []
    var publicationDate: PublicationDate!
    var relations: [SAORelation]! = []
    var sentiment: Sentiment!
    var taxonomy: Taxonomy!
    var title: String!
    // MARK: AlchemyLanguageGenericModel
    public var totalTransactions: Int!
    
    // MARK: AlchemyLanguageGenericModel
    public var language: String!
    public var url: String!
    

}
