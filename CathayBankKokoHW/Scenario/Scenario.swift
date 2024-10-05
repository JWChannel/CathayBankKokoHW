//
//  Scenario.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import Foundation

enum Scenario: CaseIterable {
    case noFriends
    case friendListMerge
    case friendListOnly
    case friendsWithInvitations
    
    var title: String {
        switch self {
        case .noFriends: return "2-(5) 無好友列表"
        case .friendListMerge: return "2-(2)＆2-(3) 複數好友列表合併"
        case .friendListOnly: return "2-(3) 只有好友列表"
        case .friendsWithInvitations: return "2-(4) 好友列表含邀請"
        }
    }
    
    var scenarioURL: [String] {
        switch self {
        case .noFriends: return ["https://dimanyen.github.io/friend4.json"]
        case .friendListMerge: return ["https://dimanyen.github.io/friend1.json", "https://dimanyen.github.io/friend2.json"]
        case .friendListOnly: return ["https://dimanyen.github.io/friend2.json"]
        case .friendsWithInvitations: return ["https://dimanyen.github.io/friend3.json"]
        }
    }
}
