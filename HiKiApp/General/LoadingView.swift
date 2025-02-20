//
//  LoadingView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//
import UIKit
import SnapKit
import Kingfisher
import FLAnimatedImage

final class LoadingView: BaseView {
    private let imageView = AnimatedImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        self.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        
        if let imageData = Bundle.main.url(forResource: "onboarding", withExtension: "gif") {
            imageView.kf.setImage(with: imageData)
        }
    }
    
    private func applyParallelogramMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = createVerticalParallelogramPath().cgPath
        imageView.layer.mask = maskLayer
    }
    
    private func createVerticalParallelogramPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = self.bounds.width
        let height = self.bounds.height
        let offset: CGFloat = 40
        
        path.move(to: CGPoint(x: 0, y: offset))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - offset))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        return path
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyParallelogramMask()
    }
    
    deinit {
        print(#function, self)
    }
}
