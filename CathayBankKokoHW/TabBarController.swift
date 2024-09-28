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

struct FriendsResponse: Codable {
    let response: [Friend]
}

struct Friend: Codable {
    let name: String
    let status: Int // 0: send invitation, 1: accepted, 2: pending
    let isTop: String // 0: no, 1: yes
    let fid: String // friend id
    let updateDate: String // update date
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
    let friendsEmptyView = FriendsEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserView()
        fetchUserInfo()
        
        view.addSubview(friendsEmptyView)
        friendsEmptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsEmptyView.topAnchor.constraint(equalTo: userView.separatorLineView.bottomAnchor),
            friendsEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendsEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendsEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    private let userNameLabel = UILabel()
    private let userIDLabel = UILabel()
    private let userImageView = UIImageView()
    
    private let friendsButton = UIButton()
    private let chatButton = UIButton()
    private let underlineView = UIView()
    let separatorLineView = UIView()
    private var underlineonstraint: NSLayoutConstraint?
    
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
        userIDLabel.text = "KOKO ID: \(user.kokoid ?? "......") "
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
        userIDLabel.text = "KOKO ID: ......"
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
        
        let buttonStackView = UIStackView()
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

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            separatorLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            separatorLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
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

class FriendsEmptyView: UIView {
    
    private let imageView = UIImageView()
    private let textLabelBold = UILabel()
    private let textLabelRegular = UILabel()
 
    private let gradientLayer = CAGradientLayer()
    private let addFriendButton = UIButton()
    
    private let textLabelSmall = UILabel()
    private let buttonArrow = UIButton()
    private let kokoSettingButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = addFriendButton.bounds
    }
}

fileprivate extension FriendsEmptyView {
    
    func setupUI() {
        setupImageView()
        setupAddFriendText()
        setupAddFriendButton()
        setCaptions()
    }
    
    func setupImageView() {
        
        imageView.image = UIImage(named: "imgFriendsEmpty")
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 245),
            imageView.heightAnchor.constraint(equalToConstant: 172)
        ])
    }
    
    func setupAddFriendText() {
        
        // 就從加好友開始吧：）
        textLabelBold.text = "就從加好友開始吧 : )"
        textLabelBold.textColor = .darkGray
        textLabelBold.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        textLabelBold.textAlignment = .center
        addSubview(textLabelBold)
        textLabelBold.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabelBold.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 41),
            textLabelBold.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        // 與好友們一起用 KOKO 聊起來！
        // 還能互相收付款、發紅包喔：）
        textLabelRegular.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔 : )"
        textLabelRegular.textColor = .lightGray
        textLabelRegular.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textLabelRegular.numberOfLines = 0
        textLabelRegular.textAlignment = .center
        addSubview(textLabelRegular)
        textLabelRegular.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabelRegular.topAnchor.constraint(equalTo: textLabelBold.bottomAnchor, constant: 10),
            textLabelRegular.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupAddFriendButton() {
        
        addFriendButton.setTitle("加好友", for: .normal)
        addFriendButton.setTitleColor(.white, for: .normal)
        addFriendButton.layer.cornerRadius = 20
        addSubview(addFriendButton)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addFriendButton.topAnchor.constraint(equalTo: textLabelRegular.bottomAnchor, constant: 30),
            addFriendButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 192),
            addFriendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        // gradient
        gradientLayer.cornerRadius = 20
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.G1.cgColor, UIColor.G2.cgColor]
        // inset CALayer
        addFriendButton.layer.insertSublayer(gradientLayer, at: 0)
        // shadow
        addFriendButton.layer.shadowColor = UIColor.G2.cgColor
        addFriendButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addFriendButton.layer.shadowRadius = 8
        addFriendButton.layer.shadowOpacity = 0.4
        
        // button icon
        let plusIcon = UIImageView(image: UIImage(named: "icAddFriendWhite"))
        addFriendButton.addSubview(plusIcon)
        plusIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusIcon.trailingAnchor.constraint(equalTo: addFriendButton.trailingAnchor, constant: -10),
            plusIcon.centerYAnchor.constraint(equalTo: addFriendButton.centerYAnchor),
            plusIcon.widthAnchor.constraint(equalToConstant: 24),
            plusIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setCaptions() {
        // 幫助好友更快找到你？設定 KOKO ID
        textLabelSmall.text = "幫助好友更快找到你 ？"
        textLabelSmall.textColor = .lightGray
        textLabelSmall.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textLabelSmall.textAlignment = .center
        addSubview(textLabelSmall)

        let title = "設定 KOKO ID"
        buttonArrow.setTitle(title, for: .normal)
        buttonArrow.setTitleColor(.systemPink, for: .normal)
        buttonArrow.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        // button title underline style
        buttonArrow.underlineText()
        addSubview(buttonArrow)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.addArrangedSubview(textLabelSmall)
        stackView.addArrangedSubview(buttonArrow)
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 37),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension UIColor {
    static let G1 = UIColor.froggreen
    static let G2 = UIColor.booger
    static let G3 = UIColor.applegreen
}

extension UIButton {
  func underlineText() {
    guard let title = title(for: .normal) else { return }

    let titleString = NSMutableAttributedString(string: title)
    titleString.addAttribute(
      .underlineStyle,
      value: NSUnderlineStyle.single.rawValue,
      range: NSRange(location: 0, length: title.count)
    )
    setAttributedTitle(titleString, for: .normal)
  }
}
