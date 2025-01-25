//
//  SearchDetailViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import SnapKit

class SearchDetailViewController: UIViewController {
    private let heartButton = UIBarButtonItem()
    private let tableView = UITableView()
    
    var navigationTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

extension SearchDetailViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(tableView)
        
        configureLayout()
    }
    
    private func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func configureView() {
        self.setNavigation(navigationTitle)
        self.view.backgroundColor = .black
        
        configureHierarchy()
    }
    
}

extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchDetailTableViewCell.self, forCellReuseIdentifier: SearchDetailTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailTableViewCell.id, for: indexPath) as? SearchDetailTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
