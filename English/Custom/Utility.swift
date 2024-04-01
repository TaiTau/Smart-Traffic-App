//
//  Utility.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import Foundation

struct Utility {
    
    static func registerKey(_ identifier: String, withValue value: String) {
        UserDefaults.standard.setValue(value, forKey: identifier)
    }
    
    static func getKeyValue(identifier: String) -> String? {
        return UserDefaults.standard.string(forKey: identifier)
        // You can use other methods based on the type of value being retrieved.
        // For example: integer(forKey:), bool(forKey:), etc.
    }
    

}
