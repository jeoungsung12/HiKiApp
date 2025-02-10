//
//  LoadingView.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import UIKit
import Lottie
import SnapKit

final class LoadingView: UIView {
    private let imageView = LottieAnimationView(name: "lottie")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LoadingView {
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        configureLayout()
    }
    
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.center.equalToSuperview()
        }
    }
    
    private func configureView() {
        self.backgroundColor = .clear
        imageView.loopMode = .loop
        imageView.contentMode = .scaleAspectFit
        
        configureHierarchy()
    }
 
    func isStop() {
        imageView.isHidden = true
    }
    
    func isStart() {
        imageView.play()
    }
}
