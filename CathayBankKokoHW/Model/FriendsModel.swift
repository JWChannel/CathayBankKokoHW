//
//  FriendsModel.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/29.
//

import Foundation

struct FriendsData: Codable, Equatable {
    let response: [Friend]
}

struct Friend: Codable, Equatable {
    let name: String
    let status: Int // 0: 邀請送出, 1: 已完成, 2: 邀請中
    let isTop: String // "0": no, "1": yes
    let fid: String // friend id
    var updateDate: String // update date
}
