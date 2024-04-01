//
//  VideoModel.swift
//  Smart Traffic
//
//  Created by TaiTau on 06/01/2024.
//

import Foundation
struct VideoModel: Codable {
    let VIDEO_ID: String
    let USER_ID: Int
    let NAME: String
    let USER_NAME: String
    let CAMERA_ID: Int
    let URL_IN: String
    let DATE: String?
}
