//
//  PosterTableViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PosterTableViewCell: BaseTableViewCell, ReusableIdentifier {
    private let posterImageView = UIImageView()
    private let imageShadowView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    override func configureHierarchy() {
        [posterImageView, imageShadowView, titleLabel].forEach({
            self.contentView.addSubview($0)
        })
    }
    
    override func configureLayout() {
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
    
    override func configureView() {
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
    }
    
    func configure(title: String?, image: String?) {
        titleLabel.text = title
        if let image = image, let url = URL(string: image) {
            posterImageView.kf.setImage(with: url)
        }
    }

}
