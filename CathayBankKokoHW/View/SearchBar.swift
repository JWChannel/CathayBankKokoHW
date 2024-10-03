//
//  SearchBar.swift
//  CathayBankKokoHW
//
//  Created by J W on 2024/10/3.
//

import UIKit

final class SearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchBar {
    
    func setupSearchBar() {
        placeholder = "想轉一筆給誰呢？"
        searchBarStyle = .minimal
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        returnKeyType = .search
        enablesReturnKeyAutomatically = false
        translatesAutoresizingMaskIntoConstraints = false
    }
}

#Preview {
    SearchBar()
}
