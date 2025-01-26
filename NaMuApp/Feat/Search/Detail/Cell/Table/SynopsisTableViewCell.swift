//
//  SynopsisTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

class SynopsisTableViewCell: UITableViewCell {
    static let id: String = "SynopsisTableViewCell"
    private let titleLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let moreButton = UIButton()
    var reloadCell: (()->Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    
    override var isSelected: Bool {
        didSet {
            configureView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ synopsis: String) {
        synopsisLabel.text = synopsis
    }
    
}

extension SynopsisTableViewCell {
    
    private func configureHierarchy() {
        self.addSubview(moreButton)
        self.addSubview(titleLabel)
        self.addSubview(synopsisLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        
        moreButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(moreButton.snp.bottom).offset(8)
        }
        
    }
    
    private func configureView() {
        self.backgroundColor = .black
        
        titleLabel.text = "Synopsis"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        moreButton.setTitle(isSelected ? "Hide" : "More", for: .normal)
        moreButton.setTitleColor(.point, for: .normal)
        moreButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        synopsisLabel.textColor = .white
        synopsisLabel.textAlignment = .left
        synopsisLabel.numberOfLines = (isSelected ? 0 : 3)
        synopsisLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        configureHierarchy()
    }
    
    @objc
    private func moreButtonTapped(_ sender: UIButton) {
        print(#function)
        isSelected.toggle()
        reloadCell?()
    }
    
}
