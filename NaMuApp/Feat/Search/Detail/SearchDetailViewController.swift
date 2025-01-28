//
//  SearchDetailViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import SnapKit

final class SearchDetailViewController: UIViewController {
    private lazy var heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartButtonTapped))
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView()
    private var imageData: ImageModel?
    private var creditData: CreditModel?
    private let db = Database.shared
    private var buttonTapped: Bool = false
    
    var isButton: (()->Void)?
    var searchData: SearchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configure() {
        guard let data = searchData else { return }
        buttonTapped = db.heartList.contains(data.title)
        heartButton.image = UIImage(systemName: (db.heartList.contains(data.title) ? "heart.fill" : "heart"))
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
        self.view.backgroundColor = .customBlack
        self.navigationItem.rightBarButtonItem = heartButton
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        
        configure()
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
        group.enter()
        CastServices().getCredit(searchData.id) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(data):
                self.creditData = data
                group.leave()
            case  let .failure(error):
                print(error)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        print(#function)
        if let data = self.searchData {
            buttonTapped.toggle()
            if buttonTapped {
                var list = db.heartList
                list.append(data.title)
                db.heartList = list
            } else {
                db.removeHeartButton(data.title)
            }
            self.configure()
            self.isButton?()
        }
    }
    
}

//MARK: - TableView
extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .customBlack
        tableView.register(BackDropTableViewCell.self, forCellReuseIdentifier: BackDropTableViewCell.id)
        tableView.register(SynopsisTableViewCell.self, forCellReuseIdentifier: SynopsisTableViewCell.id)
        tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.id)
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchData = self.searchData, let imageData = self.imageData, let creditData = self.creditData else { return UITableViewCell() }
        
        switch SearchItems.allCases[indexPath.row] {
        case .backdrop:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BackDropTableViewCell.id, for: indexPath) as? BackDropTableViewCell else { return UITableViewCell() }
            cell.backdrops = imageData.backdrops
            cell.configure(searchData)
            return cell

        case .synopsis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisTableViewCell.id, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }
            cell.configure(searchData.overview)
            cell.reloadCell = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
            
        case .cast:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.id, for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            cell.castData = creditData.cast ?? []
            return cell
            
        case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.id, for: indexPath) as? PosterTableViewCell else { return UITableViewCell() }
            cell.posterData = imageData.posters
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
