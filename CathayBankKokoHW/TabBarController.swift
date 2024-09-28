//
//  TabBarController.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/28.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarColor()
        setupTabBar()
    }
}

fileprivate extension UITabBarController {
    
    func setupTabBarColor() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemPink
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    func setupTabBar() {
        let productVC = UIViewController()
        productVC.view.backgroundColor = .white
        productVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarProductsOff"), tag: 0)
        let productNavController = UINavigationController(rootViewController: productVC)
        
        let friendsVC = UIViewController()
        friendsVC.view.backgroundColor = .white
        friendsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarFriendsOff"), tag: 1)
        let friendsNavController = UINavigationController(rootViewController: friendsVC)
        
        let homeVC = UIViewController()
        homeVC.view.backgroundColor = .white
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarHomeOff"), tag: 2)
        let homeNavController = UINavigationController(rootViewController: homeVC)
        
        let manageVC = UIViewController()
        manageVC.view.backgroundColor = .white
        manageVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarManageOff"), tag: 3)
        let manageNavController = UINavigationController(rootViewController: manageVC)
        
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarSettingOff"), tag: 4)
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        
        viewControllers = [productNavController, friendsNavController, homeNavController, manageNavController, settingsNavController]
    }
}

import SwiftUI

#Preview {
    TabBarController()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

