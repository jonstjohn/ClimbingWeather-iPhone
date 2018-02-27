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

public protocol AreaSearchProvider {
    var search: AreaSearch? { get set }
    func tabTitle() -> String
    func startSearching()
    func initializeController()
    //func areasFetched(areas: [Area])
}

public class FavoritesAreaSearchProviderImpl: AreaSearchProvider {
    
    public var search: AreaSearch?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let areasController: AreasViewController
    
    private let zeroStateNoFavorites = ZeroStateNoFavorites()
    
    public init(areasController: AreasViewController) {
        self.areasController = areasController
    }
    
    public func tabTitle() -> String {
        return "Favorites"
    }
    
    public func startSearching() {
        self.search = self.favoritesAsSearch()
        
        guard let search = self.search, !search.empty() else {
            self.areasController.displayZeroState(self.zeroStateNoFavorites)
            return
        }
        
        self.areasController.fetchAreas()
    }
    
    public func initializeController() {
        return
    }
    
    // Favorites specific
    private func favoritesAsSearch() -> AreaSearch? {
        
        do {
            guard let areas = try Area.favorites() else {
                return nil
            }
            return .ByID(areas.map({$0.id}))
        } catch {
            return nil
        }
        
    }
}

public class TermAreaSearchProviderImpl: NSObject, AreaSearchProvider {
    
    public var search: AreaSearch?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let areasController: AreasViewController
    
    public init(areasController: AreasViewController) {
        self.search = .Term("")
        self.areasController = areasController
    }
    
    public func tabTitle() -> String {
        return "Search"
    }
    
    public func startSearching() {
        guard let search = search, case let AreaSearch.Term(term) = search else {
            return
        }
        
        self.searchController.searchBar.text = term
    }
    
    public func initializeController() {
        guard let search = self.search, case .Term(_) = search else {
            return
        }
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Enter area name or zip code"
        self.areasController.definesPresentationContext = true
        self.areasController.tableView.tableHeaderView = searchController.searchBar
    }

}

extension TermAreaSearchProviderImpl: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TermAreaSearchProviderImpl.updateTerm), object: nil)
        
        self.perform(#selector(TermAreaSearchProviderImpl.updateTerm), with: nil, afterDelay: 0.5)
    }
    
    @objc func updateTerm() {
        self.search = .Term(self.searchController.searchBar.text ?? "")
        self.areasController.fetchAreas()
    }
    
    
}

public class StateAreaSearchProviderImpl: AreaSearchProvider {
    
    public var search: AreaSearch?
    
    private let areasController: AreasViewController
    private let state: State
    
    public init(areasController: AreasViewController, state: State) {
        self.areasController = areasController
        self.state = state
        self.search = .State(state)
    }
    
    public func tabTitle() -> String {
        return "States"
    }
    
    public func startSearching() {
        self.areasController.fetchAreas()
    }
    
    public func initializeController() {
        return
    }
    
}

public class NearbyAreaSearchProviderImpl: NSObject, AreaSearchProvider {
    
    public var search: AreaSearch?
    
    private let areasController: AreasViewController
    
    private var locationManager: CLLocationManager?
    
    private let zeroStateNoLocationPermissionView = ZeroStateLocationNotEnabled()
    private let zeroStateLocationFailureView = ZeroStateFailedToAcquireLocation()
    
    public init(areasController: AreasViewController) {
        self.areasController = areasController
    }
    
    public func tabTitle() -> String {
        return "Nearby Areas"
    }
    
    public func startSearching() {
        // Ensure status is not restricted or denied
        if self.hasLocationAccess() {
            self.updateLocation()
        } else {
            self.areasController.displayZeroState(self.zeroStateNoLocationPermissionView)
        }
    }
    
    public func initializeController() {
        self.zeroStateNoLocationPermissionView.delegate = self
        return
    }
    
    // Location specific
    private func hasLocationAccess() -> Bool {
        return ![.restricted, .denied].contains(CLLocationManager.authorizationStatus())
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
    private func setupLocationManager() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
    
    // Location specific
    private func updateLocation() {
        
        self.setupLocationManager()
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        self.areasController.startLoading()
        
        self.checkLocationAuthorization(manager: locationManager)
        
        locationManager.requestLocation()
    }
    
}

extension NearbyAreaSearchProviderImpl: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let coordinate = location.coordinate
            self.search = AreaSearch.Location(Location(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude)))
            self.areasController.fetchAreas()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with \(error)")
        DispatchQueue.main.async {
            if self.areasController.areas.count == 0 {
                self.areasController.displayZeroState(self.zeroStateLocationFailureView)
            }
        }
        
    }
}

extension NearbyAreaSearchProviderImpl: ZeroStateDelegate {
    
    public func buttonTapped() {
        print("Button Tapped")
    }
}



@objc public class AreasViewController: UITableViewController {
    
    internal var searchProvider: AreaSearchProvider?
    
    // Areas - datasource
    public var areas = [Area]()
    
    // Activity indicator view
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // Zero state no results
    let zeroStateNoAreasFound = ZeroStateNoAreasFound()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        self.initializeView()
        
    }
    
    private func configureTableViewForAreas(tableView: UITableView) {
        
        // Configure row
        tableView.rowHeight = 85.0
        tableView.register(UINib(nibName: "AreaCell", bundle: nil), forCellReuseIdentifier: "AreaCell")
        
        // Add refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: .refreshAreas, for: .valueChanged)
    }
    
    private func initializeView() {
        
        self.configureTableViewForAreas(tableView: self.tableView)

        self.searchProvider?.initializeController()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.title = "Areas"
        self.navigationController?.isNavigationBarHidden = false
        
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Areas", style: .plain, target: nil, action: nil)
        
        self.tabBarController?.title = self.searchProvider?.tabTitle() ?? "N/A"
        
        self.searchProvider?.startSearching()
        
        super.viewWillAppear(animated)
    }
    
    public func displayZeroState(_ view: ZeroState) {
        self.tableView.separatorStyle = .none
        self.tableView.backgroundView = view
    }
    
    // Start loading areas
    public func startLoading() {
        self.tableView.separatorStyle = .none
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.tableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
    }
    
    // Stop loading areas
    public func stopLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicatorView.stopAnimating()
            //self.tableView.separatorStyle = .singleLine
            self.refreshControl?.endRefreshing()
        }
    }
    
    // Update search
    @objc public func fetchAreas() {
        if let search = self.searchProvider?.search {
            
            self.areas = [Area]()
            self.tableView.reloadData()
            
            if search.empty() {
                self.displayZeroState(self.zeroStateNoAreasFound)
                return
            }
            
            self.startLoading()
            
            DispatchQueue.global(qos: .userInteractive).async {
                Areas.fetchDaily(search: search, completion: { (areas) in
                    self.areas = areas.areas
                    
                    DispatchQueue.main.async {
                        if areas.areas.count == 0 {
                            self.displayZeroState(self.zeroStateNoAreasFound)
                        }
                        self.stopLoading()
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    

    
    // MARK: - Table view data source
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.separatorStyle = areas.count == 0 ? .none : .singleLine
        return areas.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell") as! AreaCell

        let area = self.areas[indexPath.row]
        cell.populate(area)
        return cell

    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let area = self.areas[indexPath.row]
        let tabController = self.areaTabController(area: area)
        self.navigationController?.pushViewController(tabController, animated: true)
    }
    
    // Build area tab controller
    private func areaTabController(area: Area) -> UITabBarController {
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
        return tabController
    }
 
}

fileprivate extension Selector {
    
    static let refreshAreas = #selector(AreasViewController.fetchAreas)
    
}
