//
//  ListUserResponse.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import Foundation

class ListUserResponse: Codable {
    let errors: ErrorObject
    let success: Int
    let users: [[UserModel]]
}
