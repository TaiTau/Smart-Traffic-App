//
//  MainTabBarViewController.swift
//  English
//
//  Created by TaiTau on 18/04/2023.
//

import Foundation
import UIKit
class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: FunctionVC())
        let vc3 = UINavigationController(rootViewController: UserInfomationVC())
      
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "list.bullet")
        vc3.tabBarItem.image = UIImage(systemName: "person.circle")
       
        vc1.title = "Trang chủ"
        vc2.title = "Chức năng"
        vc3.title = "Thông tin"
        
        
      //  navigationItem.hidesBackButton = true
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3], animated: true)
    }


}
