//
//  IntegrationExample.swift
//  climbingweather
//
//  Created on 2/6/26.
//
//  This file shows examples of how to integrate the modern architecture
//  with your existing UIKit code.

import UIKit
import SwiftUI

// MARK: - Feature Flags

/// Feature flags to control which views use the new architecture
struct FeatureFlags {
    /// Use modern forecast view instead of legacy AreaDailyViewController
    static var useModernForecast = false
    
    /// Use modern search view instead of legacy search
    static var useModernSearch = false
    
    /// Use modern area list instead of legacy AreasViewController
    static var useModernAreaList = false
}

// MARK: - Navigation Helpers

extension UIViewController {
    
    /// Show forecast for an area (modern or legacy based on feature flag)
    func showForecast(areaId: Int, areaName: String, animated: Bool = true) {
        if FeatureFlags.useModernForecast {
            showModernForecast(areaId: areaId, areaName: areaName, animated: animated)
        } else {
            showLegacyForecast(areaId: areaId, animated: animated)
        }
    }
    
    /// Show modern forecast view
    private func showModernForecast(areaId: Int, areaName: String, animated: Bool) {
        let forecastView = ForecastView(
            areaId: areaId,
            areaName: areaName,
            repository: DependencyContainer.shared.areaRepository
        )
        
        let hostingController = UIHostingController(rootView: forecastView)
        hostingController.title = areaName
        
        navigationController?.pushViewController(hostingController, animated: animated)
    }
    
    /// Show legacy forecast view (existing code)
    private func showLegacyForecast(areaId: Int, animated: Bool) {
        let dailyVC = AreaDailyViewController()
        dailyVC.areaId = areaId
        navigationController?.pushViewController(dailyVC, animated: animated)
    }
}

// MARK: - Example: Updating AreasViewController to use Modern API

/*
 
 To gradually migrate AreasViewController, you could modify the didSelectRowAt method:
 
 extension AreasViewController {
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let area = self.areas[indexPath.row]
         
         // Use helper method that respects feature flags
         showForecast(areaId: area.id, areaName: area.name)
     }
 }
 
 */

// MARK: - Example: Modern Search in Tab Bar

/// Example showing how to add a modern search tab alongside existing tabs
class ModernSearchTabFactory {
    
    static func makeSearchTab() -> UINavigationController {
        // Create SwiftUI view
        let searchView = AreaSearchView(
            repository: DependencyContainer.shared.areaRepository
        )
        
        // Wrap in UIHostingController
        let hostingController = UIHostingController(rootView: searchView)
        hostingController.title = "Search"
        
        // Wrap in navigation controller
        let navController = UINavigationController(rootViewController: hostingController)
        navController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        return navController
    }
}

// MARK: - Example: Using Modern Repository in Legacy ViewController

/// Example showing how to use the modern repository in an existing UIKit view controller
class ModernizedAreasViewController: UITableViewController {
    
    private let repository = DependencyContainer.shared.areaRepository
    private var areas: [Area] = []
    private var loadTask: Task<Void, Never>?
    
