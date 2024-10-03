//
//  FriendsVC.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit
import Combine

final class FriendsVC: UIViewController {

    private let friendsVM = FriendsVM()
    private let userVM = UserVM()
    private let userView = UserView()
    private let friendsEmptyView = FriendsEmptyView()
    private let friendsTableView = FriendsTableView()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectAScenario()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        friendsEmptyView.isHidden = false
        friendsTableView.isHidden = true
        userView.resetInvitationView()
    }
}

private extension FriendsVC {

    func observeViewModel() {
        friendsVM.$uniqueFriends
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupUI()
                self?.userView.setupInvitationView(with: self?.friendsVM.invitations)
                self?.friendsTableView.friends = self?.friendsVM.uniqueFriends ?? []
            }
            .store(in: &cancellables)
    }

    func selectAScenario() {
        let alert = UIAlertController(title: "Choose a Scenario", message: nil, preferredStyle: .alert)
        Scenario.allCases.forEach { scenario in
            alert.addAction(UIAlertAction(title: scenario.title, style: .default, handler: { [weak self] _ in
                self?.friendsVM.scenario = scenario
                self?.fetchData()
            }))
        }
        present(alert, animated: true, completion: nil)
    }

    func fetchData() {
        friendsVM.rawFriends.removeAll()
        friendsVM.uniqueFriends.removeAll()
        friendsVM.invitations.removeAll()

        Task {
            do {
                let user = try await userVM.fetchUsers()
                if let firstUser = user.first {
                    userView.updateUserInfo(with: firstUser)
                }
            } catch {
                print(error)
            }
        }

        Task {
            do {
                try await friendsVM.fetchFriendsTaskGroup()
            } catch {
                print(error)
            }
        }
    }

    func setupUI() {
        setupUserView()
        if friendsVM.rawFriends.isEmpty {
            friendsEmptyView.isHidden = false
            setupFriendEmptyView()
            friendsTableView.isHidden = true
        } else {
            friendsEmptyView.isHidden = true
            friendsTableView.isHidden = false
            setupFriendsTableView()
        }
    }

    func setupFriendEmptyView() {
        view.addSubview(friendsEmptyView)
        friendsEmptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendsEmptyView.topAnchor.constraint(equalTo: userView.bottomAnchor),
            friendsEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendsEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendsEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupUserView() {
        view.addSubview(userView)
        userView.backgroundColor = .white
        userView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            // Leave the userView.heightAnchor unset for later adjustment.
        ])
    }

    func setupFriendsTableView() {
        if friendsTableView.superview == nil {
            view.addSubview(friendsTableView)
            friendsTableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                friendsTableView.topAnchor.constraint(equalTo: userView.bottomAnchor),
                friendsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                friendsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                friendsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
}
