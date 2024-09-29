//
//  UserModel.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/29.
//

import Foundation

struct UserData: Codable {
    var response: [User]
}

struct User: Codable {
    var name: String
    var kokoid: String?
}
