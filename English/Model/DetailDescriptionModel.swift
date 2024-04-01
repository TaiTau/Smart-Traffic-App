//
//  DetailDescriptionModel.swift
//  English
//
//  Created by TaiTau on 08/04/2023.
//

import Foundation
// MARK: - KindKnowledgeElement
struct DetailDescriptionModel: Codable {
    let id, name, slug: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case slug = "Slug"
    }
}

typealias DetailDescription = [DetailDescriptionModel]
