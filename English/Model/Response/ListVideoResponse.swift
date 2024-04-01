//
//  ListVideoResponse.swift
//  Smart Traffic
//
//  Created by TaiTau on 06/01/2024.
//

import Foundation
struct ListVideoResponse: Codable {
    let errors: ErrorObject
    let success: Int
    let videos: [[VideoModel]]
}
