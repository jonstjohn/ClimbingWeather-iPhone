//
//  AppDelegate.swift
//  climbingweather
//
//  Created by Jon St. John on 2/20/17.
//
//
import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    let homeTitle = "Home"
    let homeTabImage = UIImage(named: "icon_home.png")
    
    let nearbyTitle = "Nearby Areas"
    let nearbyTabImage = UIImage(named: "73-radar.png")
    
    let stateTitle = "By State"
    let stateTabImage = UIImage(named: "190-bank.png")
    
    let favoritesTitle = "Favorites"
    let favoritesTabImage = UIImage(named: "icon_star.png")
    
    let searchTitle = "Search"
    let searchTabImage = UIImage(named: "icon_magnify_glass.png")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        self.setupDatabase()
        self.setupWindow()
        
        return true
        
    }
    
    func setupDatabase() {
        //let areas = CWDatabase.sharedInstance?.favorites()
        //print(areas)
    }
    
    func setupWindow() {
        
        let tabController = UITabBarController()
        tabController.delegate = self
        
        let vc1 = HomeViewController()
        vc1.tabBarItem = UITabBarItem(title: self.homeTitle, image: self.homeTabImage, selectedImage: self.homeTabImage)
        
        let vc2 = AreasViewController()
        vc2.setSearchAsLocation(latitude: "37.7397", longitude: "-119.5740")
        vc2.tabBarItem = UITabBarItem(title: self.nearbyTitle, image: self.nearbyTabImage, selectedImage: self.nearbyTabImage)
        
        let vc3 = StatesViewController()
        vc3.tabBarItem = UITabBarItem(title: self.stateTitle, image: self.stateTabImage, selectedImage: self.stateTabImage)
        
        let vc4 = AreasViewController()
        vc4.tabBarItem = UITabBarItem(title: self.favoritesTitle, image: self.favoritesTabImage, selectedImage: self.favoritesTabImage)
        vc4.setSearchAsFavorites()
        
        let vc5 = AreasViewController()
        vc5.search = .Term("")
        vc5.tabBarItem = UITabBarItem(title: self.searchTitle, image: self.searchTabImage, selectedImage: self.searchTabImage)
        
        tabController.viewControllers = [vc1, vc2, vc3, vc4, vc5]
        tabController.navigationItem.title = "Find Areas"
        
        let navController = UINavigationController(rootViewController: tabController)
        navController.isNavigationBarHidden = true
        window?.rootViewController = navController
        
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
