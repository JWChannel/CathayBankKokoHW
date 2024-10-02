//
//  InvitationCard.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

class InvitationCard: UIView {
    
    let imageView = UIImageView()
    let stackView = UIStackView()
    let nameLabel = UILabel()
    let captionLabel = UILabel()
    let imageButtonAgree = UIButton()
    let imageButtonReject = UIButton()
    let tapAreaButton = UIButton() // clear button layer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension InvitationCard {
    
    func setupUI() {
        imageView.image = UIImage(named: "imgFriendsList")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = .placeholder
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        captionLabel.text = "邀請你成為好友 : )"
        captionLabel.font = UIFont.systemFont(ofSize: 13)
        captionLabel.textColor = .systemGray2
        captionLabel.textAlignment = .left
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemPink
        config.baseBackgroundColor = .red
        config.image = UIImage(systemName: "checkmark.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22))
        imageButtonAgree.configuration = config
        imageButtonAgree.translatesAutoresizingMaskIntoConstraints = false
        
        config.baseForegroundColor = .systemGray3
        config.baseBackgroundColor = .red
        config.image = UIImage(systemName: "xmark.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22))
        imageButtonReject.configuration = config
        imageButtonReject.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(captionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // tapAreaButton
        tapAreaButton.backgroundColor = .clear
        tapAreaButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Content Hugging Priority
        imageButtonAgree.setContentHuggingPriority(.required, for: .horizontal)
        imageButtonReject.setContentHuggingPriority(.required, for: .horizontal)
        // Content Compression Resistance Priority
        imageButtonAgree.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageButtonReject.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        addSubview(imageView)
        addSubview(stackView)
        addSubview(imageButtonAgree)
        addSubview(imageButtonReject)
        addSubview(tapAreaButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: imageButtonAgree.leadingAnchor, constant: -15),
            
            imageButtonAgree.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageButtonAgree.trailingAnchor.constraint(equalTo: imageButtonReject.leadingAnchor, constant: -15),
            imageButtonAgree.widthAnchor.constraint(equalToConstant: 30),
            imageButtonAgree.heightAnchor.constraint(equalToConstant: 30),
            
            imageButtonReject.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageButtonReject.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            imageButtonReject.widthAnchor.constraint(equalToConstant: 30),
            imageButtonReject.heightAnchor.constraint(equalToConstant: 30),
            
            tapAreaButton.topAnchor.constraint(equalTo: topAnchor),
            tapAreaButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            tapAreaButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapAreaButton.trailingAnchor.constraint(equalTo: imageButtonAgree.leadingAnchor, constant: -15)
        ])
    }
}

