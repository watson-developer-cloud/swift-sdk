/**
 * Copyright IBM Corporation 2015
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

/// The Constants needed for the input keys for the parameters
public class VisionConstants
{
  public static let visionServiceURL = "/calls"
  
  // For GetImage
  public enum ImageLinkType: String {
    case HTML = "html"
    case URL = "url"
  }
  
  // For getImageKeywords
  public enum ImageKeywordType: String {
    case UIImage = "file"
    case URL = "url"
  }
  
  // For recognizeFaces
  public enum ImageFacesType: String {
    case UIImage = "file"
    case URL = "url"
  }
  
  public enum VisionPrefix: String {
    case URL = "/url/"
    case Image = "/image/"
    case HTML = "/html/"
  }
  
  // Image Link Extraction
  public enum ImageLinkExtraction: String {
    case URLGetImage = "URLGetImage"
    case HTMLGetImage = "HTMLGetImage"
  }
  
  // Image Tagging API
  public enum ImageTagging: String {
    case URLGetRankedImageKeywords = "URLGetRankedImageKeywords"
    case ImageGetRankedImageKeywords = "ImageGetRankedImageKeywords"
  }
  
  // Face Detection
  public enum FaceDetection: String {
    case URLGetRankedImageFaceTags = "URLGetRankedImageFaceTags"
    case ImageGetRankedImageFaceTags = "ImageGetRankedImageFaceTags"
  }
  
  public enum Model: String {
    case TotalTransactions = "totalTransactions"
  }
  
  /**
   Input Parameter Keys
   */
  public enum OutputMode: String {
    case JSON = "json"
    case HTML = "html"
    case XML = "xml"
    case RDF = "rdf"
  }
  
  public enum ImagePostMode: String {
    case Raw = "raw"
    case Not_Raw = "not-raw"
  }
  
  public enum ForceShowAll: String {
    case True = "1"
    case False = "0"
  }
  
  public enum KnowledgeGraph: String {
    case True = "1'"
    case False = "0"
  }
  
  /**
  This enum is used to build the base URI for each call
  */
  public enum WatsonURI: String {
    case URL = "url"
    case APIKey = "apikey"
  }
  
  /**
   This enum is used to build the full URL
   */
  public enum VisionURI: String {
    case OutputMode = "outputMode"
    case ForceShowAll = "forceShowAll"
    case KnowledgeGraph = "knowledgeGraph"
    case ImagePostMode = "imagePostMode"
  }
}
