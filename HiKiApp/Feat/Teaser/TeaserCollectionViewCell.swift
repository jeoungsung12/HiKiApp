//
//  WatchCollectionViewCell.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/9/25.
//

import UIKit
import SnapKit
import YouTubePlayerKit
import NVActivityIndicatorView

final class TeaserCollectionViewCell: BaseCollectionViewCell, ReusableIdentifier {
    private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballPulseSync, color: .point)
    private var player: YouTubePlayer?
    private var playerHostingView: YouTubePlayerHostingView
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private var isPreparedToPlay = false
    private var videoURL: String?

    override init(frame: CGRect) {
        let initialPlayer = YouTubePlayer(urlString: "")
        self.playerHostingView = YouTubePlayerHostingView(player: initialPlayer)
        super.init(frame: frame)
    }
    
    override func configureView() {
        contentView.backgroundColor = .white
        
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        descriptionLabel.textColor = .gray
        descriptionLabel.font = .boldSystemFont(ofSize: 14)
        playerHostingView.clipsToBounds = true
        playerHostingView.layer.cornerRadius = 15
        playerHostingView.backgroundColor = .black
        playerHostingView.isUserInteractionEnabled = false
        
        [titleLabel, descriptionLabel].forEach({
            $0.textAlignment = .left
            $0.numberOfLines = 2
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerHostingView.clipsToBounds = true
        playerHostingView.layer.cornerRadius = 15
        playerHostingView.backgroundColor = .black
        playerHostingView.isUserInteractionEnabled = false
    }

    override func configureHierarchy() {
        [titleLabel, descriptionLabel, playerHostingView, loadingIndicator].forEach {
            contentView.addSubview($0)
        }
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        playerHostingView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    func configure(_ video: AnimateData) {
        titleLabel.text = video.title
        var genreString = ""
        video.genres?.forEach({ genreString += $0.name})
        descriptionLabel.text = genreString
        
        guard var url = video.trailer.embed_url else { return }
        url += "&cc_load_policy=1"
        videoURL = url
        player = YouTubePlayer(urlString: url)
        playerHostingView.removeFromSuperview()
        playerHostingView = YouTubePlayerHostingView(player: player!)
        
        Task {
            try await playerHostingView.player.play()
            self.loadingIndicator.stopAnimating()
        }
        loadingIndicator.startAnimating()
        isPreparedToPlay = false
        configureHierarchy()
    }

    func playVideoIfNeeded() {
        print(#function, titleLabel.text ?? "")
        guard let player = player, !isPreparedToPlay else { return }
        
//        Task {
//            do {
//                try await player.play()
//                DispatchQueue.main.async {
//                    self.isPreparedToPlay = true
//                    self.loadingIndicator.stopAnimating()
//                }
//            } catch {
//                print("Failed to play video: \(error)")
//            }
//        }
    }

    func stopVideo() {
        print(#function, titleLabel.text ?? "")
        guard let player = player else { return }
        
//        Task {
//            try await player.stop()
//            DispatchQueue.main.async {
//                self.isPreparedToPlay = false
//                self.loadingIndicator.stopAnimating()
//            }
//        }
    }
}

extension TeaserCollectionViewCell {
}
