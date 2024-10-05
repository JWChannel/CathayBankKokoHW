//
//  CathayBankKokoHWTests.swift
//  CathayBankKokoHWTests
//
//  Created by J W on 2024/10/3.
//

import XCTest
@testable import CathayBankKokoHW

final class CathayBankKokoHWTests: XCTestCase {
    func testFetchFriendsTaskGroup() async throws {
        let mockService = MockFriendsService()
        
        let viewModel = FriendsVM(service: mockService)
        viewModel.scenario = .friendsMerge
        
        try await viewModel.fetchFriendsTaskGroup()
        
        XCTAssertEqual(viewModel.rawFriends.count, 4)
        XCTAssertEqual(viewModel.uniqueFriends.count, 3)
        XCTAssertEqual(viewModel.uniqueFriends.first?.fid, "1001") // same fid
        XCTAssertEqual(viewModel.uniqueFriends.first?.name, "Johnny") // new name
        XCTAssertEqual(viewModel.uniqueFriends.first?.updateDate, "20240930") // newer date
    }
}
