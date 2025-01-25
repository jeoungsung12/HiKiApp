//
//  BackDropCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit
import Kingfisher
import SnapKit

final class BackDropCollectionViewCell: UICollectionViewCell {
    static let id: String = "BackDropCollectionViewCell"
    private let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ image: String) {
        if let url = URL(string: image) {
            imageView.kf.setImage(with: url)
            imageView.kf.indicatorType = .activity
        } else {
            imageView.image = nil
        }
    }
}

extension BackDropCollectionViewCell {
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        configureLayout()
    }
    
    private func configureLayout() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    private func configureView() {
        self.contentView.backgroundColor = .clear
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleToFill
        configureHierarchy()
    }
}
