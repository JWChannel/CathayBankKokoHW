//
//  FriendsVM.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/29.
//

import Foundation

protocol FriendsService {
    func fetchFriends(from url: URL) async throws -> [Friend]
}

final class RealFriendsService: FriendsService {
    func fetchFriends(from url: URL) async throws -> [Friend] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoData = try JSONDecoder().decode(FriendsData.self, from: data)
        return decoData.response
    }
}

final class MockFriendsService: FriendsService { // For testing
    func fetchFriends(from url: URL) async throws -> [Friend] {
        if url.absoluteString == "https://dimanyen.github.io/friend1.json" {
            return [
                Friend(name: "John", status: 2, isTop: "1", fid: "1001", updateDate: "20240929"),
                Friend(name: "Mary", status: 1, isTop: "0", fid: "1002", updateDate: "2024/09/28")
            ]
        } else if url.absoluteString == "https://dimanyen.github.io/friend2.json" {
            return [
                Friend(name: "Johnny", status: 2, isTop: "1", fid: "1001", updateDate: "2024/09/30"),
                Friend(name: "David", status: 2, isTop: "0", fid: "1003", updateDate: "2024/09/27")
            ]
        } else {
            return []
        }
    }
}

final class FriendsVM: ObservableObject {

    var scenario: Scenario = .noFriends
    var rawFriends: [Friend] = []
    @Published var uniqueFriends: [Friend] = []
    private let service: FriendsService
 
    init(service: FriendsService) {
        self.service = service
    }

    func fetchFriendsTaskGroup() async throws {
        try await withThrowingTaskGroup(of: [Friend].self) { group in
            for urlString in scenario.scenarioURL {
                let url = URL(string: urlString)!
                
                group.addTask {
                    return try await self.service.fetchFriends(from: url)
                }
            }
            
            for try await friends in group {
                self.rawFriends.append(contentsOf: processUpdateDate(for: friends))
            }
            
            uniqueFriends = filterUniqueFriends(rawFriends)
        }
    }
    
    func filterUniqueFriends(_ friends: [Friend]) -> [Friend] {
        var uniqueFriendsDict: [String: Friend] = [:]

        for friend in friends {
            if let existingFriend = uniqueFriendsDict[friend.fid] {
                if let newDate = convertToDate(friend.updateDate),
                   let oldDate = convertToDate(existingFriend.updateDate),
                   newDate > oldDate {
                    uniqueFriendsDict[friend.fid] = friend
                }
            } else {
                uniqueFriendsDict[friend.fid] = friend
            }
        }
        
        let uniqueFriends = Array(uniqueFriendsDict.values).sorted(by: { $0.fid < $1.fid })

        return uniqueFriends
    }
    
    private func processUpdateDate(for friends: [Friend]) -> [Friend] {
        return friends.map { friend in
            var updatedFriend = friend
            updatedFriend.updateDate = friend.updateDate.replacingOccurrences(of: "/", with: "")
            return updatedFriend
        }
    }
    
    private func convertToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: dateString)
    }
}
