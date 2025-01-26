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
        let secondVC = UINavigationController(rootViewController: MainViewController())
        let thirdVC = UINavigationController(rootViewController: MyPageViewController())
        
        self.setViewControllers([firstVC, secondVC, thirdVC], animated: true)
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "popcorn")
        items[1].image = UIImage(systemName: "film.stack")
        items[2].image = UIImage(systemName: "person.circle")
        
        items[0].title = "CINEMA"
        items[1].title = "UPCOMING"
        items[2].title = "PROFILE"
           
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.selectedIndex = 0
        self.tabBar.tintColor = .point
        self.tabBar.unselectedItemTintColor = .gray
    }
    
}
