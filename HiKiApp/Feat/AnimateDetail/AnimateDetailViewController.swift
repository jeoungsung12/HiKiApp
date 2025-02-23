//
//  SearchDetailViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

final class AnimateDetailViewController: BaseViewController {
    let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: nil, action: nil)
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private let tableView = UITableView()
    
    let viewModel: AnimateDetailViewModel
    private lazy var inputTrigger = AnimateDetailViewModel.Input(
        didLoadTrigger: PublishSubject<Void>(),
        heartBtnTrigger: heartButton.rx.tap
    )
    private lazy var outputResult = viewModel.transform(inputTrigger)
    init(viewModel: AnimateDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.didLoadTrigger.onNext(())
        loadingIndicator.startAnimating()
    }
    
    override func setBinding() {
        outputResult.heartResult
            .drive(with: self) { owner, valid in
                owner.heartButton.image = (valid) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            }
            .disposed(by: disposeBag)
        
        outputResult.animeData
            .bind(with: self) { owner, data in
                owner.tableView.reloadData()
                owner.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [tableView, loadingIndicator].forEach({
            self.view.addSubview($0)
        })
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(49)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.setNavigation(apperanceColor: .clear)
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = heartButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .point
        
        configureTableView()
    }
    
    deinit {
        print(#function, self)
    }
    
}

//MARK: - TableView
extension AnimateDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.id)
        tableView.register(SynopsisTableViewCell.self, forCellReuseIdentifier: SynopsisTableViewCell.id)
        tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: CharactersTableViewCell.id)
        tableView.register(TeaserTableViewCell.self, forCellReuseIdentifier: TeaserTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimateDetailViewModel.DetailType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch AnimateDetailViewModel.DetailType.allCases[indexPath.row] {
        case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.id, for: indexPath) as? PosterTableViewCell else { return UITableViewCell() }
            let value = outputResult.animeData.value
            cell.configure(title: value.synopsis?.enTitle, image: value.synopsis?.imageURL)
            return cell
            
        case .synopsis:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SynopsisTableViewCell.id, for: indexPath) as? SynopsisTableViewCell, let synopsis = outputResult.animeData.value.synopsis?.synopsis else { return UITableViewCell() }
            cell.configure(synopsis)
            cell.reloadCell = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return cell
            
        case .teaser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TeaserTableViewCell.id, for: indexPath) as? TeaserTableViewCell, let teaser = outputResult.animeData.value.teaser else { return UITableViewCell() }
            cell.input.inputTrigger.onNext(teaser)
            return cell
            
        case .characters:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.id, for: indexPath) as? CharactersTableViewCell, let characters = outputResult.animeData.value.characters else { return UITableViewCell() }
            cell.input.inputTrigger.onNext(characters)
            return cell
        }
    }
    
}
