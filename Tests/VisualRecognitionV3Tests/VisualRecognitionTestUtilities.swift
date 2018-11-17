/**
 * Copyright IBM Corporation 2016-2017
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
import XCTest
import VisualRecognitionV3

let car: URL = loadResource(name: "car", ext: "png")
let cars: URL = loadResource(name: "cars", ext: "zip")
let carz: URL = loadResource(name: "carz", ext: "zip")
let trucks: URL = loadResource(name: "trucks", ext: "zip")
let baseball: URL = loadResource(name: "baseball", ext: "zip")
let faces: URL = loadResource(name: "faces", ext: "zip")
let face1: URL = loadResource(name: "face1", ext: "jpg")
let obama: URL = loadResource(name: "obama", ext: "jpg")
let sign: URL = loadResource(name: "sign", ext: "jpg")

let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
"Administration/People/president_official_portrait_lores.jpg"
let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk" +
"/master/visual-recognition/src/test/resources/visual_recognition/car.png"
let signURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk/" +
"master/visual-recognition/src/test/resources/visual_recognition/open.png"

func loadResource(name: String, ext: String) -> URL {
    #if os(Linux)
    return URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Resources/" + name + "." + ext)
    #else
    let bundle = Bundle(for: VisualRecognitionTests.self)
    guard let url = bundle.url(forResource: name, withExtension: ext) else {
        XCTFail("Unable to locate sample image files.")
        assert(false)
    }
    return url
    #endif
}
