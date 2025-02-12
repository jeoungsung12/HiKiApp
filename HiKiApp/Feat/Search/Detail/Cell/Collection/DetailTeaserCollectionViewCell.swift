//
//  DetailTeaserCollectionViewCell.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//
import UIKit
import SnapKit
import YouTubePlayerKit

final class DetailTeaserCollectionViewCell: UICollectionViewCell {
    static let id: String = "DetailTeaserCollectionViewCell"

    private var player: YouTubePlayer?
    private var playerHostingView: YouTubePlayerHostingView

//    private var isPreparedToPlay = false
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
    
    func configure(_ video: AnimateTrailer) {
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

extension DetailTeaserCollectionViewCell {
    private func configureView() {
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .black
        configureHierarchy()
    }

    private func configureHierarchy() {
        self.contentView.addSubview(playerHostingView)
        configureLayout()
    }

    private func configureLayout() {
        playerHostingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
