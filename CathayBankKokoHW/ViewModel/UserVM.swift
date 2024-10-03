//
//  UserVM.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/29.
//

import Foundation

final class UserVM {
    
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://dimanyen.github.io/man.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoData = try JSONDecoder().decode(UserData.self, from: data)
        return decoData.response
    }
}
