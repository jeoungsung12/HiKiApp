//
//  PosterTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import Kingfisher
import SnapKit

class PosterTableViewCell: UITableViewCell {
    static let id: String = "PosterTableViewCell"
    private let posterImageView = UIImageView()
    private let imageShadowView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = false
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?, image: String?) {
        titleLabel.text = title
        if let image = image, let url = URL(string: image) {
            posterImageView.kf.setImage(with: url)
        }
    }

}

extension PosterTableViewCell {
    
    private func configureHierarchy() {
        [posterImageView, imageShadowView, titleLabel].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.width * 1.2)
            make.edges.equalToSuperview()
        }
        
        imageShadowView.snp.makeConstraints { make in
            make.edges.equalTo(posterImageView.snp.edges)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.greaterThanOrEqualToSuperview().offset(12)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .customBlack
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        
        posterImageView.backgroundColor = .customLightGray
        imageShadowView.image = UIImage(named: "backgroundImage")
        [posterImageView, imageShadowView].forEach({
            $0.contentMode = .scaleToFill
        })
        
        configureHierarchy()
    }
    
}
