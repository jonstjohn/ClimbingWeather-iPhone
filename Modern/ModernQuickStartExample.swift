//
//  QuickStartExample.swift
//  climbingweather
//
//  Created on 2/6/26.
//
//  Copy and paste these examples to quickly test the modern architecture

import UIKit
import SwiftUI

// MARK: - Quick Test 1: Show Modern Forecast (Simplest Integration)

/*
 Add this to any existing view controller to test the modern forecast:
 */

extension UIViewController {
    
    @objc func testModernForecast() {
        // Replace with any real area ID from your database
        let testAreaId = 123
        let testAreaName = "Yosemite Valley"
        
        // Create modern forecast view
        let forecastView = ModernForecastView(
            areaId: testAreaId,
            areaName: testAreaName,
            repository: DependencyContainer.shared.areaRepository
        )
        
        // Wrap in hosting controller
        let hostingController = UIHostingController(rootView: forecastView)
        hostingController.title = testAreaName
        
        // Show it
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: - Quick Test 2: Search Areas

/*
 Test the search functionality:
 */

extension UIViewController {
    
    @objc func testModernSearch() {
        // Create search view
        let searchView = AreaSearchView(
            repository: DependencyContainer.shared.areaRepository
        )
        
        // Wrap and show
        let hostingController = UIHostingController(rootView: searchView)
        hostingController.title = "Search"
        
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: - Quick Test 3: API Call in Existing View Controller

/*
 Add this method to an existing UIViewController to test API calls:
 */

extension UIViewController {
    
    func testAPICall() {
        let repository = DependencyContainer.shared.areaRepository
        
        // Show loading
        let alert = UIAlertController(title: "Loading...", message: "Testing API", preferredStyle: .alert)
        present(alert, animated: true)
        
        Task {
            do {
                // Try searching for areas
                let areas = try await repository.searchAreas(query: "yosemite")
                
                // Dismiss loading
                alert.dismiss(animated: true) {
                    // Show results
                    let resultAlert = UIAlertController(
                        title: "Success!",
                        message: "Found \(areas.count) areas",
                        preferredStyle: .alert
                    )
                    resultAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(resultAlert, animated: true)
                }
                
            } catch {
                // Show error
                alert.dismiss(animated: true) {
                    let errorAlert = UIAlertController(
                        title: "Error",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true)
                }
            }
        }
    }
}

// MARK: - Quick Test 4: Replace One Table Cell Tap

/*
 Example: Modify your existing AreasViewController
 
 Find this method in AreasViewController:
 
 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let area = self.areas[indexPath.row]
     
     // OLD CODE:
     // let tabController = self.areaTabController(area: area)
     // navigationController?.pushViewController(tabController, animated: true)
     
     // NEW CODE - Test modern view for first row only:
     if indexPath.row == 0 {
         testModernForecast(areaId: area.id, areaName: area.name)
     } else {
         // Keep old code for other rows
         let tabController = self.areaTabController(area: area)
         navigationController?.pushViewController(tabController, animated: true)
     }
 }
 
 private func testModernForecast(areaId: Int, areaName: String) {
     let view = ForecastView(
         areaId: areaId,
         areaName: areaName,
         repository: DependencyContainer.shared.areaRepository
     )
     let hosting = UIHostingController(rootView: view)
     navigationController?.pushViewController(hosting, animated: true)
 }
 
 */

// MARK: - Quick Test 5: Add Debug Button

/*
 Add a debug button to your app to test features:
 */

class DebugMenuViewController: UITableViewController {
    
    let tests = [
        ("Test Modern Forecast", #selector(testForecast)),
        ("Test Modern Search", #selector(testSearch)),
        ("Test API Call", #selector(testAPI)),
        ("Test Popular Areas", #selector(testPopular)),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Modern Architecture Tests"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tests[indexPath.row].0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(tests[indexPath.row].1)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func testForecast() {
        testModernForecast()
    }
    
    @objc func testSearch() {
        testModernSearch()
    }
    
    @objc func testAPI() {
        testAPICall()
    }
    
    @objc func testPopular() {
        Task {
            let repo = DependencyContainer.shared.areaRepository
            let popular = try? await repo.getPopularAreas(limit: 10, days: nil)
            print("Popular areas: \(popular?.count ?? 0)")
        }
    }
}

// MARK: - Quick Test 6: Show Debug Menu from Anywhere

/*
 Add this to AppDelegate or SceneDelegate:
 */

extension UIApplication {
    
    func showDebugMenu() {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else {
            return
        }
        
        let debugMenu = DebugMenuViewController()
        let nav = UINavigationController(rootViewController: debugMenu)
        rootVC.present(nav, animated: true)
    }
}

/*
 Then call it from anywhere:
 
 #if DEBUG
 // Add a shake gesture to show debug menu
 override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
     if motion == .motionShake {
         UIApplication.shared.showDebugMenu()
     }
 }
 #endif
 
 */

// MARK: - Quick Test 7: Console Testing

/*
 Add this code in your AppDelegate or any view controller's viewDidLoad:
 */

func quickConsoleTest() {
    print("🚀 quickConsoleTest() called - starting API tests...")
    
    // Temporarily removed #if DEBUG to debug the issue
    Task {
        print("🧪 Testing Modern API...")
        let repo = DependencyContainer.shared.areaRepository
        
        print("📡 Repository created, starting tests...")
        
        // Test 1: Search
        do {
            print("🔍 Test 1: Searching for 'yosemite'...")
            let areas = try await repo.searchAreas(query: "yosemite")
            print("✅ Search: Found \(areas.count) areas")
            if let first = areas.first {
                print("   First: \(first.name)")
            }
        } catch {
            print("❌ Search failed: \(error)")
            if let apiError = error as? APIError {
                print("   Error details: \(apiError.localizedDescription)")
            }
        }
        
        // Test 2: Forecast (use a real area ID)
        do {
            // First, get a real area ID
            let searchResults = try await repo.searchAreas(query: "yosemite")
            if let firstArea = searchResults.first {
                print("🌤️ Test 2: Getting forecast for area \(firstArea.areaId) (\(firstArea.name))...")
                let forecast = try await repo.getForecast(areaId: firstArea.areaId, days: 3, tempUnit: nil)
                print("✅ Forecast: \(forecast.name)")
                print("   Daily: \(forecast.daily?.data.count ?? 0) days")
                print("   Hourly: \(forecast.hourly?.data.count ?? 0) hours")
            } else {
                print("⚠️ Test 2: No areas found to get forecast for")
            }
        } catch {
            print("❌ Forecast failed: \(error)")
            if let apiError = error as? APIError {
                print("   Error details: \(apiError.localizedDescription)")
            }
        }
        
        // Test 3: Popular Areas
        do {
            print("⭐ Test 3: Getting popular areas...")
            let popular = try await repo.getPopularAreas(limit: 5, days: nil)
            print("✅ Popular: \(popular.count) areas")
        } catch {
            print("❌ Popular failed: \(error)")
            if let apiError = error as? APIError {
                print("   Error details: \(apiError.localizedDescription)")
            }
        }
        
        print("🧪 Tests complete!")
    }
}

// MARK: - Quick Test 8: SwiftUI Preview Testing

/*
 Create a new SwiftUI View file in Xcode and paste this:
 
 import SwiftUI
 
 struct TestView: View {
     var body: some View {
         NavigationStack {
             VStack(spacing: 20) {
                 Text("Modern Architecture Tests")
                     .font(.headline)
                 
                 NavigationLink("Test Forecast View") {
                     ForecastView(
                         areaId: 123,
                         areaName: "Test Area",
                         repository: DependencyContainer.shared.areaRepository
                     )
                 }
                 
                 NavigationLink("Test Search View") {
                     AreaSearchView(
                         repository: DependencyContainer.shared.areaRepository
                     )
                 }
             }
         }
     }
 }
 
 #Preview {
     TestView()
 }
 
 Then use Xcode's preview canvas to test the views!
 
 */

// MARK: - Quick Test 9: Feature Flag Toggle

/*
 Add this to your settings or about screen:
 */

class FeatureFlagToggleViewController: UITableViewController {
    
    enum FlagType: Int {
        case modernForecast = 0
        case modernSearch
        case modernAreaList
        
        var title: String {
            switch self {
            case .modernForecast: return "Modern Forecast View"
            case .modernSearch: return "Modern Search View"
            case .modernAreaList: return "Modern Area List"
            }
        }
        
        var isEnabled: Bool {
            get {
                switch self {
                case .modernForecast: return FeatureFlags.useModernForecast
                case .modernSearch: return FeatureFlags.useModernSearch
                case .modernAreaList: return FeatureFlags.useModernAreaList
                }
            }
            set {
                switch self {
                case .modernForecast: FeatureFlags.useModernForecast = newValue
                case .modernSearch: FeatureFlags.useModernSearch = newValue
                case .modernAreaList: FeatureFlags.useModernAreaList = newValue
                }
            }
        }
    }
    
    let flags: [FlagType] = [.modernForecast, .modernSearch, .modernAreaList]
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let flag = flags[indexPath.row]
        cell.textLabel?.text = flag.title
        
        let toggle = UISwitch()
        toggle.isOn = flag.isEnabled
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        cell.accessoryView = toggle
        
        return cell
    }
    
    @objc func toggleChanged(_ sender: UISwitch) {
        let flag = flags[sender.tag]
        switch flag {
        case .modernForecast:
            FeatureFlags.useModernForecast = sender.isOn
        case .modernSearch:
            FeatureFlags.useModernSearch = sender.isOn
        case .modernAreaList:
            FeatureFlags.useModernAreaList = sender.isOn
        }
    }
}

// MARK: - Instructions

/*
 
 🎯 QUICK START INSTRUCTIONS:
 
 1. BUILD & RUN YOUR APP
    - All Modern/ files should be added to your Xcode project
    - Build should succeed (if not, check target membership)
 
 2. TEST FROM CONSOLE
    - Add `quickConsoleTest()` to AppDelegate or first view controller
    - Run app and check console output
    - Should see "✅" for successful tests
 
 3. TEST WITH BUTTON
    - Add a button in any existing view that calls `testModernForecast()`
    - Tap button to see modern forecast view
 
 4. TEST IN REAL FLOW
    - Find where you show area detail (probably AreasViewController)
    - Replace one line to call modern view instead
    - Test that it works
 
 5. ENABLE FEATURE FLAGS
    - Set FeatureFlags.useModernForecast = true
    - All forecast views now use modern implementation
 
 6. EXPAND
    - Once forecast works, enable other flags
    - Test each feature thoroughly
    - Roll out gradually
 
 Common Issues:
 - "Cannot find DependencyContainer" → Check file is in target
 - "Invalid API key" → Update key in DependencyContainer
 - "No data" → Check API base URL is correct
 - "Parsing error" → Verify API is returning v4.0 format
 
 */
