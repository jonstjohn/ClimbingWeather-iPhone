//
//  AreasViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/13/17.
//
//

import Foundation
import UIKit
import CoreLocation

//public protocol AreasViewControllerProtocol {
//    func startSearch()
////    func areas() -> [Area]
//    func initializeSearch(Search)
//    func search() -> Search
//    func shouldUpdate() -> Bool
//    func isZeroSearch() -> Bool
//}
//
//extension AreasViewControllerProtocol {
//    func areas() -> [Area] {
//        return []
//    }
//}
//
//@objc class AreasLocationViewController: UITableViewController, AreasViewControllerProtocol {
//
//}


//
//
// startSearch
//
//
//
//
//
//


@objc class AreasViewController: UITableViewController {
    
    ///
    /// Common properties
    ///
    
    // Search
    var search: Search?
    
    // Areas - datasource
    var areas = [Area]()
    
    // Activity indicator view
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // Zero state no results
    var zeroStateNoResultView = ZeroState()
    
    ///
    /// Nearby areas specific properties
    ///
    
    // Location manager - only for nearby areas screen
    var locationManager: CLLocationManager?
    
    // Zero state for no location permissions
    let zeroStateNoLocationPermissionView = ZeroState()
    
    // Zero state location failure view
    let zeroStateLocationFailureView = ZeroState()
    
    ///
    /// Search specific properties
    ///
    
