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

let car: Data = loadResource(name: "car", ext: "png")
let cars: Data = loadResource(name: "cars", ext: "zip")
let carz: Data = loadResource(name: "carz", ext: "zip")
let trucks: Data = loadResource(name: "trucks", ext: "zip")
let baseball: Data = loadResource(name: "baseball", ext: "zip")
let faces: Data = loadResource(name: "faces", ext: "zip")
let face1: Data = loadResource(name: "face1", ext: "jpg")
let obama: Data = loadResource(name: "obama", ext: "jpg")
let sign: Data = loadResource(name: "sign", ext: "jpg")

let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
"Administration/People/president_official_portrait_lores.jpg"
let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk" +
"/master/visual-recognition/src/test/resources/visual_recognition/car.png"
let signURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk/" +
"master/visual-recognition/src/test/resources/visual_recognition/open.png"

func loadResource(name: String, ext: String) -> Data {
    #if os(Linux)
    let url = URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Resources/" + name + "." + ext)
    #else
    let bundle = Bundle(for: VisualRecognitionTests.self)
    guard let url = bundle.url(forResource: name, withExtension: ext) else {
        XCTFail("Unable to locate sample image files.")
        assert(false)
    }
    #endif
    guard let data = try? Data(contentsOf: url) else {
        XCTFail("Unable to locate sample image files.")
        assert(false)
    }
    return data
}
