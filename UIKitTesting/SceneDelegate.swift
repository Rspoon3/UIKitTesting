//
//  SceneDelegate.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 3/1/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let tabBarController = UITabBarController()
        if #available(iOS 18.0, *), UIDevice.current.userInterfaceIdiom == .pad {
            // Update the current size class to display original design.
            tabBarController.traitOverrides.horizontalSizeClass = .compact
        }
        
        tabBarController.viewControllers = [
            createTab(title: "Home", systemImage: "house", rootViewController: SearchableViewController(title: "Home")),
            createTab(title: "Favorites", systemImage: "star", rootViewController: SearchableViewController(title: "Favorites")),
            createTab(title: "Settings", systemImage: "gear", rootViewController: SearchableViewController(title: "Settings"))
        ]

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    private func createTab(title: String, systemImage: String, rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: systemImage), tag: 0)
        return navController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

