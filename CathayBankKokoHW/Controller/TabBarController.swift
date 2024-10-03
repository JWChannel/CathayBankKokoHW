//
//  TabBarController.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/28.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarColor()
        setupTabBar()
        selectedTab()
    }
}

private extension UITabBarController {
    
    func selectedTab() {
        selectedIndex = 1
    }
    
    func setupTabBarColor() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemPink
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    func setupTabBar() {
        let productVC = UIViewController()
        productVC.view.backgroundColor = .white
        productVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarProductsOff"), tag: 0)
        
        let FriendsNavController = FriendsNavController()
        FriendsNavController.view.backgroundColor = .white
        FriendsNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarFriendsOff"), tag: 1)
        
        let homeVC = UIViewController()
        homeVC.view.backgroundColor = .white
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarHomeOff"), tag: 2)
        
        let manageVC = UIViewController()
        manageVC.view.backgroundColor = .white
        manageVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarManageOff"), tag: 3)
        
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarSettingOff"), tag: 4)
        
        viewControllers = [productVC, FriendsNavController, homeVC, manageVC, settingsVC]
    }
}

import SwiftUI

#Preview {
    TabBarController()
}
