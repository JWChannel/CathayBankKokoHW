//
//  UserView.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

class UserView: UIView {
    
    private let userNameLabel = UILabel()
    let userIdLabel = UILabel()
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
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension UserView {
    
    @objc func friendsButtonTapped() {
        moveUnderline(to: friendsButton)
    }
    
    @objc func chatButtonTapped() {
        moveUnderline(to: chatButton)
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

@MainActor
extension UserView {
    func updateUserInfo(with user: User) {
        userNameLabel.text = user.name
        userIdLabel.text = "KOKO ID: \(user.kokoid ?? .placeholder)"
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
        userNameLabel.text = .placeholder
        userNameLabel.textColor = .darkGray
        userNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            userNameLabel.heightAnchor.constraint(equalToConstant: 18),
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
            userIdLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            userIdLabel.heightAnchor.constraint(equalToConstant: 18),
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
        buttonStackView.alignment = .bottom
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
            buttonStackView.bottomAnchor.constraint(equalTo: separatorLineView.topAnchor, constant: -10),
            buttonStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            buttonStackView.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        underlineonstraint = underlineView.centerXAnchor.constraint(equalTo: friendsButton.centerXAnchor)
        underlineonstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 6),
            underlineView.widthAnchor.constraint(equalToConstant: 20),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}
