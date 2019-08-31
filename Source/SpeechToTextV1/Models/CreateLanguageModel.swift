/**
 * (C) Copyright IBM Corp. 2018, 2019.
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
 Information about the new custom language model.
 */
internal struct CreateLanguageModel: Codable, Equatable {

    /**
     The name of the base language model that is to be customized by the new custom language model. The new custom model
     can be used only with the base model that it customizes.
     To determine whether a base model supports language model customization, use the **Get a model** method and check
     that the attribute `custom_language_model` is set to `true`. You can also refer to [Language support for
     customization](https://cloud.ibm.com/docs/services/speech-to-text?topic=speech-to-text-customization#languageSupport).
     */
    public enum BaseModelName: String {
        case deDeBroadbandmodel = "de-DE_BroadbandModel"
        case deDeNarrowbandmodel = "de-DE_NarrowbandModel"
        case enGbBroadbandmodel = "en-GB_BroadbandModel"
        case enGbNarrowbandmodel = "en-GB_NarrowbandModel"
        case enUsBroadbandmodel = "en-US_BroadbandModel"
        case enUsNarrowbandmodel = "en-US_NarrowbandModel"
        case enUsShortformNarrowbandmodel = "en-US_ShortForm_NarrowbandModel"
        case esArBroadbandmodel = "es-AR_BroadbandModel"
        case esArNarrowbandmodel = "es-AR_NarrowbandModel"
        case esClBroadbandmodel = "es-CL_BroadbandModel"
        case esClNarrowbandmodel = "es-CL_NarrowbandModel"
        case esCoBroadbandmodel = "es-CO_BroadbandModel"
        case esCoNarrowbandmodel = "es-CO_NarrowbandModel"
        case esEsBroadbandmodel = "es-ES_BroadbandModel"
        case esEsNarrowbandmodel = "es-ES_NarrowbandModel"
        case esMxBroadbandmodel = "es-MX_BroadbandModel"
        case esMxNarrowbandmodel = "es-MX_NarrowbandModel"
        case esPeBroadbandmodel = "es-PE_BroadbandModel"
        case esPeNarrowbandmodel = "es-PE_NarrowbandModel"
        case frFrBroadbandmodel = "fr-FR_BroadbandModel"
        case frFrNarrowbandmodel = "fr-FR_NarrowbandModel"
        case jaJpBroadbandmodel = "ja-JP_BroadbandModel"
        case jaJpNarrowbandmodel = "ja-JP_NarrowbandModel"
        case koKrBroadbandmodel = "ko-KR_BroadbandModel"
        case koKrNarrowbandmodel = "ko-KR_NarrowbandModel"
        case ptBrBroadbandmodel = "pt-BR_BroadbandModel"
        case ptBrNarrowbandmodel = "pt-BR_NarrowbandModel"
    }

    /**
     A user-defined name for the new custom language model. Use a name that is unique among all custom language models
     that you own. Use a localized name that matches the language of the custom model. Use a name that describes the
     domain of the custom model, such as `Medical custom model` or `Legal custom model`.
     */
    public var name: String

    /**
     The name of the base language model that is to be customized by the new custom language model. The new custom model
     can be used only with the base model that it customizes.
     To determine whether a base model supports language model customization, use the **Get a model** method and check
     that the attribute `custom_language_model` is set to `true`. You can also refer to [Language support for
     customization](https://cloud.ibm.com/docs/services/speech-to-text?topic=speech-to-text-customization#languageSupport).
     */
    public var baseModelName: String

    /**
     The dialect of the specified language that is to be used with the custom language model. For most languages, the
     dialect matches the language of the base model by default. For example, `en-US` is used for either of the US
     English language models.
     For a Spanish language, the service creates a custom language model that is suited for speech in one of the
     following dialects:
     * `es-ES` for Castilian Spanish (`es-ES` models)
     * `es-LA` for Latin American Spanish (`es-AR`, `es-CL`, `es-CO`, and `es-PE` models)
     * `es-US` for Mexican (North American) Spanish (`es-MX` models)
     The parameter is meaningful only for Spanish models, for which you can always safely omit the parameter to have the
     service create the correct mapping.
     If you specify the `dialect` parameter for non-Spanish language models, its value must match the language of the
     base model. If you specify the `dialect` for Spanish language models, its value must match one of the defined
     mappings as indicated (`es-ES`, `es-LA`, or `es-MX`). All dialect values are case-insensitive.
     */
    public var dialect: String?

    /**
     A description of the new custom language model. Use a localized description that matches the language of the custom
     model.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case baseModelName = "base_model_name"
        case dialect = "dialect"
        case description = "description"
    }

    /**
     Initialize a `CreateLanguageModel` with member variables.

     - parameter name: A user-defined name for the new custom language model. Use a name that is unique among all
       custom language models that you own. Use a localized name that matches the language of the custom model. Use a
       name that describes the domain of the custom model, such as `Medical custom model` or `Legal custom model`.
     - parameter baseModelName: The name of the base language model that is to be customized by the new custom
       language model. The new custom model can be used only with the base model that it customizes.
       To determine whether a base model supports language model customization, use the **Get a model** method and check
       that the attribute `custom_language_model` is set to `true`. You can also refer to [Language support for
       customization](https://cloud.ibm.com/docs/services/speech-to-text?topic=speech-to-text-customization#languageSupport).
     - parameter dialect: The dialect of the specified language that is to be used with the custom language model.
       For most languages, the dialect matches the language of the base model by default. For example, `en-US` is used
       for either of the US English language models.
       For a Spanish language, the service creates a custom language model that is suited for speech in one of the
       following dialects:
       * `es-ES` for Castilian Spanish (`es-ES` models)
       * `es-LA` for Latin American Spanish (`es-AR`, `es-CL`, `es-CO`, and `es-PE` models)
       * `es-US` for Mexican (North American) Spanish (`es-MX` models)
       The parameter is meaningful only for Spanish models, for which you can always safely omit the parameter to have
       the service create the correct mapping.
       If you specify the `dialect` parameter for non-Spanish language models, its value must match the language of the
       base model. If you specify the `dialect` for Spanish language models, its value must match one of the defined
       mappings as indicated (`es-ES`, `es-LA`, or `es-MX`). All dialect values are case-insensitive.
     - parameter description: A description of the new custom language model. Use a localized description that
       matches the language of the custom model.

     - returns: An initialized `CreateLanguageModel`.
     */
    public init(
        name: String,
        baseModelName: String,
        dialect: String? = nil,
        description: String? = nil
    )
    {
        self.name = name
        self.baseModelName = baseModelName
        self.dialect = dialect
        self.description = description
    }

}
