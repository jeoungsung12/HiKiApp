//
//  DetailReviewTableViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/13/25.
//

import UIKit
import SnapKit

class DetailReviewTableViewCell: UITableViewCell {
    static let id: String = "DetailReviewTableViewCell"
    private let tableView = UITableView()
    private let titleLabel = UILabel()
    private let moreButton = UIButton()
    var reviewData: [ReviewData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailReviewTableViewCell {
    
    private func configureHierarchy() {
        [titleLabel, moreButton, tableView].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(12)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
        
    }
    
    private func configureView() {
        titleLabel.text = "Reviews"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        moreButton.setTitle(isSelected ? "숨김" : "더보기", for: .normal)
        moreButton.setTitleColor(.point, for: .normal)
        moreButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
//        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        configureTableView()
        configureHierarchy()
    }
}

extension DetailReviewTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (reviewData.count > 3) ? 3 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let cellTitle = UILabel()
        cellTitle.text = reviewData[indexPath.row].user.username
        cellTitle.font = .boldSystemFont(ofSize: 15)
        cellTitle.textColor = .black
        
        let cellReviews = UILabel()
        cellReviews.numberOfLines = 3
        cellReviews.text = reviewData[indexPath.row].review
        cellReviews.font = .systemFont(ofSize: 14, weight: .semibold)
        cellReviews.textColor = .gray
        
        [cellTitle, cellReviews].forEach({
            cell.addSubview($0)
        })
        
        cellTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(8)
        }
        
        cellReviews.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(cellTitle.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
