//
//  FriendsTableView.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/3.
//

import UIKit

final class FriendsTableView: UIView {

    private let addFriendButton = UIButton()
    private let searchBar = SearchBar()
    private let tableView = UITableView()

    var friends: [Friend] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddFriendButton()
        setupSearchBar()
        setupTableView()
        setupConstraints()
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
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendCell.self)", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        let friend = friends[indexPath.row]
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

#Preview {
    FriendsTableView()
}
