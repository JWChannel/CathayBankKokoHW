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
        resetInvitationView()
    }
}

fileprivate extension FriendsVC {
    
    func setupInvitationView() {
        var prevInvitationCard: InvitationCard? = nil
        
        for (index, friend) in friendsVM.invitations.enumerated() {
            let newInvitationCard = InvitationCard()
            newInvitationCard.nameLabel.text = friend.name
            newInvitationCard.layer.cornerRadius = 10
            
            newInvitationCard.layer.shadowColor = UIColor.systemGray2.cgColor
            newInvitationCard.layer.shadowOffset = CGSize(width: 0, height: 4)
            newInvitationCard.layer.shadowRadius = 6
            newInvitationCard.layer.shadowOpacity = 0.4

            view.addSubview(newInvitationCard)
            newInvitationCard.translatesAutoresizingMaskIntoConstraints = false

            switch index {
            case 0:
                NSLayoutConstraint.activate([
                    newInvitationCard.topAnchor.constraint(equalTo: userView.userIdLabel.bottomAnchor, constant: 35),
                    newInvitationCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
                    newInvitationCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                    newInvitationCard.heightAnchor.constraint(equalToConstant: .invitationViewHeightPreset)
                ])
                view.bringSubviewToFront(newInvitationCard) // make sure the view is at the very top
            default:
                if let previousCard = prevInvitationCard {
                    NSLayoutConstraint.activate([
                        newInvitationCard.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: 10),
                        newInvitationCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
                        newInvitationCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
                        newInvitationCard.heightAnchor.constraint(equalToConstant: .invitationViewHeightPreset)
                    ])
                }
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleInvitationTapped(_:)))
            newInvitationCard.tapAreaButton.addGestureRecognizer(tapGesture)

            if index > 0 {
                view.insertSubview(newInvitationCard, aboveSubview: userView)
            }

            prevInvitationCard = newInvitationCard
        }

        invitationViewHeight = CGFloat(friendsVM.invitations.count) * .invitationViewHeightPreset + CGFloat(friendsVM.invitations.count - 1) * .invitationViewSpacePreset
        
        updateUserViewHeight(plus: invitationViewHeight)
    }

    @objc func handleInvitationTapped(_ sender: UITapGestureRecognizer) {
        let invitationCards = view.subviews.filter { $0 is InvitationCard }.reversed() // reversed to make sure the top view is the first one
        
        switch isStacked {
        case true:
            for (index, card) in invitationCards.enumerated() {
                guard index != 0 else { continue }
                UIView.animate(withDuration: 0.3) {
                    card.transform = .identity
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.updateUserViewHeight(plus: self.invitationViewHeight)
            }
            
        case false:
            for (index, card) in invitationCards.enumerated() {
                guard index != 0 else { continue }
                UIView.animate(withDuration: 0.3) {
                    card.transform = CGAffineTransform(translationX: 0, y: -(.invitationViewHeightPreset + .invitationViewSpacePreset) * CGFloat(index) + 10).scaledBy(x: 0.93, y: 0.93)
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.updateUserViewHeight(plus: .invitationViewHeightPreset)
            }
        }
        isStacked.toggle()
    }

    func updateUserViewHeight(plus invitationViewHeight : CGFloat) {
        
        view.subviews.filter { $0 is UserView }.forEach { view in
            view.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    view.removeConstraint(constraint)
                }
            }
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: .userViewHeightPreset + invitationViewHeight)
            ])
        }
        view.layoutIfNeeded()
    }
    
    func resetInvitationView() {
        view.subviews.filter { $0 is InvitationCard }.forEach { card in
            card.removeFromSuperview()
        }
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
        return friendsVM.uniqueFriends.isEmpty ? 1 : friendsVM.uniqueFriends.count
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

fileprivate extension FriendsVC {
    
    func observeViewModel() {
        
        friendsVM.$uniqueFriends
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
                self?.setupInvitationView()
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
    
    func updateUI() {
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
    
    func setupUserView() {
        view.addSubview(userView)
        userView.backgroundColor = .white
        userView.translatesAutoresizingMaskIntoConstraints = false
        
        let userViewHeight = userView.heightAnchor.constraint(equalToConstant: .userViewHeightPreset + invitationViewHeight)
        userViewHeight.isActive = true
        
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
}
