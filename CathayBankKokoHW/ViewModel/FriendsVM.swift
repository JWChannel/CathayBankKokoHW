//
//  FriendsVM.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/9/29.
//

import Foundation

class FriendsVM: ObservableObject {

    var rawFriends: [Friend] = []
    @Published var uniqueFriends: [Friend] = []
    @Published var invitations: [Friend] = []
    var scenario: Scenario = .friendsWithInvitations

    func fetchFriendsTaskGroup() async throws {

         try await withThrowingTaskGroup(of: [Friend].self) { group in
             for urlString in scenario.scenarioURL {
                 let url = URL(string: urlString)!
          
                 group.addTask {
                     return try await self.fetchFriends(from: url)
                 }
             }

             for try await friends in group {
                 self.rawFriends.append(contentsOf: processUpdateDate(for: friends))
             }
             
             print("===raw=== \(rawFriends)")
             
             uniqueFriends = filterUniqueFriends(rawFriends)
             print("===unique=== \(uniqueFriends)")
             
             filterInvitations(uniqueFriends)
             print("=== invitations === \(invitations)")
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
    
    private func filterInvitations(_ uniqueFriends: [Friend]) {
        for friend in uniqueFriends {
             if friend.status == 2 {
                 self.invitations.append(friend)
             }
         }
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

    func fetchFriends(from url: URL) async throws -> [Friend] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoData = try JSONDecoder().decode(FriendsData.self, from: data)
        return decoData.response
    }
}
