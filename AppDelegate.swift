//
//  AppDelegate.swift
//  climbingweather
//
//  Created by Jon St. John on 2/20/17.
//
//
import Foundation
import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        self.setupWindow()
        
        Fabric.with([Crashlytics.self])
        
        return true
        
    }
    
    func setupWindow() {
        
        let tabController = UITabBarController()
        tabController.delegate = self
        
        let stateController = StatesViewController()
        stateController.setupTab()
                
        tabController.viewControllers = [
            HomeViewController(),
            AreasViewControllerFactory.instance(.nearby),
            //UINavigationController(rootViewController: stateController),
            stateController,
            AreasViewControllerFactory.instance(.favorites),
            AreasViewControllerFactory.instance(.search)
        ]
        
        tabController.navigationItem.title = "US States"
        
        let navController = UINavigationController(rootViewController: tabController)
        navController.isNavigationBarHidden = true
        window?.rootViewController = navController
        
        self.window?.makeKeyAndVisible()
    }
    
}

