//
//  SynopsisTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SynopsisTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let titleLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let moreButton = UIButton()
    private var disposeBag = DisposeBag()
    var reloadCell: (()->Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
        setBinding()
    }
    
    private func setBinding() {
        moreButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.isSelected.toggle()
                owner.reloadCell?()
            }.disposed(by: disposeBag)
    }
    
    override var isSelected: Bool {
        didSet {
            configureView()
        }
    }
    
    override func configureHierarchy() {
        [moreButton, titleLabel, synopsisLabel].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
        
        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(12)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(moreButton.snp.bottom).offset(8)
        }
        
    }
    
    override func configureView() {
        self.backgroundColor = .white
        
        titleLabel.text = "Synopsis"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        moreButton.setTitle(isSelected ? "Hide" : "More", for: .normal)
        moreButton.setTitleColor(.point, for: .normal)
        moreButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        synopsisLabel.textColor = .darkGray
        synopsisLabel.textAlignment = .left
        synopsisLabel.numberOfLines = (isSelected ? 0 : 3)
        synopsisLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
    }
    
    func configure(_ synopsis: String?) {
        if let synopsis = synopsis {
            synopsisLabel.text = synopsis
        }
    }
    
}
