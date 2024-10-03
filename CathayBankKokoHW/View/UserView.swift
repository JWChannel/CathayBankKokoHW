//
//  UserView.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

final class UserView: UIView {
    
    private let userNameLabel = UILabel()
    private let userIdLabel = UILabel()
    private let userImageView = UIImageView()
    private let buttonArrow = UIButton()
    
    private let buttonStackView = UIStackView()
    private let friendsButton = UIButton()
    private let chatButton = UIButton()
    private var friendsNotificationLabel: PaddingLabel?
    private var chatNotificationLabel: PaddingLabel?
    private let underlineView = UIView()
    private let separatorLineView = UIView()
    private var underlineConstraint: NSLayoutConstraint?
    
    var inviteLimit: Int = 2
    private var userViewHeight: NSLayoutConstraint?
    private var inviteSectionHeight: CGFloat = 0.0
    private var originalInviteSectionHeight: CGFloat = 0.0
    private var isStacked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension UserView {
    
    @objc func moveUnderline(_ sender: UIButton) {
        underlineConstraint?.isActive = false
        underlineConstraint = underlineView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        underlineConstraint?.isActive = true

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

@MainActor
extension UserView {
    
    func updateUserInfo(with user: User) {
        userNameLabel.text = user.name
        userIdLabel.text = "KOKO ID：\(user.kokoid ?? "")"
    }
}

private extension UserView {
    
    func setupUI() {
        setupImage()
        setupName()
        setupIdWithArrow()
        setupButtonsAndUnderline()
        setupConstraints()
        setupNotifications()
    }
    
    func setupImage() {
        userImageView.image = UIImage(named: "imgFriendsFemaleDefault")
        self.addSubview(userImageView)
        userImageView.layer.cornerRadius = 25
        userImageView.backgroundColor = .clear
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupName() {
        userNameLabel.text = .placeholder
        userNameLabel.textColor = .darkGray
        userNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupIdWithArrow() {
        userIdLabel.text = "KOKO ID"
        userIdLabel.textColor = .darkGray
        userIdLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        addSubview(userIdLabel)
        
        buttonArrow.setImage(UIImage(named: "icInfoBackDeepGray"), for: .normal)
        addSubview(buttonArrow)
    }
    
    func setupButtonsAndUnderline() {
        friendsButton.setTitle("好友", for: .normal)
        friendsButton.setTitleColor(.darkGray, for: .normal)
        friendsButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        friendsButton.addTarget(self, action: #selector(moveUnderline(_:)), for: .touchUpInside)
        
        chatButton.setTitle("聊天", for: .normal)
        chatButton.setTitleColor(.darkGray, for: .normal)
        chatButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        chatButton.addTarget(self, action: #selector(moveUnderline(_:)), for: .touchUpInside)
        
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
        
        friendsNotificationLabel = createNotificationLabel()
        if let friendsNotificationLabel = friendsNotificationLabel {
            addSubview(friendsNotificationLabel)
            friendsNotificationLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                friendsNotificationLabel.topAnchor.constraint(equalTo: friendsButton.topAnchor, constant: -6),
                friendsNotificationLabel.leadingAnchor.constraint(equalTo: friendsButton.trailingAnchor, constant: 0),
                friendsNotificationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
                friendsNotificationLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        chatNotificationLabel = createNotificationLabel()
        chatNotificationLabel?.text = "99+"
        if let chatNotificationLabel = chatNotificationLabel {
            addSubview(chatNotificationLabel)
            chatNotificationLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chatNotificationLabel.topAnchor.constraint(equalTo: chatButton.topAnchor, constant: -6),
                chatNotificationLabel.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: 0),
                chatNotificationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
                chatNotificationLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            userImageView.widthAnchor.constraint(equalToConstant: 52),
            userImageView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            userNameLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIdLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            userIdLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            userIdLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        
       
        buttonArrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonArrow.centerYAnchor.constraint(equalTo: userIdLabel.centerYAnchor),
            buttonArrow.leadingAnchor.constraint(equalTo: userIdLabel.trailingAnchor, constant: 0),
            buttonArrow.widthAnchor.constraint(equalToConstant: 16),
            buttonArrow.heightAnchor.constraint(equalToConstant: 16)
        ])
        
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
        
        underlineConstraint = underlineView.centerXAnchor.constraint(equalTo: friendsButton.centerXAnchor)
        underlineConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 6),
            underlineView.widthAnchor.constraint(equalToConstant: 20),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
}

extension UserView {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSearchBarDidBeginEditing), name: .searchBarDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSearchBarDidEndEditing), name: .searchBarDidEndEditing, object: nil)
    }
    
    @objc private func handleSearchBarDidBeginEditing() {
        UIView.animate(withDuration: 0.3) {
            self.updateUserViewHeightAnchor(0)
        }
    }
    
    @objc private func handleSearchBarDidEndEditing() {
        UIView.animate(withDuration: 0.3) {
            self.updateUserViewHeightAnchor(.userViewHeightPreset + self.inviteSectionHeight)
        }
    }
}


extension UserView {
    
    func setupInvitationView(with invitations: [Friend]?) {
        guard let invitations = invitations else { return }
        let inviteCount = invitations.count
        updateNotificationLabel(friendsNotificationLabel, count: inviteCount)
        updateNotificationLabel(chatNotificationLabel, count: 99)
        
        var prevInvitationCard: InvitationCard? = nil
        let limit = invitations.count > inviteLimit ? inviteLimit : invitations.count
        
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
                    newInvitationCard.heightAnchor.constraint(equalToConstant: .invitationCardHeightPreset)
                ])
                bringSubviewToFront(newInvitationCard)
            default:
                if let previousCard = prevInvitationCard {
                    NSLayoutConstraint.activate([
                        newInvitationCard.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: 10),
                        newInvitationCard.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
                        newInvitationCard.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
                        newInvitationCard.heightAnchor.constraint(equalToConstant: .invitationCardHeightPreset)
                    ])
                    
                    insertSubview(newInvitationCard, belowSubview: prevInvitationCard!) // will affect the order of subviews
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleInvitationTapped(_:)))
            newInvitationCard.tapAreaButton.addGestureRecognizer(tap)
            
            prevInvitationCard = newInvitationCard
        }
        
        originalInviteSectionHeight = CGFloat(limit) * .invitationCardHeightPreset + CGFloat(limit - 1) * .invitationSectionSpacePreset
        
        inviteSectionHeight = originalInviteSectionHeight
        
        updateUserViewHeightAnchor((inviteCount <= 0 ? -20 : 0) + .userViewHeightPreset + inviteSectionHeight) // userView.heightAnchor
    }
}

