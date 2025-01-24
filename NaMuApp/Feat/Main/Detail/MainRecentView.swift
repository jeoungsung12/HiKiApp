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
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
}

extension MainRecentView {
    
    private func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(scrollView)
        self.addSubview(resultLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.center.equalTo(scrollView)
        }
    }
    
    private func configureView() {
        titleLabel.text = "최근검색어"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        resultLabel.textColor = .lightGray
        resultLabel.textAlignment = .center
        resultLabel.text = "최근 검색어 내역이 없습니다."
        resultLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        
        
        
        configureHierarchy()
    }
    
}
