//
//  File.swift
//  Smart Traffic
//
//  Created by TaiTau on 19/01/2024.
//

import Foundation
struct ListImageResponse: Codable {
    let errors: ErrorObject
    let success: Int
    let videos: [[ImageModel]]
}
