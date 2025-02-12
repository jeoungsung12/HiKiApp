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
    
    //TODO: - ViewModel
    private var buttonTapped: Bool = false
    var isButton: (()->Void)?
    var id: Int?
    
    private let viewModel = SearchDetailViewModel()
    private lazy var inputTrigger = SearchDetailViewModel.Input(
        detailTrigger: Observable(self.id ?? 1),
        heartBtnTrigger: Observable(())
    )
    private lazy var outputResult = viewModel.transform(input: inputTrigger)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBinding()
    }
    
    private func setBinding() {
        outputResult.animeData.bind { [weak self] data in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func configure() {
        //TODO: id로 좋아요 유무 구분
    }
    
    deinit {
        print(#function, self)
    }
    
}

//MARK: - Configure UI
extension SearchDetailViewController {
    
    private func configureHierarchy() {
        [tableView, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
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
    }
    
    private func configureView() {
        self.setNavigation()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = heartButton
        
        loadingIndicator.style = .medium
        loadingIndicator.color = .customLightGray
        
        configure()
        configureTableView()
        configureHierarchy()
    }
    
}

extension SearchDetailViewController {
    
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        print(#function)
        inputTrigger.heartBtnTrigger.value = ()
    }
    
}

//MARK: - TableView
extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.id)
        tableView.register(SynopsisTableViewCell.self, forCellReuseIdentifier: SynopsisTableViewCell.id)
        tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: CharactersTableViewCell.id)
        tableView.register(TeaserTableViewCell.self, forCellReuseIdentifier: TeaserTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SearchDetailViewModel.DetailType.allCases[indexPath.row] {
            //TODO: 옵셔널 예외처리
        case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.id, for: indexPath) as? PosterTableViewCell else { return UITableViewCell() }
            let value = outputResult.animeData.value
            cell.configure(title: value?.synopsis?.title, image: value?.synopsis?.images.jpg.image_url)
            return cell
            
        case .characters:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.id, for: indexPath) as? CharactersTableViewCell else { return UITableViewCell() }
            cell.charactersData = outputResult.animeData.value?.characters ?? []
            return cell
            
        case .teaser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TeaserTableViewCell.id, for: indexPath) as? TeaserTableViewCell else { return UITableViewCell() }
            cell.teaserData = outputResult.animeData.value?.teaser ?? []
            return cell
            
        case .synopsis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisTableViewCell.id, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }
            cell.configure(outputResult.animeData.value?.synopsis?.synopsis)
            cell.reloadCell = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
            
        case .reviews:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
