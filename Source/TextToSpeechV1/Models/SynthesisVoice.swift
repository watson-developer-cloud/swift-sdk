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
    case DE_Birgit
    
    /// German with a male voice (`de-DE_DieterVoice`).
    case DE_Dieter
    
    /// English (British dialect) with a female voice (`en-GB_KateVoice`).
    case GB_Kate
    
    /// English (US dialect) with a female voice (`en-US_AllisonVoice`).
    case US_Allison
    
    /// English (US dialect) with a female voice (`en-US_LisaVoice`).
    case US_Lisa
    
    /// English (US dialect) with a male voice (`en-US_MichaelVoice`).
    case US_Michael
    
    /// Spanish (Castillian dialect) with a male voice (`es-ES_EnriqueVoice`).
    case ES_Enrique
    
    /// Spanish (Castillian dialect) with a female voice (`es-ES_LauraVoice`).
    case ES_Laura
    
    /// Spanish (North-American dialect) with a female voice (`es-US_SofiaVoice`).
    case US_Sofia
    
    /// French with a female voice (`fr-FR_ReneeVoice`).
    case FR_Renee
    
    /// Italian with a female voice (`it-IT_FrancescaVoice`).
    case IT_Francesca
    
    /// Japanese with a female voice (`ja-JP_EmiVoice`).
    case JP_Emi
    
    /// Brazilian Portuguese with a female voice (`pt-BR_IsabelaVoice`).
    case BR_Isabela
    
    /// A custom voice.
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
