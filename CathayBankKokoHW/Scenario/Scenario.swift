//
//  Scenario.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import Foundation

enum Scenario: CaseIterable {
    case noFriends
    case friendsMerge
    case friendsOnly
    case friendsWithInvitations
    
    var title: String {
        switch self {
        case .noFriends: return "2-(5) 無好友列表"
        case .friendsMerge: return "2-(2)＆2-(3) 複數好友列表合併"
        case .friendsOnly: return "2-(3) 只有好友列表"
        case .friendsWithInvitations: return "2-(4) 好友列表含邀請"
        }
    }
    
    var scenarioURL: [String] {
        switch self {
        case .noFriends: return ["https://dimanyen.github.io/friend4.json"]
        case .friendsMerge: return ["https://dimanyen.github.io/friend1.json", "https://dimanyen.github.io/friend2.json"]
        case .friendsOnly: return ["https://dimanyen.github.io/friend2.json"]
        case .friendsWithInvitations: return ["https://dimanyen.github.io/friend3.json"]
        }
    }
}
