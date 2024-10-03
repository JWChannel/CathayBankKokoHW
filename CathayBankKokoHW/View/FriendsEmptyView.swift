//
//  FriendsEmptyView.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

final class FriendsEmptyView: UIView {
    
    private let imageView = UIImageView()
    private let titleTextLabel = UILabel()
    private let descriptionTextLabel = UILabel()
 
    private let gradientLayer = CAGradientLayer()
    private let addFriendButton = UIButton()
    
    private let bottomtextLabel = UILabel()
    private let kokoSettingButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = addFriendButton.bounds
    }
}

private extension FriendsEmptyView {
    
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
        titleTextLabel.text = "就從加好友開始吧 : )"
        titleTextLabel.textColor = .darkGray
        titleTextLabel.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        titleTextLabel.textAlignment = .center
        addSubview(titleTextLabel)
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 41),
            titleTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        // 與好友們一起用 KOKO 聊起來！
        // 還能互相收付款、發紅包喔：）
        descriptionTextLabel.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔 : )"
        descriptionTextLabel.textColor = .lightGray
        descriptionTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionTextLabel.numberOfLines = 0
        descriptionTextLabel.textAlignment = .center
        addSubview(descriptionTextLabel)
        descriptionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextLabel.topAnchor.constraint(equalTo: titleTextLabel.bottomAnchor, constant: 10),
            descriptionTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupAddFriendButton() {
        
        addFriendButton.setTitle("加好友", for: .normal)
        addFriendButton.setTitleColor(.white, for: .normal)
        addFriendButton.layer.cornerRadius = 20
        addSubview(addFriendButton)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addFriendButton.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 30),
            addFriendButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 192),
            addFriendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // gradient
        gradientLayer.cornerRadius = 20
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.frogGreen.cgColor, UIColor.boogerGreen.cgColor]
        // inset CALayer
        addFriendButton.layer.insertSublayer(gradientLayer, at: 0)
        // shadow
        addFriendButton.layer.shadowColor = UIColor.boogerGreen.cgColor
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
        bottomtextLabel.text = "幫助好友更快找到你 ？ "
        bottomtextLabel.textColor = .lightGray
        bottomtextLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        bottomtextLabel.textAlignment = .center
        addSubview(bottomtextLabel)

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
        stackView.addArrangedSubview(bottomtextLabel)
        stackView.addArrangedSubview(kokoSettingButton)
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 37),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

#Preview {
    FriendCell()
}
