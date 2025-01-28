//
//  ErrorViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/28/25.
//

import UIKit
import SnapKit

class ErrorViewController: UIViewController {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(_ errorDescription: String?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = errorDescription
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

}

extension ErrorViewController {
    
    private func configureHierarchy() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
    
    private func configureView() {
        self.view.backgroundColor = .customBlack
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .customWhite
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .customDarkGray
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        descriptionLabel.text = "서비스 이용에 불편을 드려 죄송합니다.\n잠시 후 다시 시도해 주세요.😢"
        
        configureHierarchy()
    }
}
