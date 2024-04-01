//
//  KindKnowledgeModel.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import Foundation
// MARK: - KindKnowledgeElement
struct CameraModel: Codable {
    let id, name, time, address,creator: String
    let lat,lng:Double
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case time = "Slug"
        case address = "Address"
        case creator = "Creator"
        case lat = "lat"
        case lng = "lng"
    }
}

typealias Camera = [CameraModel]

// MARK: - KindKnowledgeElement
struct CameraModelAPI: Codable {
        let CAMERA_ID :Int
        let USER_ID :Int
        let NAME :String
        let ADDRESS :String
        let CREATOR :String
        let LAT :Double
        let LNG :Double
        let NOTE :String
}
