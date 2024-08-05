//
//  Builder.swift
//  iconfinder
//
//  Created by Vermut xxx on 05.08.2024.
//

import UIKit

final class Builder {
    
    static func makeMainViewController() -> UIViewController {
        let mainView = MainViewController()
        let iconSearchService: IconSearchServiceProtocol = IconSearchService()
        let mainPresenter = MainPresenter(view: mainView, iconSearchService: iconSearchService)
        mainView.presenter = mainPresenter
        return mainView
    }

    static func makeSecondViewController() -> UIViewController {
        let secondView = SecondViewController()
        let dataStoreService: DataStoreServiceProtocol = DataStoreService()
        let secondPresenter = SecondPresenter(view: secondView, dataStoreService: dataStoreService)
        secondView.presenter = secondPresenter
        return secondView
    }

    static func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        tabBarController.view.backgroundColor = .black

        let mainViewController = makeMainViewController()
        let secondViewController = makeSecondViewController()

        let firstNavigationController = UINavigationController(rootViewController: mainViewController)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)

        firstNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        secondNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        tabBarController.viewControllers = [firstNavigationController, secondNavigationController]

        return tabBarController
    }
}
