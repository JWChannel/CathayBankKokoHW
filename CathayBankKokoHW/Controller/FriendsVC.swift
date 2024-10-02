//
//  FriendsVC.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/2.
//

import UIKit
import Combine

class FriendsVC: UIViewController {
    
    private let friendsVM = FriendsVM()
    private let userVM = UserVM()
    private let userView = UserView()
    private let friendsEmptyView = FriendsEmptyView()
    private let tableView = UITableView()
    private var invitationViewHeight: CGFloat = 0.0
    private var isStacked = false
    
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
        tableView.isHidden = true
        userView.resetInvitationView()
    }
}

fileprivate extension FriendsVC {
    
    func observeViewModel() {
        friendsVM.$uniqueFriends
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupUI()
                self?.userView.setupInvitationView(with: self?.friendsVM.invitations)
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
}

fileprivate extension FriendsVC {
    
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
                print(user)
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
}

fileprivate extension FriendsVC {
    
    func setupUI() {
        setupUserView()
        if friendsVM.rawFriends.isEmpty {
            friendsEmptyView.isHidden = false
            setupFriendEmptyView()
        } else {
            tableView.isHidden = false
            setupTableView()
            tableView.reloadData()
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
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userView.heightAnchor.constraint(equalToConstant: .userViewHeightPreset + invitationViewHeight)
        ])
    }
}

extension FriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "\(FriendCell.self)")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: userView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendsVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsVM.uniqueFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendCell.self)", for: indexPath) as? FriendCell else { return UITableViewCell() }
        let friend = friendsVM.uniqueFriends[indexPath.row]
        cell.friendNameLabel.text = friend.name
        cell.updateStatus(with: friend.status)
        cell.updateTopStatus(isTop: friend.isTop)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
