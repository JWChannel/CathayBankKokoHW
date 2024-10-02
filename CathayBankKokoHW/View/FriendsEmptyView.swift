//
//  FriendsEmptyView.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

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
