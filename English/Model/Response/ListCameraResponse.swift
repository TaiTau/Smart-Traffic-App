//
//  ListCameraResponse.swift
//  Traffic-Light App
//
//  Created by TaiTau on 04/01/2024.
//

import Foundation
struct ListCameraResponse: Codable {
    let errors: ErrorObject
    let success: Int
    let cameras: [[CameraModelAPI]]
}
