//
//  DetailTeaserCollectionViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//
import UIKit
import Kingfisher
import SnapKit
import YouTubePlayerKit
import RxSwift
import RxCocoa

final class DetailTeaserCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private var player: YouTubePlayer?
    private var playerHostingView: YouTubePlayerHostingView
    private let playButton = UIButton()
    private var videoURL: String?
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        let initialPlayer = YouTubePlayer(urlString: "")
        self.playerHostingView = YouTubePlayerHostingView(player: initialPlayer)
        super.init(frame: frame)
    }
    
    private func setBinding() {
        playButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.playButton.isHidden = true
                owner.playButton.imageView?.contentMode = .scaleAspectFit
                
                Task {
                    try await owner.playerHostingView.player.play()
                }
            }
            .disposed(by: disposeBag)
    }

    override func configureView() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .black
        
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
    }

    override func configureHierarchy() {
        playerHostingView.clipsToBounds = true
        playerHostingView.layer.cornerRadius = 15
        
        [playerHostingView, playButton].forEach({
            self.contentView.addSubview($0)
        })
    }

    override func configureLayout() {
        playerHostingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    func configure(_ video: VideoTrailer) {
        guard var url = video.embed_url else { return }
        url += "&cc_load_policy=1"
        videoURL = url
        player = YouTubePlayer(urlString: url)
        playerHostingView.removeFromSuperview()
        playerHostingView = YouTubePlayerHostingView(player: player!)
        playerHostingView.isUserInteractionEnabled = true
        
        Task {
            try await playerHostingView.player.pause()
        }
        configureHierarchy()
    }
}
