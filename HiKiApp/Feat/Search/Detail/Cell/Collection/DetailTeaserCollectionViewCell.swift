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

final class DetailTeaserCollectionViewCell: UICollectionViewCell {
    static let id: String = "DetailTeaserCollectionViewCell"

    private var player: YouTubePlayer?
    private var playerHostingView: YouTubePlayerHostingView
    private let playButton = UIButton()
    private var videoURL: String?

    override init(frame: CGRect) {
        let initialPlayer = YouTubePlayer(urlString: "")
        self.playerHostingView = YouTubePlayerHostingView(player: initialPlayer)
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ video: VideoTrailer) {
        guard var url = video.embed_url else { return }
        url += "&cc_load_policy=1"
        videoURL = url
        player = YouTubePlayer(urlString: url)
        playerHostingView.removeFromSuperview()
        playerHostingView = YouTubePlayerHostingView(player: player!)
        playerHostingView.isUserInteractionEnabled = true
        //TODO: Optional
//        if let url = URL(string: video.images?.jpg.image_url ?? "") {
//            posterImageView.kf.setImage(with: url)
//        }
//        
        Task {
            try await playerHostingView.player.pause()
        }
        configureHierarchy()
    }
}

extension DetailTeaserCollectionViewCell {
    private func configureView() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .black
        
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        configureHierarchy()
    }

    private func configureHierarchy() {
        playerHostingView.clipsToBounds = true
        playerHostingView.layer.cornerRadius = 15
        
        [playerHostingView, playButton].forEach({
            self.addSubview($0)
        })
        configureLayout()
    }

    private func configureLayout() {
        playerHostingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    @objc
    private func playButtonTapped(_ sender: UIButton) {
        print(#function)
        playButton.isHidden = true
        playButton.imageView?.contentMode = .scaleAspectFit
        
        Task {
            try await playerHostingView.player.play()
        }
    }
}
