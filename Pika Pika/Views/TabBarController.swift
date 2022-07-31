//
//  TabBarController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    private lazy var timelineVC = TimelineViewController()
    private lazy var accountVC = AccountViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        // Style
        view.tintAdjustmentMode = .normal
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = .systemBackground.withAlphaComponent(0.1)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = .accentColor
        
        // UI
        let postButton = PikachuButton(frame: .zero)
        view.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        // VCs
        timelineVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        accountVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        viewControllers = [timelineVC, accountVC]
        
        // Action
        postButton.on(.touchUpInside) { [weak self] _ in
            let vc = AddNewPostViewController()
            vc.didTappedSubmit = { description in
                self?.selectedIndex = 0
                self?.timelineVC.addNewFeed(description: description)
            }
            self?.present(vc, animated: true)
        }
    }
}
