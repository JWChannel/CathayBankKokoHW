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

class FriendsNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFriendsVC()
    }
}

fileprivate extension FriendsNavController {
    func setupFriendsVC() {
        let FriendVC = FriendsVC()
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icNavPinkScan"), style: .plain, target: nil, action: nil)
        let leftBarButton1 = UIBarButtonItem(image: UIImage(named: "icNavPinkWithdraw"), style: .plain, target: nil, action: nil)
        let leftBarButton2 = UIBarButtonItem(image: UIImage(named: "icNavPinkTransfer"), style: .plain, target: nil, action: nil)
        
        FriendVC.navigationItem.rightBarButtonItem = rightBarButton
        FriendVC.navigationItem.leftBarButtonItems = [leftBarButton1, leftBarButton2]
        UIBarButtonItem.appearance().tintColor = .systemPink
        
        setViewControllers([FriendVC], animated: false)
    }
}

struct UserResponse: Codable {
    var response: [User]
}

struct User: Codable {
    var name: String
    var kokoid: String?
}

enum Scenario: CaseIterable {
    case noFriends
    case friendsOnly
    case friendsWithInvitations
    
    var title: String {
        switch self {
        case .noFriends: return "無好友畫⾯"
        case .friendsOnly: return "只有好友列表"
        case .friendsWithInvitations: return "好友列表含邀請"
        }
    }
    
    var scenarioURL: [String] {
        switch self {
        case .noFriends: return ["https://dimanyen.github.io/friend4.json"]
        case .friendsOnly: return ["https://dimanyen.github.io/friend1.json", "https://dimanyen.github.io/friend2.json"]
        case .friendsWithInvitations: return ["https://dimanyen.github.io/friend3.json"]
        }
    }
}

class UserViewModel {
    
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://dimanyen.github.io/man.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return userResponse.response
    }
}

class FriendsVC: UIViewController {
    
    private let userView = UserView()
    private let userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserView()
        fetchUserInfo()
    }
}

fileprivate extension FriendsVC {
    
    func fetchUserInfo() {
        Task {
            do {
                let user = try await userViewModel.fetchUsers()
                if let firstUser = user.first {
                    userView.updateUserInfo(with: firstUser)
                }
                print(user)
            } catch {
                print(error)
            }
        }
    }
    
    func setupUserView() {
        view.addSubview(userView)
        userView.backgroundColor = .white
        userView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userView.heightAnchor.constraint(equalToConstant: 135)
        ])
    }
}


class UserView: UIView {
    
    let userNameLabel = UILabel()
    let userIDLabel = UILabel()
    let userImageView = UIImageView()
    let buttonStackView = UIStackView()
    
    let friendsButton = UIButton()
    let chatButton = UIButton()
    let underlineView = UIView()
    let separatorLineView = UIView()
    var underlineonstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

@MainActor
fileprivate extension UserView {
    
    @objc func friendsButtonTapped() {
        moveUnderline(to: friendsButton)
    }

    @objc func chatButtonTapped() {
        moveUnderline(to: chatButton)
    }
    
    func updateUserInfo(with user: User) {
        userNameLabel.text = user.name
        userIDLabel.text = "KOKO ID: \(user.kokoid ?? "......") ❯"
    }
    
    func moveUnderline(to button: UIButton) {
        underlineonstraint?.isActive = false
        underlineonstraint = underlineView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        underlineonstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
	
fileprivate extension UserView {
    
    func setupUI() {
        setupUserImageView()
        setupUserName()
        setupUserID()
        setupButtonUI()
        setupButtonConstraints()
    }
    
    func setupUserImageView() {
        userImageView.image = UIImage(named: "imgFriendsFemaleDefault")
        addSubview(userImageView)
        userImageView.layer.cornerRadius = 25
        userImageView.backgroundColor = .clear
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            userImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            userImageView.widthAnchor.constraint(equalToConstant: 52),
            userImageView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func setupUserName() {
        userNameLabel.text = "......"
        userNameLabel.textColor = .darkGray
        userNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
        ])
    }
    
    func setupUserID() {
        userIDLabel.text = "KOKO ID: ...... ❯"
        userIDLabel.textColor = .darkGray
        userIDLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        addSubview(userIDLabel)
        userIDLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIDLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 55),
            userIDLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
        ])
    }
    
    func setupButtonUI() {
        
        friendsButton.setTitle("好友", for: .normal)
        friendsButton.setTitleColor(.darkGray, for: .normal)
        friendsButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        friendsButton.addTarget(self, action: #selector(friendsButtonTapped), for: .touchUpInside)
        
        chatButton.setTitle("聊天", for: .normal)
        chatButton.setTitleColor(.darkGray, for: .normal)
        chatButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 36
        buttonStackView.alignment = .leading
        buttonStackView.addArrangedSubview(friendsButton)
        buttonStackView.addArrangedSubview(chatButton)
        addSubview(buttonStackView)

        underlineView.backgroundColor = .systemPink
        underlineView.layer.cornerRadius = 3
        underlineView.clipsToBounds = true
        addSubview(underlineView)

        separatorLineView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        addSubview(separatorLineView)
    }
    
    func setupButtonConstraints() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            buttonStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        underlineonstraint = underlineView.centerXAnchor.constraint(equalTo: friendsButton.centerXAnchor)
        underlineonstraint?.isActive = true
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 5),
            underlineView.widthAnchor.constraint(equalToConstant: 20),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}
