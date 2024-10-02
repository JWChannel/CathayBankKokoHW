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
    var invitationViewHeight: CGFloat = 0.0
    var isStacked = false
    
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

extension UserView {
    
    func setupInvitationView(with invitations: [Friend]?) {
        guard let invitations = invitations else { return }
        var prevInvitationCard: InvitationCard? = nil
        let limit = invitations.count > 2 ? 2 : invitations.count
        
        for (index, friend) in invitations.enumerated() {
            guard index < limit else { break }
            let newInvitationCard = InvitationCard()
            newInvitationCard.nameLabel.text = friend.name
            newInvitationCard.layer.cornerRadius = 10
            
            newInvitationCard.layer.shadowColor = UIColor.systemGray2.cgColor
            newInvitationCard.layer.shadowOffset = CGSize(width: 0, height: 4)
            newInvitationCard.layer.shadowRadius = 6
            newInvitationCard.layer.shadowOpacity = 0.4
            
            addSubview(newInvitationCard)
            newInvitationCard.translatesAutoresizingMaskIntoConstraints = false
            
            switch index {
            case 0:
                NSLayoutConstraint.activate([
                    newInvitationCard.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 35),
                    newInvitationCard.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
                    newInvitationCard.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
                    newInvitationCard.heightAnchor.constraint(equalToConstant: .invitationViewHeightPreset)
                ])
                bringSubviewToFront(newInvitationCard)
            default:
                if let previousCard = prevInvitationCard {
                    NSLayoutConstraint.activate([
                        newInvitationCard.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: 10),
                        newInvitationCard.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
                        newInvitationCard.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
                        newInvitationCard.heightAnchor.constraint(equalToConstant: .invitationViewHeightPreset)
                    ])
                    
                    insertSubview(newInvitationCard, belowSubview: prevInvitationCard!) // will affect the order of subviews
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleInvitationTapped(_:)))
            newInvitationCard.tapAreaButton.addGestureRecognizer(tap)
            
            prevInvitationCard = newInvitationCard
        }
        
        invitationViewHeight = CGFloat(limit) * .invitationViewHeightPreset + CGFloat(limit - 1) * .invitationViewSpacePreset
        
        updateUserViewHeight(plus: invitationViewHeight)
    }
}

extension UserView {
    
    func updateUserViewHeight(plus invitationViewHeight: CGFloat) {
        
        constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                removeConstraint(constraint)
            }
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: .userViewHeightPreset + invitationViewHeight)
        ])
        self.superview?.layoutIfNeeded()
    }
    
    func resetInvitationView() {
        self.subviews.filter { $0 is InvitationCard }.forEach { card in
            card.removeFromSuperview()
        }
        self.superview?.layoutIfNeeded()
    }
}

extension UserView {
    
    @objc func handleInvitationTapped(_ sender: UITapGestureRecognizer) {
        let invitationCards = subviews.filter { $0 is InvitationCard }.reversed() // reversed() b/c affected by belowSubview
        
        switch isStacked {
        case true:
            for (index, card) in invitationCards.enumerated() {
                guard index != 0 else { continue }
                UIView.animate(withDuration: 0.3) {
                    card.transform = .identity
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.updateUserViewHeight(plus: self.invitationViewHeight)
            }
            
        case false:
            for (index, card) in invitationCards.enumerated() {
                guard index != 0 else { continue }
                UIView.animate(withDuration: 0.3) {
                    card.transform = CGAffineTransform(translationX: 0, y: -(.invitationViewHeightPreset + .invitationViewSpacePreset) * CGFloat(index) + 10).scaledBy(x: 0.93, y: 0.93)
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.updateUserViewHeight(plus: .invitationViewHeightPreset)
            }
        }
        isStacked.toggle()
    }
}
