//
//  MainRecentView.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchRecentView: BaseView {
    private let titleLabel = UILabel()
    private let resultLabel = UILabel()
    private let removeButton = UIButton()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    
    private let viewModel = SearchRecentViewModel()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setBindView() {
        let input = SearchRecentViewModel.Input(
            removeBtnTrigger: removeButton.rx.tap
        )
        let output = viewModel.transform(input)
        
        
    }
    
    override func configureHierarchy() {
        [removeButton, titleLabel].forEach({ self.addSubview($0 )})
        self.scrollView.addSubview(stackView)
        [scrollView, resultLabel].forEach({ self.addSubview($0) })
    }
    
    override func configureLayout() {
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
    
    override func configureView() {
        removeButton.setTitle("Delete All", for: .normal)
        removeButton.setTitleColor(.point, for: .normal)
        removeButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        titleLabel.text = "Recent Searches"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        resultLabel.textColor = .darkGray
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func configure(_ recentSearch: [String]) {
        configureStackView(recentSearch)
        removeButton.isHidden = (recentSearch.isEmpty) ? true : false
        resultLabel.text = (recentSearch.isEmpty) ? "There is no recent search history." : ""
    }
    
}

//MARK: - Configure UI
extension SearchRecentView {
    
    private func configureStackView(_ recentSearch: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for search in recentSearch {
            let recentView = RecentView()
            recentView.configure(search)
//            recentView.titleTapped = recentItemTapped
//            recentView.removeTapped = removeItemTapped
            stackView.addArrangedSubview(recentView)
        }
    }
    
}
