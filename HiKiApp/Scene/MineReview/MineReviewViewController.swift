//
//  MineReviewViewController.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

final class MineReviewViewController: BaseViewController {
    private let tableView = UITableView()
    private let viewModel = MineReviewViewModel()
    private let input = MineReviewViewModel.Input(
        loadTrigger: PublishRelay<Void>(),
        removeTrigger: PublishRelay()
    )
    private lazy var output = viewModel.transform(input)
    private var disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.loadTrigger.accept(())
    }
    
    override func setBinding() {
        output.dataResult
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: MineReviewTableViewCell.id, cellType: MineReviewTableViewCell.self)) { row, element, cell in
                cell.configure(element)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        setNavigation("My Review")
        self.view.backgroundColor = .white
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MineReviewTableViewCell.self, forCellReuseIdentifier: MineReviewTableViewCell.id)
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension MineReviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, _ in
            if let data = self?.output.dataResult.value[indexPath.row] {
                self?.input.removeTrigger.accept(data)
            }
        })])
    }
}