private extension UserView {
    
    func updateNotificationLabel(_ notificationLabel: PaddingLabel?, count: Int) {
        guard let notificationLabel = notificationLabel else { return }
        
        switch count {
        case ...0:
            notificationLabel.isHidden = true
            notificationLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        case 1..<99:
            notificationLabel.isHidden = false
            notificationLabel.text = "\(count)"
            notificationLabel.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            
        default: // count > 99
            notificationLabel.isHidden = false
            notificationLabel.text = "99+"
            notificationLabel.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }

    func createNotificationLabel() -> PaddingLabel {
        let label = PaddingLabel()
        label.textColor = .white
        label.backgroundColor = .softpink
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        return label
    }
    
    class PaddingLabel: UILabel { // Since UILabel doesn't support contentInset -> created a custom UILabel subclass
        var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        override func drawText(in rect: CGRect) {
            let insetRect = rect.inset(by: padding)
            super.drawText(in: insetRect)
        }

        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            let width = size.width + padding.left + padding.right
            let height = size.height + padding.top + padding.bottom
            return CGSize(width: width, height: height)
        }
    }
}

@MainActor
extension UserView {
    
    func updateUserViewHeightAnchor(_ height: CGFloat) { // userView.heightAnchor
        for constraint in constraints {
            if constraint.firstAttribute == .height && constraint.firstItem === self {
                removeConstraint(constraint)
            }
        }
        userViewHeight = self.heightAnchor.constraint(equalToConstant: height)
        userViewHeight?.isActive = true
        
        let isHidden = (height <= 0) // true or false
        
        switch (isHidden, self.isStacked) {
        case (true, true): // If hidden and stacked
            self.inviteSectionHeight = .invitationCardHeightPreset // Reset to the height of a single card, ensuring the inviteSection is stacked as well.
        default:
            self.inviteSectionHeight = self.originalInviteSectionHeight
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = isHidden ? 0 : 1 // Fade out if hidden, fade in if visible
        }, completion: { _ in
            self.isHidden = isHidden
        })
        
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
            UIView.animate(withDuration: 0.3) { // userView.heightAnchor
                self.updateUserViewHeightAnchor(.userViewHeightPreset + self.inviteSectionHeight)
            }
            
        case false:
            for (index, card) in invitationCards.enumerated() {
                guard index != 0 else { continue }
                UIView.animate(withDuration: 0.3) {
                    card.transform = CGAffineTransform(translationX: 0, y: -(.invitationCardHeightPreset + .invitationSectionSpacePreset) * CGFloat(index) + 10).scaledBy(x: 0.93, y: 0.93)
                }
            }
            UIView.animate(withDuration: 0.3) { // userView.heightAnchor
                self.updateUserViewHeightAnchor(.userViewHeightPreset + .invitationCardHeightPreset)
            }
        }
        isStacked.toggle()
    }
}

#Preview {
    UserView()
}
