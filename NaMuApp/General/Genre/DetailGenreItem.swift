//
//  GenreItem.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

final class DetailGenreItem: UIStackView {
    private let genreLabel = UILabel()
    private let genreImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ image: UIImage?,_ genre: String) {
        genreImage.image = image
        genreLabel.text = genre
    }
}

extension DetailGenreItem {
    
    private func configureHierarchy() {
        self.addArrangedSubview(genreImage)
        self.addArrangedSubview(genreLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        
        genreImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.verticalEdges.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
        }
        
    }
    
    private func configureView() {
        self.spacing = 4
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        
        genreLabel.textAlignment = .left
        genreLabel.textColor = .customDarkGray
        genreLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        genreImage.tintColor = .customDarkGray
        genreImage.contentMode = .scaleAspectFit
        configureHierarchy()
    }
}
