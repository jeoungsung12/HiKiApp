//
//  MainRecentView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit

final class MainRecentView: UIView {
    private let titleLabel = UILabel()
    private let resultLabel = UILabel()
    private let removeButton = UIButton()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    
    var removeAll: (()->Void)?
    var recentTapped: ((String)->Void)?
    var removeTapped: ((String)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ recentSearch: [String]) {
        configureStackView(recentSearch)
        removeButton.isHidden = (recentSearch.isEmpty) ? true : false
        resultLabel.text = (recentSearch.isEmpty) ? "최근 검색어 내역이 없습니다." : ""
    }
    
}

//MARK: - Configure UI
extension MainRecentView {
    
    private func configureHierarchy() {
        self.addSubview(removeButton)
        self.addSubview(titleLabel)
        self.scrollView.addSubview(stackView)
        self.addSubview(scrollView)
        self.addSubview(resultLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        removeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(removeButton.snp.leading).offset(-12)
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(removeButton.snp.bottom).offset(12)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(scrollView)
        }
    }
    
    private func configureView() {
        removeButton.setTitle("전체 삭제", for: .normal)
        removeButton.setTitleColor(.point, for: .normal)
        removeButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        titleLabel.text = "최근검색어"
        titleLabel.textColor = .customWhite
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        resultLabel.textColor = .customDarkGray
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        scrollView.showsHorizontalScrollIndicator = false
        
        configureHierarchy()
    }
    
    private func configureStackView(_ recentSearch: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for search in recentSearch {
            let recentView = RecentView()
            recentView.configure(search)
            recentView.titleTapped = recentItemTapped
            recentView.removeTapped = removeItemTapped
            stackView.addArrangedSubview(recentView)
        }
    }
    
}

//MARK: - Action
extension MainRecentView {
    
    @objc
    private func removeButtonTapped(_ sender: UIButton) {
        print(#function)
        removeAll?()
    }
    
    private func recentItemTapped(_ sender: String) {
        print(#function)
        recentTapped?(sender)
    }
    
    private func removeItemTapped(_ sender: String) {
        print(#function)
        removeTapped?(sender)
    }
}
