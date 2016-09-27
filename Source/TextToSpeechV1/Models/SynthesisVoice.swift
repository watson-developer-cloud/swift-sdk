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
    
    /// German with a female voice (`de-DE_BirgitVoice`).
    case de_Birgit
    
    /// German with a male voice (`de-DE_DieterVoice`).
    case de_Dieter
    
    /// English (British dialect) with a female voice (`en-GB_KateVoice`).
    case gb_Kate
    
    /// English (US dialect) with a female voice (`en-US_AllisonVoice`).
    case us_Allison
    
    /// English (US dialect) with a female voice (`en-US_LisaVoice`).
    case us_Lisa
    
    /// English (US dialect) with a male voice (`en-US_MichaelVoice`).
    case us_Michael
    
    /// Spanish (Castillian dialect) with a male voice (`es-ES_EnriqueVoice`).
    case es_Enrique
    
    /// Spanish (Castillian dialect) with a female voice (`es-ES_LauraVoice`).
    case es_Laura
    
    /// Spanish (North-American dialect) with a female voice (`es-US_SofiaVoice`).
    case us_Sofia
    
    /// French with a female voice (`fr-FR_ReneeVoice`).
    case fr_Renee
    
    /// Italian with a female voice (`it-IT_FrancescaVoice`).
    case it_Francesca
    
    /// Japanese with a female voice (`ja-JP_EmiVoice`).
    case jp_Emi
    
    /// Brazilian Portuguese with a female voice (`pt-BR_IsabelaVoice`).
    case br_Isabela
    
    /// A custom voice.
    case custom(voice: String)
    
    /// Represent the voice as a `String`.
    internal func description() -> String {
        switch self {
        case .de_Birgit: return "de-DE_BirgitVoice"
        case .de_Dieter: return "de-DE_DieterVoice"
        case .gb_Kate: return "en-GB_KateVoice"
        case .es_Enrique: return "es-ES_EnriqueVoice"
        case .us_Allison: return "en-US_AllisonVoice"
        case .us_Lisa: return "en-US_LisaVoice"
        case .us_Michael: return "en-US_MichaelVoice"
        case .es_Laura: return "es-ES_LauraVoice"
        case .us_Sofia: return "es-US_SofiaVoice"
        case .fr_Renee: return "fr-FR_ReneeVoice"
        case .it_Francesca: return "it-IT_FrancescaVoice"
        case .jp_Emi: return "ja-JP_EmiVoice"
        case .br_Isabela: return "pt-BR_IsabelaVoice"
        case .custom(let voice): return voice
        }
    }
}
