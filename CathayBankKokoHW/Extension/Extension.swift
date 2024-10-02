//
//  Extension.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

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

extension String {
    static let placeholder = "•••"
}

extension CGFloat {
    static let userViewHeightPreset = 135.0 + 40.0
    static let invitationViewHeightPreset = 70.0
    static let invitationViewSpacePreset = 10.0
}
