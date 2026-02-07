//
//  AppDelegate.swift
//  climbingweather
//
//  Created by Jon St. John on 2/20/17.
//
//
import Foundation
import UIKit
import SwiftUI  // ← Add this for UIHostingController and SwiftUI views


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        self.setupWindow()
        
        return true
        
    }
    
    func setupWindow() {
        

        // MARK: - Testing Modern Architecture
        // Uncomment the line below to test the modern API in the console
        //quickConsoleTest()
        
        // MARK: - Debug: Check Icon Loading
        // Test if we can load weather icons
        testIconLoading()
        
        // MARK: - Example: Show Modern Forecast View
        // Uncomment to test showing a modern SwiftUI forecast view
        
        let view = ModernForecastView(
            areaId: 518,  // Yosemite National Park (from our successful test!)
            areaName: "Yosemite National Park",
            repository: DependencyContainer.shared.areaRepository
        )
        let hosting = UIHostingController(rootView: view)
        
        let navController = UINavigationController(rootViewController: hosting)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return

        /*
        
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
         */
    }
    
    // MARK: - Icon Loading Test
    func testIconLoading() {
        print("🔍 ========== ICON LOADING TEST ==========")
        
        // Test the most common icon names from your API
        let iconNames = [
            "sunny", "sunny_night",
            "cloudy1", "cloudy2", "cloudy3",
            "light_rain", "shower1",
            "snow1", "snow2",
            "tstorm1", "fog", "overcast"
        ]
        
        var foundCount = 0
        var missingCount = 0
        
        for name in iconNames {
            if let image = UIImage(named: name) {
                print("✅ Found: \(name) (\(Int(image.size.width))x\(Int(image.size.height)))")
                foundCount += 1
            } else {
                print("❌ MISSING: \(name)")
                missingCount += 1
            }
        }
        
        print("📊 Summary: \(foundCount) found, \(missingCount) missing")
        print("🔍 ======================================")
    }
    
}

