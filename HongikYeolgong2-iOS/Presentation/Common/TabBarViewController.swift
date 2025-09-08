//
//  TabBarViewController.swift
//  HongikYeolgong2-iOS
//
//  Created by 권석기 on 8/26/25.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTabItems()
        setTabBarUI()
    }
    
    private func setTabBarUI() {
        guard let items = self.tabBar.items else { return }
        
        // 위치 설정
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
        }
                
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.custom(.pretendardRegular, size: 12)], for: .normal)
        
        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray300
    }
    
    private func addTabItems() {
        let homeVC = UINavigationController(rootViewController: makeHomeViewController())
        let rankingVC = UINavigationController(rootViewController: RankingViewController())
        let recordVC = UINavigationController(rootViewController: RecordViewController())
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        
        self.setViewControllers([homeVC, recordVC, rankingVC, settingVC], animated: false)
        self.modalPresentationStyle = .fullScreen
        self.tabBar.backgroundColor = .gray800
        
        guard let items = self.tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            let tabItem = TabItem(rawValue: index)
            item.image = tabItem?.tabbarImage
            item.selectedImage = tabItem?.selectedImage
            item.title = tabItem?.tabBarTitle
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var tabFrame = tabBar.frame
        let newHeight: CGFloat = 60 + view.safeAreaInsets.bottom
        tabFrame.size.height = newHeight
        tabFrame.origin.y = view.frame.size.height - newHeight
        tabBar.frame = tabFrame
    }
}

extension TabBarViewController {
    private func makeHomeViewController() -> HomeViewController {
        let userRespository = DefaultUserRepository()
        let userUseCase = DefaultUserUseCase(userRepository: userRespository)
        let homeViewModel = HomeViewModel(userUseCase: userUseCase)
        return .init(viewModel: homeViewModel)
    }
}

enum TabItem: Int {
    case home
    case record
    case ranking
    case setting
    
    var tabBarTitle: String {
        switch self {
        case .home:
            "홈"
        case .record:
            "기록"
        case .ranking:
            "랭킹"
        case .setting:
            "설정"
        }
    }
    
    var tabbarImage: UIImage {
        switch self {
        case .home:
            UIImage(resource: .recordOff)
        case .record:
            UIImage(resource: .calendarOff)
        case .ranking:
            UIImage(resource: .graphOff)
        case .setting:
            UIImage(resource: .userOff)
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            UIImage(resource: .recordOn)
        case .record:
            UIImage(resource: .calendarOn)
        case .ranking:
            UIImage(resource: .graphOn)
        case .setting:
            UIImage(resource: .userOn)
        }
    }
}
