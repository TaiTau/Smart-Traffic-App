//
//  QuizModel.swift
//  English
//
//  Created by TaiTau on 09/04/2023.
//

//   let kindKnowledge = try? JSONDecoder().decode(KindKnowledge.self, from: jsonData)

import Foundation

// MARK: - UserModel
struct UserModel: Codable {
    let ADDRESS: String
    let EMAIL: String
    let NAME: String
    let PASSWORD: String
    let PHONE: String
    let URL_AVATAR: String?
    let USER_ID: Int
}
