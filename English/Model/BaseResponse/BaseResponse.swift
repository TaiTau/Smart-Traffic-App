//
//  BaseResponse.swift
//  English
//
//  Created by TaiTau on 09/04/2023.
//

import Foundation

// ErrorObject model
class ErrorObject: Codable,Error {
    var code: Int
    var detail: String
    var title: String
    
    private enum CodingKeys: String, CodingKey {
        case code
        case detail
        case title
    }
}

// BaseResponse model
class BaseResponse: Codable {
    var errors: ErrorObject?
    var success: Int
    
    private enum CodingKeys: String, CodingKey {
        case errors
        case success
    }
}
