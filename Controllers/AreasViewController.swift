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

@objc class AreasViewController: UITableViewController {
    
    var search: Search?
    var areas = [Area]()
    var locationManager: CLLocationManager?
    let searchController = UISearchController(searchResultsController: nil)
    let favoriteImage = UIImage(named: "Star.png")?.withRenderingMode(.alwaysTemplate)
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let zeroStateView = UIView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let frameHeight = self.tabBarController?.tabBar.frame.height {
            
            let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, frameHeight, 0)
            self.tableView.contentInset = adjustForTabbarInsets
            self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
            
        }
        
        if self.isTermSearch() {
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.searchBar.placeholder = "Enter area name or zip code"
            definesPresentationContext = true
            tableView.tableHeaderView = searchController.searchBar
        }
        
        self.tableView.rowHeight = 85.0
        
        self.tableView.register(UINib(nibName: "AreaCell", bundle: nil), forCellReuseIdentifier: "AreaCell")
        
        self.tableView.backgroundView = self.activityIndicatorView
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        //label.center = CGPoint(x: 160, y: 285)
        //let label = UILabel()
        label.textAlignment = .center
        label.text = "To add a favorite, first find the area and tap on the yellow star at the top right of the screen"
        label.center = self.view.center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 10
        label.textColor = UIColor.darkGray
        self.zeroStateView.addSubview(label)
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(updateSearch), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Areas"
        self.navigationController?.isNavigationBarHidden = false
        
        self.tableView.backgroundView = self.activityIndicatorView
        
        // For location search, always update location on view appear
        if self.isLocationSearch() {
            self.tabBarController?.title = "Nearby Areas"
            self.updateLocation()
        } else if self.isAreasSearch() {
            self.tabBarController?.title = "Favorites"
            self.updateFavorites()
        } else if let search = search, case let Search.Term(term) = search {
            self.tabBarController?.title = "Search"
            self.searchController.searchBar.text = term
        }
        
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Areas", style: .plain, target: nil, action: nil)
        
        super.viewWillAppear(animated)
        
        self.updateSearch()
    }
    
    func startLoading() {
        self.tableView.separatorStyle = .none
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.tableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicatorView.stopAnimating()
            self.tableView.separatorStyle = .singleLine
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func updateSearch() {
        if let search = search {
            
            self.areas = [Area]()
            self.tableView.reloadData()
            
            if isZeroSearch() {
                if isAreasSearch() {
                    self.tableView.backgroundView = self.zeroStateView
                }
                return
            }
            
            self.startLoading()
            
            DispatchQueue.global(qos: .userInteractive).async {
                Areas.fetchDaily(search: search, completion: { (areas) in
                    self.areas = areas.areas
                    
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func isZeroSearch() -> Bool {
        
        guard let search = self.search else {
            return true
        }
        
        if case let Search.Term(term) = search {
            return term.count == 0
        }
        
        if case let Search.Areas(ids) = search {
            return ids.count == 0
        }
        
        return false
    }
    
    func checkLocationAuthorization(manager: CLLocationManager) {
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
    
    func setupLocationManager() {
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
    
    func updateLocation() {
        
        self.setupLocationManager()
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        self.checkLocationAuthorization(manager: locationManager)
        
        locationManager.requestLocation()
    }
    
    func updateFavorites() {
        
        do {
            guard let areas = try Area.favorites() else {
                return
            }
            self.search = .Areas(areas.map({$0.id}))
        } catch {
            return
        }

    }
    
    func isLocationSearch() -> Bool {
        guard let search = self.search else {
            return false
        }
        
        switch search {
        case .Location:
            return true
        default:
            return false
        }
    }
    
    func isAreasSearch() -> Bool {
        guard let search = self.search else {
            return false
        }
        
        switch search {
        case .Areas:
            return true
        default:
            return false
        }
    }
    
    func isTermSearch() -> Bool {
        guard let search = self.search else {
            return false
        }
        
        switch search {
        case .Term:
            return true
        default:
            return false
        }
    }
    
    func setSearchAsState(name: String, code: String, areas: Int) {
        self.search = .State(State(name: name, areas: areas, code: code))
    }
    
    func setSearchAsLocation(latitude: String, longitude: String) {
        self.search = .Location(Location(latitude: latitude, longitude: longitude))
    }
    
    func setSearchAsFavorites() {
        self.search = .Areas([])
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