    func searchAreas(query: String) {
        // Cancel any existing search
        loadTask?.cancel()
        
        // Show loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
        loadTask = Task { @MainActor in
            do {
                // Use modern async/await API
                let results = try await repository.searchAreas(query: query)
                
                // Update UI on main thread (already on main actor)
                self.areas = results
                self.tableView.backgroundView = nil
                self.tableView.reloadData()
                
            } catch {
                // Handle error
                self.showError(error)
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        loadTask?.cancel()
    }
}

// MARK: - Example: Converting Legacy Area to Modern Area

/// If you need to work with both legacy and modern Area types
extension Area {
    
    /// Convert modern Area to legacy Area
    func toLegacyArea() -> LegacyArea {
        return LegacyArea(
            id: self.areaId,
            name: self.name,
            state: self.adminArea,
            daily: nil,  // Would need conversion from Forecast to [ForecastDay]
            hourly: nil, // Would need conversion from Forecast to [ForecastHour]
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
}

// MARK: - Example: Dependency Injection for Testing

/// Example showing how to inject dependencies for testing
class TestableViewController: UIViewController {
    
    private let repository: AreaRepositoryProtocol
    
    init(repository: AreaRepositoryProtocol? = nil) {
        // Use provided repository or default to production
        self.repository = repository ?? DependencyContainer.shared.areaRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.repository = DependencyContainer.shared.areaRepository
        super.init(coder: coder)
    }
    
    func loadData() {
        Task {
            do {
                let areas = try await repository.searchAreas(query: "yosemite")
                // Update UI...
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

// MARK: - Example: SceneDelegate Integration

/*
 
 To integrate modern views into your app, update SceneDelegate:
 
 class SceneDelegate: UIResponder, UIWindowSceneDelegate {
     
     var window: UIWindow?
     
     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
         guard let windowScene = (scene as? UIWindowScene) else { return }
         
         window = UIWindow(windowScene: windowScene)
         
         // Create tab bar with mix of old and new
         let tabBarController = UITabBarController()
         
         var viewControllers: [UIViewController] = []
         
         // Keep existing tabs
         viewControllers.append(AreasViewControllerFactory.instance(.favorites))
         viewControllers.append(AreasViewControllerFactory.instance(.nearby))
         
         // Add modern search tab
         if FeatureFlags.useModernSearch {
             viewControllers.append(ModernSearchTabFactory.makeSearchTab())
         } else {
             viewControllers.append(AreasViewControllerFactory.instance(.search))
         }
         
         // Add states tab (existing)
         let statesVC = StatesViewController()
         let statesNav = UINavigationController(rootViewController: statesVC)
         statesNav.tabBarItem = UITabBarItem(title: "States", image: UIImage(named: "Capitol"), selectedImage: nil)
         viewControllers.append(statesNav)
         
         tabBarController.viewControllers = viewControllers
         
         window?.rootViewController = tabBarController
         window?.makeKeyAndVisible()
     }
 }
 
 */

// MARK: - Example: A/B Testing

/// Example showing how to do A/B testing with feature flags
class ABTestingExample {
    
    static func showForecastWithABTest(
        from viewController: UIViewController,
        areaId: Int,
        areaName: String
    ) {
        // Randomly choose modern or legacy (50/50 split)
        let useModern = Bool.random()
        
        if useModern {
            // Track analytics
            Analytics.track(event: "forecast_view_modern", properties: ["area_id": areaId])
            
            let view = ForecastView(
                areaId: areaId,
                areaName: areaName,
                repository: DependencyContainer.shared.areaRepository
            )
            let hosting = UIHostingController(rootView: view)
            viewController.navigationController?.pushViewController(hosting, animated: true)
            
        } else {
            // Track analytics
            Analytics.track(event: "forecast_view_legacy", properties: ["area_id": areaId])
            
            let vc = AreaDailyViewController()
            vc.areaId = areaId
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// Placeholder for analytics
enum Analytics {
    static func track(event: String, properties: [String: Any]) {
        print("📊 Analytics: \(event) - \(properties)")
    }
}

// MARK: - Example: Gradual Migration Checklist

/*
 
 Migration Checklist:
 
 □ Phase 1: Foundation
   ✅ Create Modern/ directory structure
   ✅ Add APIClient, models, repositories
   ✅ Add DependencyContainer
   □ Write unit tests for repositories
 
 □ Phase 2: First Feature (Forecast)
   □ Set FeatureFlags.useModernForecast = true for internal builds
   □ Test modern forecast view thoroughly
   □ Compare with legacy view
   □ Fix any bugs or missing features
   □ Roll out to beta testers
   □ Roll out to 100% of users
 
 □ Phase 3: Search
   □ Set FeatureFlags.useModernSearch = true
   □ Test and iterate
   □ Roll out gradually
 
 □ Phase 4: Area Lists
   □ Set FeatureFlags.useModernAreaList = true
   □ Test and iterate
   □ Roll out gradually
 
 □ Phase 5: Cleanup
   □ Remove all feature flags
   □ Delete legacy code
   □ Update documentation
   □ Celebrate! 🎉
 
 */
