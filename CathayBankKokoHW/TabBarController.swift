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

import Combine

class FriendsVC: UIViewController {
    
    private let friendsVM = FriendsVM()
    private let userVM = UserVM()
    private let userView = UserView()
    private let friendsEmptyView = FriendsEmptyView()
    private let tableView = UITableView()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let alert = UIAlertController(title: "Choose a Scenario", message: nil, preferredStyle: .alert)
        Scenario.allCases.forEach { scenario in
            alert.addAction(UIAlertAction(title: scenario.title, style: .default, handler: { [weak self] _ in
                self?.friendsVM.scenario = scenario
                self?.fetchData()
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        friendsEmptyView.isHidden = false
        tableView.isHidden = true
    }
}

fileprivate extension FriendsVC {
    
    private func observeViewModel() {
        
        friendsVM.$uniqueFriends
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        friendsVM.$invitations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // TODO
            }
            .store(in: &cancellables)
    }
    
    private func updateUI() {
        setupUserView()
        if friendsVM.rawFriends.isEmpty {
            friendsEmptyView.isHidden = false
            setupFriendEmptyView()
        } else {
            tableView.isHidden = false
            setupTableView()
            tableView.reloadData()
        }
    }
}

fileprivate extension FriendsVC {
    
    func fetchData() {
        friendsVM.rawFriends.removeAll()
        friendsVM.uniqueFriends.removeAll()
        friendsVM.invitations.removeAll()
        
        Task {
            do {
                let user = try await userVM.fetchUsers()
                if let firstUser = user.first {
                    userView.updateUserInfo(with: firstUser)
                }
                print(user)
            } catch {
                print(error)
            }
        }
        
        Task {
            do {
                try await friendsVM.fetchFriendsTaskGroup()
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
    
    func setupFriendEmptyView() {
        view.addSubview(friendsEmptyView)
        friendsEmptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsEmptyView.topAnchor.constraint(equalTo: userView.bottomAnchor),
            friendsEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendsEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendsEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendsVC: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "\(FriendCell.self)")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: userView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendsVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsVM.uniqueFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendCell.self)", for: indexPath) as? FriendCell else { return UITableViewCell() }
        let friend = friendsVM.uniqueFriends[indexPath.row]
        cell.friendNameLabel.text = friend.name
        cell.updateStatus(with: friend.status)
        cell.updateTopStatus(isTop: friend.isTop)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class FriendCell: UITableViewCell {
    
    let friendImageView = UIImageView()
    let friendNameLabel = UILabel()
    let transferButton = UIButton()
    let moreButton = UIButton()
    let friendIsTop = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

fileprivate extension FriendCell {
    
    func setupUI() {
        setupFriendImageView()
        setupFriendButtons()
        setupFriendName()
        setupFriendTop()
    }
    
    func setupFriendImageView() {
        friendImageView.image = UIImage(named: "imgFriendsList")
        friendImageView.layer.cornerRadius = 20
        friendImageView.clipsToBounds = true
        friendImageView.contentMode = .scaleAspectFill
        addSubview(friendImageView)
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 50),
            friendImageView.widthAnchor.constraint(equalToConstant: 40),
            friendImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupFriendButtons() {
        
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString("•••")

        titleAttr.font = .systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemGray3
        config.baseBackgroundColor = .clear
        config.background.strokeColor = .systemGray3
        config.background.strokeWidth = 0
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.cornerStyle = .medium
        moreButton.configuration = config
        addSubview(moreButton)
        
        titleAttr = AttributedString("轉帳")
        titleAttr.font = .systemFont(ofSize: 14, weight: .regular)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemPink
        config.background.strokeColor = .systemPink
        config.background.strokeWidth = 1
        
        transferButton.configuration = config
        addSubview(transferButton)
        
        // Content Hugging Priority
        moreButton.setContentHuggingPriority(.required, for: .horizontal)
        transferButton.setContentHuggingPriority(.required, for: .horizontal)
        // Content Compression Resistance Priority
        transferButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        moreButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        transferButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moreButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            transferButton.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -10),
            transferButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupFriendName() {
        friendNameLabel.text = "•••"
        friendNameLabel.textColor = .darkGray
        friendNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addSubview(friendNameLabel)
        
        friendNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 20),
            friendNameLabel.trailingAnchor.constraint(equalTo: transferButton.leadingAnchor, constant: -10),
        ])
    }
    
    func setupFriendTop() {
        friendIsTop.image = UIImage(named: "icFriendsTop")
        addSubview(friendIsTop)
        friendIsTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendIsTop.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendIsTop.trailingAnchor.constraint(equalTo: friendImageView.leadingAnchor, constant: -6)
        ])
    }
}

extension FriendCell {
    
    func updateTopStatus(isTop: String) {
         friendIsTop.image = (isTop == "1") ? UIImage(named: "icFriendsStar") : nil
     }
    
    func updateStatus(with status: Int) {
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString(status == 2 ? "邀請中" : "•••")
        titleAttr.font = .systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemGray3
        config.baseBackgroundColor = .clear
        config.background.strokeColor = .systemGray3
        config.background.strokeWidth = (status == 2) ? 1 : 0
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.cornerStyle = .medium
        moreButton.configuration = config
    }
}

class UserView: UIView {
    
    private let userNameLabel = UILabel()
    private let userIdLabel = UILabel()
    private let userImageView = UIImageView()
    private let buttonArrow = UIButton()
    
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
        userIdLabel.text = "KOKO ID: \(user.kokoid ?? "•••")"
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
        setupUserIdWithArrow()
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
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            userImageView.widthAnchor.constraint(equalToConstant: 52),
            userImageView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func setupUserName() {
        userNameLabel.text = "•••"
        userNameLabel.textColor = .darkGray
        userNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
    }
    
    func setupUserIdWithArrow() {
        userIdLabel.text = "KOKO ID: •••"
        userIdLabel.textColor = .darkGray
        userIdLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        addSubview(userIdLabel)
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIdLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            userIdLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        buttonArrow.setImage(UIImage(named: "icInfoBackDeepGray"), for: .normal)
        addSubview(buttonArrow)
        buttonArrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonArrow.centerYAnchor.constraint(equalTo: userIdLabel.centerYAnchor),
            buttonArrow.leadingAnchor.constraint(equalTo: userIdLabel.trailingAnchor, constant: 0),
            buttonArrow.widthAnchor.constraint(equalToConstant: 16),
            buttonArrow.heightAnchor.constraint(equalToConstant: 16)
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
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
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
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
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
            textLabelBold.centerXAnchor.constraint(equalTo: centerXAnchor)
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
            textLabelRegular.centerXAnchor.constraint(equalTo: centerXAnchor)
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
            addFriendButton.centerXAnchor.constraint(equalTo: centerXAnchor),
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
        kokoSettingButton.setTitle(title, for: .normal)
        kokoSettingButton.setTitleColor(.systemPink, for: .normal)
        kokoSettingButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        // button title underline style
        kokoSettingButton.underlineText()
        addSubview(kokoSettingButton)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.addArrangedSubview(textLabelSmall)
        stackView.addArrangedSubview(kokoSettingButton)
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 37),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
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
