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
 
 **Entity**
 
 Returned by the AlchemyLanguage & AlchemyDataNews services.
 
 */
public final class Entity: AlchemyGenericModel {
    
    // MARK: AlchemyGenericModel
    public var totalTransactions: Int!
    
    // MARK: Entity
    public var count: Int!
    public var disambiguated: DisambiguatedLinks!
    public var knowledgeGraph: KnowledgeGraph!
    public var quotations: [Quotation]! = []
    public var relevance: Double!
    public var sentiment: Sentiment!
    public var text: String!
    public var type: String!
    
}
