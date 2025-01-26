//
//  GenreItem.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import SnapKit

final class GenreView: UIView {
    private let genreStackView = UIStackView()
    private let genreScrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: [SummaryInfo]) {
        configureView()
        configureStackView(model)
    }
    
}

extension GenreView {
    
    private func configureHierarchy() {
        genreScrollView.addSubview(genreStackView)
        self.addSubview(genreScrollView)
        configureLayout()
    }
    
    private func configureLayout() {
        genreStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        genreScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        genreStackView.spacing = 8
        genreStackView.axis = .horizontal
        genreStackView.alignment = .center
        genreStackView.distribution = .fill
        genreScrollView.showsHorizontalScrollIndicator = false
        configureHierarchy()
    }
    
    private func configureStackView(_ model: [SummaryInfo]) {
        for type in model {
            let genreItem = GenreItem()
            genreItem.configure(type.image, type.text)
            genreStackView.addArrangedSubview(genreItem)
            genreItem.snp.makeConstraints { make in
                make.height.equalToSuperview()
            }
        }
    }
}
