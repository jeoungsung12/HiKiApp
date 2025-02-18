//
//  SearchDetailViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView


final class SearchDetailViewController: UIViewController {
    private lazy var heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartButtonTapped))
    private let tableView = UITableView()
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    
    //TODO: - ViewModel
    private var buttonTapped: Bool = false
    var isButton: (()->Void)?
    var id: Int?
    
    private let viewModel = SearchDetailViewModel()
    private lazy var inputTrigger = SearchDetailViewModel.Input(
        detailTrigger: CustomObservable(self.id ?? 1),
        heartBtnTrigger: CustomObservable(())
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
                self?.loadingIndicator.stopAnimating()
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
            make.bottom.equalToSuperview().inset(49)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingIndicator.startAnimating()
    }
    
    private func configureView() {
        self.setNavigation(apperanceColor: .clear)
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = heartButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        
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
        loadingIndicator.startAnimating()
    }
    
}

//MARK: - TableView
extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.id)
        tableView.register(SynopsisTableViewCell.self, forCellReuseIdentifier: SynopsisTableViewCell.id)
        tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: CharactersTableViewCell.id)
        tableView.register(TeaserTableViewCell.self, forCellReuseIdentifier: TeaserTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchDetailViewModel.DetailType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SearchDetailViewModel.DetailType.allCases[indexPath.row] {
            //TODO: 옵셔널 예외처리
        case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.id, for: indexPath) as? PosterTableViewCell else { return UITableViewCell() }
            let value = outputResult.animeData.value
            cell.configure(title: value?.synopsis?.title, image: value?.synopsis?.images.jpg.image_url)
            return cell
            
        case .synopsis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisTableViewCell.id, for: indexPath) as? SynopsisTableViewCell else { return UITableViewCell() }
            cell.configure(outputResult.animeData.value?.synopsis?.synopsis)
            cell.reloadCell = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
            
        case .teaser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TeaserTableViewCell.id, for: indexPath) as? TeaserTableViewCell else { return UITableViewCell() }
            cell.teaserData = outputResult.animeData.value?.teaser ?? []
            return cell
            
        case .characters:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.id, for: indexPath) as? CharactersTableViewCell else { return UITableViewCell() }
            cell.charactersData = outputResult.animeData.value?.characters ?? []
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
