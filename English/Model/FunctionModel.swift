//
//  FunctionModel.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import Foundation
import UIKit
class FunctionModel: NSObject, NSCoding {
    
    let lbname: String
    let iconButton: String
    
    init(lbname: String, iconButton: String!) {
        self.lbname = lbname
        self.iconButton = iconButton
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let lbname = aDecoder.decodeObject(forKey: "lbname") as! String
        let iconButton = aDecoder.decodeObject(forKey: "iconButton") as! String
        self.init(lbname: lbname, iconButton: iconButton)
    }
   
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lbname, forKey: "lbname")
        aCoder.encode(iconButton, forKey: "iconButton")
    }
}
