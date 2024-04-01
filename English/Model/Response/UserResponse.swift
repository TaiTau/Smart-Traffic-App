//
//  UserResponse.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import Foundation
struct UserResponse: Codable {
    let errors: ErrorObject
    let success: Int
    let user: [UserModel] // This should match the structure of UserModel
}
