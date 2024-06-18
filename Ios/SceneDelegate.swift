//
//  SceneDelegate.swift
//  Ios
//
//  Created by cw on 2024/6/14.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene을 scene에서 추출하여 windowScene으로 할당합니다.
        guard let windowScene = scene as? UIWindowScene else { return }

        // window를 생성하고 windowScene을 사용합니다.
        window = UIWindow(windowScene: windowScene)
        let mainViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene이 분리될 때 호출됩니다.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene이 활성화될 때 호출됩니다.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Scene이 비활성화될 때 호출됩니다.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene이 전경으로 진입할 때 호출됩니다.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Scene이 백그라운드로 진입할 때 호출됩니다.
    }
}
