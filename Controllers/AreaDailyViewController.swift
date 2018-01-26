//
//  AreaDailyViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/28/17.
//
//

import Foundation
import UIKit

class AreaDailyViewController: UITableViewController {
    
    var areaId: Int?
    var area: Area?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.tableView.register(UINib(nibName: "AreaDailyCell", bundle: nil), forCellReuseIdentifier: "AreaDailyCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
    }
    
    @objc func toggleFavorite(sender: UIBarButtonItem) {
        guard let area = self.area else {
            return
        }
        
        do {
            if try area.isFavorite() {
                try area.removeFavorite()
                sender.image = UIImage(named: "Star.png")
            } else {
                try area.addFavorite()
                sender.image = UIImage(named: "StarYellowFilled.png")
            }
        } catch {
            return
        }
    }
    
    func info(sender: UIBarButtonItem) {
        print("info")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.title = self.area?.name
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewWillAppear(animated)
        
        self.update()
        
    }

    
    func update() {
        
        guard let areaId = self.areaId else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            Area.fetchDaily(id: areaId, completion: { (area) in
                self.area = area
                
                DispatchQueue.main.async {
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    guard let tabBarController = self.tabBarController else {
                        return
                    }
                    
                    let starOn = UIImage(named: "StarYellowFilled.png")
                    let starOff = UIImage(named: "Star.png")
                    do {
                        // Setup favorite item
                        let favoriteImage = try area.isFavorite() ? starOn : starOff
                        let favoriteItem = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(self.toggleFavorite(sender:)))
                        favoriteItem.tintColor = UIColor.init(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
                        
                        // Setup info item
                        //let infoItem = UIBarButtonItem(image: UIImage(named: "Info.png"), style: .plain, target: self, action: #selector(self.info(sender:)))
                        
                        let items = [favoriteItem] // [favoriteItem, infoItem]
                        
                        tabBarController.navigationItem.setRightBarButtonItems(items, animated: true)
                    } catch {
                        // Do nothing
                    }
                    
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.area?.daily?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaDailyCell") as! AreaDailyCell
        
        guard let day = self.area?.daily?[indexPath.row] else {
            return cell
        }
        
        cell.populate(day)
        return cell
        
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let short = CGFloat(60.0)
//        let tall = CGFloat(80.0)
//        
//        guard let daily = self.area?.daily?[indexPath.row] else {
//            return short
//        }
//        
//        guard let length = daily.conditionsFormatted?.characters.count else {
//            return short
//        }
//        
//        return length == 0 ? short : tall
//    }

    
    
}
