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
        self.isUserInteractionEnabled = true
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(_ image: String) {
//        if let url = URL(string: APIEndpoint.topAnime.imagebaseURL + image) {
//            imageView.kf.setImage(with: url) { result in
//                switch result {
//                case .success:
//                    self.imageView.image = self.imageView.image?.downSampling(scale: 0.7)
//                case .failure:
//                    self.imageView.kf.setImage(with: url)
//                }
//            }
//        }
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
        self.backgroundColor = .customBlack
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleToFill
        configureHierarchy()
    }
}