    // Search controlller - only for searching
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initializeView()
        
    }
    
    private func initializeView() {
        
        // Ensure that table view is inside of tab bar
        if let frameHeight = self.tabBarController?.tabBar.frame.height {
            
            let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, frameHeight, 0)
            self.tableView.contentInset = adjustForTabbarInsets
            self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
            
        }
        
        // Setup row
        self.tableView.rowHeight = 85.0
        self.tableView.register(UINib(nibName: "AreaCell", bundle: nil), forCellReuseIdentifier: "AreaCell")
        
        // Setup zero states
        self.setupZeroStateViews()
        
        // Add refresh control
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(updateSearch), for: .valueChanged)
        
        // Initialize view - search
        self.initializeViewSearch()
        
    }
    
    // Search specific
    private func initializeViewSearch() {
        
        guard let search = self.search, case .Term(_) = search else {
            return
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Enter area name or zip code"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    private func setupZeroStateViews() {
        
        self.zeroStateNoResultView.mainLabel.text = "No areas found"
        
        self.setupZeroStateViewsLocation()
        self.setupZeroStateViewsFavorites()

    }
    
    private func setupZeroStateViewsLocation() {
        guard let search = self.search, case .Location(_) = search else {
            return
        }
        self.zeroStateLocationFailureView.mainLabel.text = "Failed to acquire location"
        self.zeroStateNoLocationPermissionView.mainLabel.text = "Location access is not currently enabled"
        self.zeroStateNoLocationPermissionView.mainButton.setTitle("Open Settings", for: .normal)
        self.zeroStateNoLocationPermissionView.mainButton.isHidden = false
        self.zeroStateNoLocationPermissionView.delegate = self
    }
    
    private func setupZeroStateViewsFavorites() {
        guard let search = self.search, case .Areas(_) = search else {
            return
        }

        self.zeroStateNoResultView.mainLabel.text = "To add a favorite, first find the area and tap on the yellow star at the top right of the screen"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Areas"
        self.navigationController?.isNavigationBarHidden = false
        
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Areas", style: .plain, target: nil, action: nil)
        
        guard let search = self.search else {
            fatalError("Search must be defined")
        }
        
        switch search {
        case .Areas(_):
            self.startSearchAreas()
        case .Location(_):
            self.startSearchLocation()
        case .Term(_):
            self.startSearchTerm()
        case .State(_):
            self.startSearchState()
        }
        
        super.viewWillAppear(animated)
    }
    
    private func startSearchLocation() {
        
        guard let search = self.search, case .Location(_) = search else {
            return
        }
        
        self.tabBarController?.title = "Nearby Areas"
        // Ensure status is not restricted or denied
        if self.hasLocationAccess() {
            self.updateLocation()
        } else {
            self.tableView.backgroundView = self.zeroStateNoLocationPermissionView
        }
    }
    
    private func startSearchAreas() {
        
        guard let search = self.search, case .Areas(_) = search else {
            return
        }
        
        self.tabBarController?.title = "Favorites"
        self.updateFavorites()
        self.updateSearch()
    }
    
    private func startSearchTerm() {
        guard let search = search, case let Search.Term(term) = search else {
            return
        }
        
        self.tabBarController?.title = "Search"
        self.searchController.searchBar.text = term
        self.updateSearch()
    }
    
    private func startSearchState() {
        guard let search = self.search, case .State(_) = search else {
            return
        }
        self.updateSearch()
    }
    
    // Location specific
    private func hasLocationAccess() -> Bool {
        return ![.restricted, .denied].contains(CLLocationManager.authorizationStatus())
    }
    
    // Start loading areas
    private func startLoading() {
        self.tableView.separatorStyle = .none
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.tableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
    }
    
    // Stop loading areas
    private func stopLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.refreshControl?.endRefreshing()
        }
    }
    
    // Update search
    @objc private func updateSearch() {
        if let search = search {
            
            self.areas = [Area]()
            self.tableView.reloadData()
            
            if search.empty() {
                self.tableView.backgroundView = self.zeroStateNoResultView
                return
            }
            
            self.startLoading()
            
            DispatchQueue.global(qos: .userInteractive).async {
                Areas.fetchDaily(search: search, completion: { (areas) in
                    self.areas = areas.areas
                    
                    DispatchQueue.main.async {
                        if areas.areas.count == 0 {
                            self.tableView.backgroundView = self.zeroStateNoResultView
                        }
                        self.stopLoading()
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    // Location specific
    private func checkLocationAuthorization(manager: CLLocationManager) {
        let authStatus = CLLocationManager.authorizationStatus()
        
        // Ensure status is not restricted or denied
        guard ![.restricted, .denied].contains(authStatus) else {
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            return
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    // Location specific
    func setupLocationManager() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
    
    // Location specific
    func updateLocation() {
        
        self.setupLocationManager()
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        self.startLoading()
        
        self.checkLocationAuthorization(manager: locationManager)
        
        locationManager.requestLocation()
    }
    
    // Favorites specific
    private func updateFavorites() {
        
        do {
            guard let areas = try Area.favorites() else {
                return
            }
            self.search = .Areas(areas.map({$0.id}))
        } catch {
            return
        }

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if areas.count == 0 {
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.separatorStyle = .singleLine
        }
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell") as! AreaCell
        
        let area = self.areas[indexPath.row]
        cell.populate(area)
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let area = self.areas[indexPath.row]
        
        let dailyController = AreaDailyViewController()
        let tbi = UITabBarItem()
        tbi.title = "Daily"
        tbi.image = UIImage(named: "icon_calendar.png")
        dailyController.tabBarItem = tbi
        dailyController.areaId = area.id
        
        let hourlyController = AreaHourlyViewController()
        hourlyController.tabBarItem.title = "Hourly"
        hourlyController.tabBarItem.image = UIImage(named: "icon_time.png")
        hourlyController.areaId = area.id
        
        let mapController = AreaMapViewController()
        mapController.tabBarItem.title = "Map"
        mapController.tabBarItem.image = UIImage(named: "icon_blog.png")
        mapController.areaId = area.id
        
        let tabController = UITabBarController()
        tabController.viewControllers = [
            dailyController,
            hourlyController,
            mapController
        ]
        
        tabController.selectedIndex = 0
        tabController.navigationItem.title = area.name

        self.navigationController?.pushViewController(tabController, animated: true)
        
    }
 
}

extension AreasViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let coordinate = location.coordinate
            self.search = Search.Location(Location(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude)))
            self.updateSearch()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with \(error)")
        DispatchQueue.main.async {
            if self.areas.count == 0 {
                self.tableView.backgroundView = self.zeroStateLocationFailureView
            }
        }
        
    }
}

extension AreasViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(AreasViewController.updateTerm), object: nil)
        
        self.perform(#selector(AreasViewController.updateTerm), with: nil, afterDelay: 0.5)
    }
    
    @objc func updateTerm() {
        self.search = .Term(self.searchController.searchBar.text ?? "")
        self.updateSearch()
    }
    

}

extension AreasViewController: ZeroStateDelegate {
    
    public func buttonTapped() {
        print("Button Tapped")
    }
}
