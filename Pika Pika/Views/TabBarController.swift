//
//  TabBarController.swift
//  Pika Pika
//
//  Created by KoingDev on 30/7/22.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    private struct Constant {
        static let timelineTabBarImageName = (normal: "house", selected: "house.fill")
        static let accountTabBarImageName = (normal: "person", selected: "person.fill")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        // Style
        view.tintAdjustmentMode = .normal
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = appearance
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
        let timelineVC = TimelineViewController()
        let accountVC = AccountViewController()
        timelineVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Constant.timelineTabBarImageName.normal), selectedImage: UIImage(systemName: Constant.timelineTabBarImageName.selected))
        accountVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: Constant.accountTabBarImageName.normal), selectedImage: UIImage(systemName: Constant.accountTabBarImageName.selected))
        viewControllers = [timelineVC, accountVC]
        
        // Action
        postButton.on(.touchUpInside) { [weak self] _ in
            let vc = AddNewPostViewController()
            vc.didTappedSubmit = { feed in
                self?.selectedIndex = 0
                timelineVC.addNewFeed(feed: feed)
            }
            self?.present(vc, animated: true)
        }
    }
}
