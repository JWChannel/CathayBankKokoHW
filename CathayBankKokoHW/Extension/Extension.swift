//
//  Extension.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit

extension UIColor {
    static let frogGreen = UIColor.froggreen
    static let boogerGreen = UIColor.booger
    static let appleGreen = UIColor.applegreen
    static let softPink = UIColor.softpink
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
    static let userViewHeightPreset = 135.0 + 20.0
    static let invitationCardHeightPreset = 70.0
    static let invitationSectionSpacePreset = 10.0
}

extension Notification.Name {
    static let searchBarDidBeginEditing = Notification.Name("searchBarDidBeginEditing")
    static let searchBarDidEndEditing = Notification.Name("searchBarDidEndEditing")
}
