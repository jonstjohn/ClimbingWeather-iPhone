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
    var title: String { get }
    func startSearching()
    func initializeController()
}

public class FavoritesAreaSearchProviderImpl: AreaSearchProvider {
    
    public var search: AreaSearch?
    public let title = "Favorites"
    
    private weak var areasController: AreasViewController?
    
    private lazy var zeroStateNoFavorites = ZeroStateNoFavorites()
    
    public init(areasController: AreasViewController) {
        self.areasController = areasController
    }
    
    public func startSearching() {
        self.search = self.favoritesAsSearch()
        
        guard let search = self.search, !search.empty() else {
            self.areasController?.displayZeroState(self.zeroStateNoFavorites)
            return
        }
        
        self.areasController?.fetchAreas()
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
    public let title = "Search"
    private var lastTerm: String?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private weak var areasController: AreasViewController?
    
    public init(areasController: AreasViewController) {
        self.search = .Term("")
        self.areasController = areasController
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
        searchController.delegate = self
        
        self.areasController?.tabBarController?.definesPresentationContext = true
        self.areasController?.tableView.tableHeaderView = searchController.searchBar
    }
    
    private func shouldSearchLocation(_ term: String) -> Bool {
        return term != self.lastTerm
    }

}

extension TermAreaSearchProviderImpl: UISearchControllerDelegate {
    public func didDismissSearchController(_ searchController: UISearchController) {
        print("Dismissed search controller")
    }
    
    public func didPresentSearchController(_ searchController: UISearchController) {
        print("Presented search controller")
    }
}

extension TermAreaSearchProviderImpl: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TermAreaSearchProviderImpl.updateTerm), object: nil)
        
        self.perform(#selector(TermAreaSearchProviderImpl.updateTerm), with: nil, afterDelay: 0.5)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        // You could also change the position, frame etc of the searchBar
    }
    
    @objc func updateTerm() {
        let term = self.searchController.searchBar.text ?? ""
        self.search = .Term(term)
        
        guard self.shouldSearchLocation(term) else {
            return
        }
        
        self.lastTerm = term
        self.areasController?.fetchAreas()
    }
    
    
}

public class StateAreaSearchProviderImpl: AreaSearchProvider {
    
    public var search: AreaSearch?
    public let title = "States"
    
    private weak var areasController: AreasViewController?
    private let state: State
    
    public init(areasController: AreasViewController, state: State) {
        self.areasController = areasController
        self.state = state
        self.search = .State(state)
    }
    
    public func startSearching() {
        self.areasController?.fetchAreas()
    }
    
    public func initializeController() {
        return
    }
    
}

public class NearbyAreaSearchProviderImpl: NSObject, AreaSearchProvider {
    
    public var search: AreaSearch?
    public let title = "Nearby Areas"
    
    private let SEARCH_DISTANCE = 1000.0
    
    private weak var areasController: AreasViewController?
    
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    
    private lazy var zeroStateNoLocationPermissionView = ZeroStateLocationNotEnabled()
    private lazy var zeroStateLocationFailureView = ZeroStateFailedToAcquireLocation()
    
    public init(areasController: AreasViewController) {
        self.areasController = areasController
    }
    
    public func initializeController() {
        self.zeroStateNoLocationPermissionView.delegate = self
        self.locationManager.delegate = self
        return
    }
    
    public func startSearching() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse: // if authorized, start monitoring for changes
            self.areasController?.startLoading()
            locationManager.requestLocation()
        case .denied, .restricted: // if denied or restricted, show no permission screen
            self.areasController?.displayZeroState(self.zeroStateNoLocationPermissionView)
        case .notDetermined: // if not yet prompted, request location
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func shouldSearchLocation(_ location: CLLocation) -> Bool {
        
        guard let lastLocation = self.lastLocation else {
            return true
        }
        
        return location.distance(from: lastLocation) > SEARCH_DISTANCE
    }
    
}

extension NearbyAreaSearchProviderImpl: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if [.authorizedAlways, .authorizedWhenInUse].contains(status) { // if authorized, start monitoring for changes
            self.areasController?.startLoading()
            locationManager.requestLocation()
        } else {
            self.areasController?.displayZeroState(self.zeroStateNoLocationPermissionView)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last, self.shouldSearchLocation(location) else {
            return
        }

        self.lastLocation = location
        let coordinate = location.coordinate
        self.search = AreaSearch.Location(Location(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude)))
        self.areasController?.fetchAreas()

    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with \(error)")
        DispatchQueue.main.async {
            if self.areasController?.areas.count == 0 {
                self.areasController?.displayZeroState(self.zeroStateLocationFailureView)
            }
        }
        
    }
}

extension NearbyAreaSearchProviderImpl: ZeroStateDelegate {
    
    public func buttonTapped() {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url, completionHandler: nil)
    }
}



@objc public class AreasViewController: UITableViewController {
    
    internal var searchProvider: AreaSearchProvider?
    
    // Areas - datasource
    public var areas = [Area]()
    
    // Activity indicator view
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // Zero state no results
    private lazy var zeroStateNoAreasFound = ZeroStateNoAreasFound()
    
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
    
//        self.tabBarController?.navigationItem.setRightBarButton(
//            UIBarButtonItem(
//                barButtonSystemItem: .search, target: self, action: .searchAreas
//            ),
//        animated: false)
        
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Areas", style: .plain, target: nil, action: nil)
        
        self.tabBarController?.title = self.searchProvider?.title ?? "N/A"
        
        self.searchProvider?.startSearching()
        
        super.viewWillAppear(animated)
    }
    
    public func displayZeroState(_ view: ZeroState) {
        self.areas = [Area]()
        self.tableView.reloadData()
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
        
        guard let search = self.searchProvider?.search else {
            return
        }
            
        self.areas = [Area]()
        self.tableView.reloadData()
        
        if search.empty() {
            self.displayZeroState(self.zeroStateNoAreasFound)
            return
        }
        
        self.startLoading()
        
        DispatchQueue.global(qos: .userInteractive).async {
            Areas.fetchDaily(search: search, completion: { [weak self] (areas) in
                
                guard let `self` = self else {
                    return
                }
                
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
        tbi.image = UIImage(named: "icon_calendar")
        dailyController.tabBarItem = tbi
        dailyController.areaId = area.id
        
        let hourlyController = AreaHourlyViewController()
        hourlyController.tabBarItem.title = "Hourly"
        hourlyController.tabBarItem.image = UIImage(named: "icon_time")
        hourlyController.areaId = area.id
        
        let mapController = AreaMapViewController()
        mapController.tabBarItem.title = "Map"
        mapController.tabBarItem.image = UIImage(named: "icon_blog")
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
    
    @objc public func showSearch() {
        print("Show search")
    }
 
}

fileprivate extension Selector {
    
    static let refreshAreas = #selector(AreasViewController.fetchAreas)
    
    static let searchAreas = #selector(AreasViewController.showSearch)
    
}
