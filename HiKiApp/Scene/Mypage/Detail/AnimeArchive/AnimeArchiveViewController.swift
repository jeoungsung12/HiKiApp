//
//  AnimeArchiveViewController.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

final class AnimeArchiveViewController: BaseViewController {
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private let tableView = UITableView()
    private let resultLabel = UILabel()
    private let viewModel = AnimeArchiveViewModel()
    private let inputTrigger = AnimeArchiveViewModel.Input(
        reloadTrigger: PublishSubject<Void>()
    )
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.reloadTrigger.onNext(())
        if !viewModel.getSaveAnimeData().isEmpty {
            loadingIndicator.startAnimating()
        }
    }
    
    override func setBindView() {
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AnimateDetailEntity.self))
            .map { $0.1 }
            .bind(with: self) { owner, value in
                let vm = AnimateDetailViewModel(id: value.id)
                let vc = AnimateDetailViewController(viewModel: vm)
                owner.push(vc)
            }
            .disposed(by: disposeBag)
    }
    
    override func setBinding() {
        let output = viewModel.transform(inputTrigger)
        
        output.dataResult
            .drive(with: self) { owner, data in
                owner.loadingIndicator.stopAnimating()
                owner.resultLabel.text = (data.isEmpty) ? owner.viewModel.saveAnime : nil
            }
            .disposed(by: disposeBag)
        
        output.dataResult
            .drive(tableView.rx.items(cellIdentifier: AnimeArchiveTableViewCell.id, cellType: AnimeArchiveTableViewCell.self)) { [weak self] row, element, cell in
                cell.configure(element)
                self?.loadingIndicator.stopAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        setNavigation("Saved Animation")
        self.view.backgroundColor = .white
        tableView.rowHeight = 150
        tableView.register(AnimeArchiveTableViewCell.self, forCellReuseIdentifier: AnimeArchiveTableViewCell.id)
        
        resultLabel.textColor = .gray
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        resultLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    override func configureHierarchy() {
        [tableView, resultLabel, loadingIndicator].forEach({ self.view.addSubview($0) })
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    deinit {
        print(#function, self)
    }
}
