//
//  AreaHourlyViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 3/1/17.
//
//

import Foundation
import UIKit

class AreaHourlyViewController: UITableViewController {
    
    var areaId: Int?
    var area: Area?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let frameHeight = self.tabBarController?.tabBar.frame.height {
            
            let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, frameHeight, 0)
            self.tableView.contentInset = adjustForTabbarInsets
            self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
            
        }
        
        self.tableView.register(UINib(nibName: "AreaHourlyCell", bundle: nil), forCellReuseIdentifier: "AreaHourlyCell")
        
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
            Area.fetchHourly(id: areaId, completion: { (area) in
                self.area = area
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.area?.hourlyByDay?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.area?.hourlyByDay?[section][0].day ?? ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 16))
        view.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.7)
        let label = UILabel(frame: CGRect(x: 10, y: 6, width: self.tableView.frame.width, height: 16))
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.white
        label.text = self.area?.hourlyByDay?[section][0].day
        view.addSubview(label)
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.area?.hourlyByDay?[section].count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaHourlyCell") as! AreaHourlyCell
        
        guard let hour = self.area?.hourlyByDay?[indexPath.section][indexPath.row] else {
            return cell
        }
        
        cell.populate(hour)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let short = CGFloat(53.0)
        let tall = CGFloat(68.0)
        
        guard let hour = self.area?.hourlyByDay?[indexPath.section][indexPath.row] else {
            return short
        }
        
        guard let length = hour.conditionsFormatted?.characters.count else {
            return short
        }
        
        return length == 0 ? short : tall
    }

    
    
}
