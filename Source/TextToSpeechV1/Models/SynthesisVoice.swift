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
public enum SynthesisVoice: String {
    
    /// German with a female voice (`de-DE_BirgitVoice`).
    case de_Birgit = "de-DE_BirgitVoice"
    
    /// German with a male voice (`de-DE_DieterVoice`).
    case de_Dieter = "de-DE_DieterVoice"
    
    /// English (British dialect) with a female voice (`en-GB_KateVoice`).
    case gb_Kate = "en-GB_KateVoice"
    
    /// English (US dialect) with a female voice (`en-US_AllisonVoice`).
    case us_Allison = "en-US_AllisonVoice"
    
    /// English (US dialect) with a female voice (`en-US_LisaVoice`).
    case us_Lisa = "en-US_LisaVoice"
    
    /// English (US dialect) with a male voice (`en-US_MichaelVoice`).
    case us_Michael = "en-US_MichaelVoice"
    
    /// Spanish (Castillian dialect) with a male voice (`es-ES_EnriqueVoice`).
    case es_Enrique = "es-ES_EnriqueVoice"
    
    /// Spanish (Castillian dialect) with a female voice (`es-ES_LauraVoice`).
    case es_Laura = "es-ES_LauraVoice"
    
    /// Spanish (North-American dialect) with a female voice (`es-US_SofiaVoice`).
    case us_Sofia = "es-US_SofiaVoice"
    
    /// French with a female voice (`fr-FR_ReneeVoice`).
    case fr_Renee = "fr-FR_ReneeVoice"
    
    /// Italian with a female voice (`it-IT_FrancescaVoice`).
    case it_Francesca = "it-IT_FrancescaVoice"
    
    /// Japanese with a female voice (`ja-JP_EmiVoice`).
    case jp_Emi = "ja-JP_EmiVoice"
    
    /// Brazilian Portuguese with a female voice (`pt-BR_IsabelaVoice`).
    case br_Isabela = "pt-BR_IsabelaVoice"
}
