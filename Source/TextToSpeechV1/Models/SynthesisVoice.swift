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

/** A voice to be used for synthesis. */
public enum SynthesisVoice {
    case DE_Birgit
    case DE_Dieter
    case GB_Kate
    case US_Allison
    case US_Lisa
    case US_Michael
    case ES_Enrique
    case ES_Laura
    case US_Sofia
    case FR_Renee
    case IT_Francesca
    case JP_Emi
    case BR_Isabela
    case Custom(voice: String)
    
    /// Represent the voice as a `String`.
    internal func description() -> String {
        switch self {
        case DE_Birgit: return "de-DE_BirgitVoice"
        case DE_Dieter: return "de-DE_DieterVoice"
        case GB_Kate: return "en-GB_KateVoice"
        case ES_Enrique: return "es-ES_EnriqueVoice"
        case US_Allison: return "en-US_AllisonVoice"
        case US_Lisa: return "en-US_LisaVoice"
        case US_Michael: return "en-US_MichaelVoice"
        case ES_Laura: return "es-ES_LauraVoice"
        case US_Sofia: return "es-US_SofiaVoice"
        case FR_Renee: return "fr-FR_ReneeVoice"
        case IT_Francesca: return "it-IT_FrancescaVoice"
        case JP_Emi: return "ja-JP_EmiVoice"
        case BR_Isabela: return "pt-BR_IsabelaVoice"
        case Custom(let voice): return voice
        }
    }
}
