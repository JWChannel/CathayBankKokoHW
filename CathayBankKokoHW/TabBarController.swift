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
        selectedTab()
    }
}

fileprivate extension UITabBarController {
    
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

class FriendsVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

class FriendsNavController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendsVC()
        setupNavButtons()
    }
}

fileprivate extension FriendsNavController {
    func setupFriendsVC() {
        let FriendVC = FriendsVC()
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icNavPinkScan"), style: .plain, target: nil, action: nil)
        FriendVC.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton1 = UIBarButtonItem(image: UIImage(named: "icNavPinkWithdraw"), style: .plain, target: nil, action: nil)
        let leftBarButton2 = UIBarButtonItem(image: UIImage(named: "icNavPinkTransfer"), style: .plain, target: nil, action: nil)
        FriendVC.navigationItem.leftBarButtonItems = [leftBarButton1, leftBarButton2]
        
        UIBarButtonItem.appearance().tintColor = .systemPink
        
        setViewControllers([FriendVC], animated: false)
    }
    
    func setupNavButtons() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
    }
}
