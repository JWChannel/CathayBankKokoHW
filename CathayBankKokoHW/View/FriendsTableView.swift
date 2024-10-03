//
//  FriendsTableView.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/3.
//

import UIKit
import MJRefresh

final class FriendsTableView: UIView {

    var friendsVM: FriendsVM
    private let addFriendButton = UIButton()
    private let searchBar = SearchBar()
    private let tableView = UITableView()
    private var filteredFriends: [Friend] = []
    var friends: [Friend] = [] {
        didSet {
            filteredFriends = friends
            tableView.reloadData()
        }
    }
    
    init(friendsVM: FriendsVM) {
        self.friendsVM = friendsVM
        super.init(frame: .zero)
        setupAddFriendButton()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        setupMJRefresh()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FriendsTableView {
    
    func setupAddFriendButton() {
        addFriendButton.setImage(UIImage(named: "icBtnAddFriends"), for: .normal)
        addFriendButton.setTitleColor(.darkGray, for: .normal)
        addFriendButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        addSubview(addFriendButton)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "\(FriendCell.self)")
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupMJRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            Task {
                do {
                    try await self?.friendsVM.fetchFriendsTaskGroup()
                } catch {
                    print(error)
                }
                self?.tableView.reloadData()
                await self?.tableView.mj_header?.endRefreshing()
            }
        })
    }
    
    func setupConstraints() {
      
        NSLayoutConstraint.activate([
            addFriendButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            addFriendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            addFriendButton.widthAnchor.constraint(equalToConstant: 24),
            addFriendButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: addFriendButton.centerYAnchor),
            searchBar.trailingAnchor.constraint(equalTo: addFriendButton.leadingAnchor, constant: -10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            searchBar.heightAnchor.constraint(equalToConstant: 66)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FriendsTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendCell.self)", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        let friend = filteredFriends[indexPath.row]
        cell.friendNameLabel.text = friend.name
        cell.updateStatus(with: friend.status)
        cell.updateTopStatus(isTop: friend.isTop)
        return cell
    }
}

extension FriendsTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FriendsTableView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch searchText.isEmpty {
        case true:
            filteredFriends = friends
        case false:
            filteredFriends = friends.filter { $0.name.contains(searchText) }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let blankOnTap = UITapGestureRecognizer(target: searchBar, action: #selector(UIView.endEditing))
        self.searchBar.addGestureRecognizer(blankOnTap)

        NotificationCenter.default.post(name: .searchBarDidBeginEditing, object: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        NotificationCenter.default.post(name: .searchBarDidEndEditing, object: nil)
    }
}
