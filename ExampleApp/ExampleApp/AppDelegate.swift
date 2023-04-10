//
//  AppDelegate.swift
//  ExampleApp
//
//  Created by Alvin He on 23/2/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(
            rootViewController: ViewController(collectionViewLayout: ViewController.collectionViewLayout)
        )
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

