//
//  FriendsVC.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit
import Combine

final class FriendsVC: UIViewController {
    
    private let realService = RealFriendsService() // For dependency injection
    private lazy var friendsVM = FriendsVM(service: realService)
    private let userVM = UserVM()
    private let userView = UserView()
    private let emptyView = FriendsEmptyView()
    private lazy var tableView = FriendsTableView(friendsVM: friendsVM)
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
        emptyView.isHidden = false
        tableView.isHidden = true
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
                self?.userView.setupInvitationView(with: self?.friendsVM.uniqueFriends.filter { $0.status == 2 } )
                self?.tableView.friends = self?.friendsVM.uniqueFriends ?? []
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
        switch friendsVM.rawFriends.isEmpty {
        case true:
            emptyView.isHidden = false
            setupFriendEmptyView()
            tableView.isHidden = true
        case false:
            switch friendsVM.scenario {
            case .noFriends:
                userView.inviteLimit = 0
            case .friendsOnly:
                userView.inviteLimit = 0
            case .friendsWithInvitations:
                userView.inviteLimit = 4
            }
            emptyView.isHidden = true
            tableView.isHidden = false
            setupFriendsTableView()
        }
    }

    func setupFriendEmptyView() {
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: userView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        if tableView.superview == nil {
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: userView.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}
