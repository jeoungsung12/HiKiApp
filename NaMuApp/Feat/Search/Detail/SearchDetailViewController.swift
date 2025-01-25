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
    private let loadingIndicator = UIActivityIndicatorView()
    
    var searchData: SearchResult?
    private var imageData: ImageModel?
    private var creditData: CreditModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
}

//MARK: - Configure UI
extension SearchDetailViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(tableView)
        self.view.addSubview(loadingIndicator)
        configureLayout()
    }
    
    private func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        
        fetchData()
    }
    
    private func configureView() {
        guard let searchData = searchData else { return }
        self.setNavigation(searchData.title)
        self.view.backgroundColor = .black
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .lightGray
        
        configureTableView()
        configureHierarchy()
    }
    
}

extension SearchDetailViewController {
    
    private func fetchData() {
        guard let searchData = searchData else { return }
        loadingIndicator.startAnimating()
        let group = DispatchGroup()
        group.enter()
        ImageServices().getImage(searchData.id) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.imageData = data
                group.leave()
            case  let .failure(error):
                print(error)
                group.leave()
            }
        }
//        group.enter()
//        CastServices().getCredit(searchData.id) { [weak self] response in
//            guard let self = self else { return }
//            switch response {
//            case let .success(data):
//                self.creditData = data
//                group.leave()
//            case  let .failure(error):
//                print(error)
//                group.leave()
//            }
//        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
}

//MARK: - TableView
extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(BackDropTableViewCell.self, forCellReuseIdentifier: BackDropTableViewCell.id)
        tableView.register(SynopsisTableViewCell.self, forCellReuseIdentifier: SynopsisTableViewCell.id)
        tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.id)
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SearchItems.allCases[indexPath.row] {
        case .backdrop:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackDropTableViewCell.id, for: indexPath) as? BackDropTableViewCell, let backdrops = self.imageData?.backdrops else { return UITableViewCell() }
            cell.backdrops = backdrops
            
            return cell

        case .synopsis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisTableViewCell.id, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }
            
            return cell
            
        case .cast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.id, for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            
            return cell
            
        case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.id, for: indexPath) as? PosterTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
