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
        addTopLineToTabBar()
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
        let insets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        
        let productVC = UIViewController()
        productVC.view.backgroundColor = .white
        productVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarProductsOff"), tag: 0)
        productVC.tabBarItem.imageInsets = insets
        
        let FriendsNavController = FriendsNavController()
        FriendsNavController.view.backgroundColor = .white
        FriendsNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarFriendsOff"), tag: 1)
        FriendsNavController.tabBarItem.imageInsets = insets
        
        let homeVC = UIViewController()
        homeVC.view.backgroundColor = .white
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarHomeOff"), tag: 2)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
        
        let manageVC = UIViewController()
        manageVC.view.backgroundColor = .white
        manageVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarManageOff"), tag: 3)
        manageVC.tabBarItem.imageInsets = insets
        
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .white
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarSettingOff"), tag: 4)
        settingsVC.tabBarItem.imageInsets = insets
        
        viewControllers = [productVC, FriendsNavController, homeVC, manageVC, settingsVC]
    }
    
    func addTopLineToTabBar() {
        let topLine = UIView()
        topLine.backgroundColor = .systemGray5
        topLine.translatesAutoresizingMaskIntoConstraints = false
        tabBar.insertSubview(topLine, at: 0)
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}

#Preview {
    TabBarController()
}
