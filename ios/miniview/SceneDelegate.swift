//
//  SceneDelegate.swift
//  new-wv
//
//  Created by Stellan Haglund on 2023-01-12.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewController = ViewController()
        
        let window = UIWindow(windowScene: windowScene)
        //window.rootViewController = viewController
        self.window = window
        //window.makeKeyAndVisible()

        window.windowScene = windowScene
        window.makeKeyAndVisible()

        let navViewController = CustomNavigationController(rootViewController: viewController)
        //navViewController.hidesBarsOnSwipe = true
        
        //let webView = WKWebView(frame: .zero)
        //navViewController.view = webView
        window.rootViewController = navViewController
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

