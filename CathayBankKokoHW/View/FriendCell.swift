//
//  FriendCell.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

class FriendCell: UITableViewCell {
    
    let friendImageView = UIImageView()
    let friendNameLabel = UILabel()
    let transferButton = UIButton()
    let moreButton = UIButton()
    let friendIsTop = UIImageView()
    let separatorLineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension FriendCell {
    
    func setupUI() {
        setupFriendImageView()
        setupFriendButtons()
        setupFriendName()
        setupFriendTop()
        setupSeparatorLine()
    }
    
    func setupFriendImageView() {
        friendImageView.image = UIImage(named: "imgFriendsList")
        friendImageView.layer.cornerRadius = 20
        friendImageView.clipsToBounds = true
        friendImageView.contentMode = .scaleAspectFill
        contentView.addSubview(friendImageView)
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
        var titleAttr = AttributedString(.placeholder)

        titleAttr.font = .systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemGray3
        config.baseBackgroundColor = .clear
        config.background.strokeColor = .systemGray3
        config.background.strokeWidth = 0
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.cornerStyle = .medium
        moreButton.configuration = config
        contentView.addSubview(moreButton)
        
        titleAttr = AttributedString("轉帳")
        titleAttr.font = .systemFont(ofSize: 14, weight: .regular)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemPink
        config.background.strokeColor = .systemPink
        config.background.strokeWidth = 1
        
        transferButton.configuration = config
        contentView.addSubview(transferButton)
        
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
        friendNameLabel.text = .placeholder
        friendNameLabel.textColor = .darkGray
        friendNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(friendNameLabel)
        
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
        contentView.addSubview(friendIsTop)
        friendIsTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendIsTop.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendIsTop.trailingAnchor.constraint(equalTo: friendImageView.leadingAnchor, constant: -6)
        ])
    }
    
    func setupSeparatorLine() {
        separatorLineView.backgroundColor = .systemGray5
        contentView.addSubview(separatorLineView)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            separatorLineView.leadingAnchor.constraint(equalTo: friendNameLabel.leadingAnchor, constant: 0),
            separatorLineView.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

extension FriendCell {
    
    func updateTopStatus(isTop: String) {
         friendIsTop.image = (isTop == "1") ? UIImage(named: "icFriendsStar") : nil
     }
    
    func updateStatus(with status: Int) {
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString(status == 2 ? "邀請中" : .placeholder)
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
