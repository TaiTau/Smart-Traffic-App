//
//  UIImageViewExtensions.swift
//  DamCaMau-C2-IOS
//
//  Created by Le Nguyen Duc Danh on 12/2/22.
//  Copyright © 2022 Cong Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(urlString : String){
        contentMode = .scaleAspectFit
        guard let url = URL(string: urlString) else{
            return
        }
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
