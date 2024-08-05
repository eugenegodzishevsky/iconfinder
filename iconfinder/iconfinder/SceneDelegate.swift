//
//  SceneDelegate.swift
//  iconfinder
//
//  Created by Vermut xxx on 31.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = Builder.makeTabBarController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
