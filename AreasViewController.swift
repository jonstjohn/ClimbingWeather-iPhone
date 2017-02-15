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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let frameHeight = self.tabBarController?.tabBar.frame.height {
            
            let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, frameHeight, 0)
            self.tableView.contentInset = adjustForTabbarInsets
            self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
            
        }
        
        self.tableView.rowHeight = 85.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Areas"
        self.navigationController?.isNavigationBarHidden = false
        
        if let search = search {
            Areas.fetchDaily(search: search, completion: { (areas) in
                self.areas = areas.areas
            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        super.viewWillAppear(animated)
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
        
        let isFavorite = Favorite.shared().exists(String(area.id))
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
        
        let tabController = UITabBarController()
        tabController.viewControllers = [
            AreaDailyViewController(),
            AreaHourlyViewController(),
            AreaMapViewController()
        ]
        
        tabController.selectedIndex = 0
        tabController.navigationItem.title = area.name
        
        self.navigationController?.pushViewController(tabController, animated: true)
        
    }
 
    func favoritePressed(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: buttonPosition),
            let sharedFavorite = Favorite.shared() {
            let area = self.areas[indexPath.row]
            
            if sharedFavorite.exists(String(area.id)) {
                sharedFavorite.remove(String(area.id))
                sender.setImage(UIImage(named: "btn_star_big_off"), for: .normal)
            } else {
                sharedFavorite.add(String(area.id), withName: area.name)
                sender.setImage(UIImage(named: "btn_star_big_on"), for: .normal)
            }
        }
    }
 
}
