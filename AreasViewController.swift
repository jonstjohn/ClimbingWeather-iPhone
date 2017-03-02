//
//  AreasViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/13/17.
//
//

import Foundation
import UIKit

@objc class AreasViewController: UITableViewController {
    
    var search: Search?
    var areas = [Area]()
    var locationManager: CLLocationManager?
    let searchController = UISearchController(searchResultsController: nil)
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Areas"
        self.navigationController?.isNavigationBarHidden = false
        
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
        
        super.viewWillAppear(animated)
        
        self.updateSearch()
    }
    
    func updateSearch() {
        if let search = search {
            
            // Clear zero length search
            if case let Search.Term(term) = search {
                if term.characters.count == 0 {
                    self.areas = [Area]()
                    self.tableView.reloadData()
                    return
                }
            }
            
            Areas.fetchDaily(search: search, completion: { (areas) in
                self.areas = areas.areas
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
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
        
        guard let areas = Area.favorites() else {
            return
        }
        
        self.search = .Areas(areas.map({$0.id}))

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
        return areas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  AreasCell(style: .subtitle, reuseIdentifier: "AreasCell")
        
        let area = self.areas[indexPath.row]
        
        cell.areaName.text = String(format: "%@ (%@)", area.name, area.state)
        
        let isFavorite = area.isFavorite()
        let favoriteImage = isFavorite ? UIImage(named: "btn_star_big_on") : UIImage(named: "btn_star_big_off")
        cell.favoriteImage.setImage(favoriteImage, for: .normal)
        cell.favoriteImage.tag = 1
        cell.favoriteImage.addTarget(self, action: #selector(favoritePressed(_:)), for: .touchUpInside)
        
        if let daily = area.daily, daily.count >= 3 {
            
            let day1 = daily[0]
            let imageStrDay1 = day1.symbol?.rawValue ?? "" // TODO
            cell.day1Symbol.image = UIImage(named: imageStrDay1)
            cell.day1Temp.text = String(format: "%d / %d", day1.high ?? "-", day1.low ?? "-")
            cell.day1Precip.text = String(format: "%d%% / %d%%", day1.precipitationChanceDay ?? "-", day1.precipitationChanceNight ?? "-")
            
            let day2 = daily[0]
            let imageStrDay2 = day2.symbol?.rawValue ?? "" // TODO
            cell.day2Symbol.image = UIImage(named: imageStrDay2)
            cell.day2Temp.text = String(format: "%d / %d", day2.high ?? "-", day2.low ?? "-")
            cell.day2Precip.text = String(format: "%d%% / %d%%", day2.precipitationChanceDay ?? "-", day2.precipitationChanceNight ?? "-")

            let day3 = daily[0]
            let imageStrDay3 = day3.symbol?.rawValue ?? "" // TODO
            cell.day3Symbol.image = UIImage(named: imageStrDay3)
            cell.day3Temp.text = String(format: "%d / %d", day3.high ?? "-", day3.low ?? "-")
            cell.day3Precip.text = String(format: "%d%% / %d%%", day3.precipitationChanceDay ?? "-", day3.precipitationChanceNight ?? "-")

        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let area = self.areas[indexPath.row]
        
        let sharedManager = MyManager.shared()
        sharedManager?.areaName = area.name
        sharedManager?.areaId = String(area.id)
        
        let dailyController = AreaDailyViewController()
        let tbi = UITabBarItem()
        tbi.title = "Daily"
        tbi.image = UIImage(named: "icon_calendar.png")
        dailyController.tabBarItem = tbi
        dailyController.areaId = area.id
        
        let tabController = UITabBarController()
        tabController.viewControllers = [
            dailyController,
            AreaHourlyViewControllerV1(),
            AreaMapViewController()
        ]
        
        tabController.selectedIndex = 0
        tabController.navigationItem.title = area.name
        
        self.navigationController?.pushViewController(tabController, animated: true)
        
    }
 
    func favoritePressed(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        
        if let indexPath = self.tableView.indexPathForRow(at: buttonPosition) {
            let area = self.areas[indexPath.row]
            if area.isFavorite() {
                do {
                    try area.removeFavorite()
                    sender.setImage(UIImage(named: "btn_star_big_off"), for: .normal)
                } catch _ {
                    
                }
            } else {
                do {
                    try area.addFavorite()
                    sender.setImage(UIImage(named: "btn_star_big_on"), for: .normal)
                } catch _ {
                    
                }
            }
        }

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
    
    func updateTerm() {
        self.search = .Term(self.searchController.searchBar.text ?? "")
        self.updateSearch()
    }
    

}
