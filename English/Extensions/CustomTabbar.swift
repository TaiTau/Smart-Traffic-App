//
//  CustomTabbar.swift
//  English
//
//  Created by TaiTau on 18/04/2023.
//

import Foundation
//
//  CustomTabBarController.swift
//  For Medium Article @yalcinozd
//
//  Created by Yalcin Ozdemir on 19/08/2018.
//
import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    var homeViewController: MainViewController!
    var secondViewController: UserInfomationVC!
//    var actionViewController: ActionViewController!
//    var thirdViewController: ThirdViewController!
//    var fourthViewController: FourthViewController!

    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        
        homeViewController = MainViewController()
        secondViewController = UserInfomationVC()
//        actionViewController = ActionViewController()
//        thirdViewController = ThirdViewController()
//        fourthViewController = FourthViewController()
     
        homeViewController.tabBarItem.image = UIImage(named: "home")
        homeViewController.tabBarItem.selectedImage =
        UIImage(named: "home-selected")
        secondViewController.tabBarItem.image = UIImage(named: "second")
        secondViewController.tabBarItem.selectedImage = UIImage(named: "second-selected")
//        actionViewController.tabBarItem.image = UIImage(named: "action")
//        actionViewController.tabBarItem.selectedImage = UIImage(named: "action-selected")
//        thirdViewController.tabBarItem.image = UIImage(named: "third")
//        thirdViewController.tabBarItem.selectedImage = UIImage(named: "third-selected")
//        fourthViewController.tabBarItem.image = UIImage(named: "fourth")
//        fourthViewController.tabBarItem.selectedImage = UIImage(named: "fourth-selected")
        viewControllers = [homeViewController, secondViewController]
        for tabBarItem in tabBar.items! {
          tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      if viewController.isKind(of: MainViewController.self) {
         let vc =  MainViewController()
         vc.modalPresentationStyle = .overFullScreen
         self.present(vc, animated: true, completion: nil)
         return false
      }
      return true
    }
    
}
