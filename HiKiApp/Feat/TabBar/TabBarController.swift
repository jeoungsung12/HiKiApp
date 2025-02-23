//
//  TabBarViewController.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

extension TabBarController {
    
    private func configure() {
        let firstVC = UINavigationController(rootViewController: MainViewController())
        let secondVC = UINavigationController(rootViewController: SearchViewController())
        let thirdVC = UINavigationController(rootViewController: MineReviewViewController())
        let forthVC = UINavigationController(rootViewController: ReviewViewController())
        let fifthVC = UINavigationController(rootViewController: MyPageViewController())
        
        self.setViewControllers([firstVC, secondVC, thirdVC, forthVC, fifthVC], animated: true)
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "popcorn")
        items[1].image = UIImage(systemName: "magnifyingglass")
        items[2].image = UIImage(systemName: "star.bubble")
        items[3].image = UIImage(systemName: "bubble")
        items[4].image = UIImage(systemName: "person.circle")
        
        items[0].title = "Cinema"
        items[1].title = "Search"
        items[2].title = "My Review"
        items[3].title = "Review"
        items[4].title = "Profile"
           
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customWhite
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.selectedIndex = 0
        self.tabBar.tintColor = .point
        self.tabBar.unselectedItemTintColor = .customDarkGray
    }
    
}
