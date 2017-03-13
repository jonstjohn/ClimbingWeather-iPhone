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
        
        let inset = 2.0
        let columnSpacing = 10.0
        
        let dayX = inset
        let dayWidth = 50.0
        
        let iconX = dayX + dayWidth + columnSpacing
        let iconWidth = 40.0
        
        let highX = iconX + iconWidth + columnSpacing
        let highWidth = 50.0
        
        let precipX = highX + highWidth + columnSpacing
        let precipWidth = 50.0
        
        let windX = precipX + precipWidth + columnSpacing
        let windWidth = 60.0
        
        let fontSize = 10.0
        let rowHeight = fontSize + inset * 2.0
        
        // Container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: rowHeight))
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(CGFloat(0.05))
        
        // Day label
        let dayLabel = UILabel(frame: CGRect(x: dayX, y: inset, width: dayWidth, height: fontSize))
        dayLabel.text = "Forecast"
        dayLabel.backgroundColor = UIColor.clear
        dayLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        dayLabel.textAlignment = .center
        containerView.addSubview(dayLabel)
        
        // High label
        let highLabel = UILabel(frame: CGRect(x: highX, y: inset, width: highWidth, height: fontSize))
        highLabel.text = "Temp/Sky"
        highLabel.backgroundColor = UIColor.clear
        highLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        highLabel.textAlignment = .center
        containerView.addSubview(highLabel)
        
        // Preciup label
        let precipLabel = UILabel(frame: CGRect(x: precipX, y: inset, width: precipWidth, height: fontSize))
        precipLabel.text = "Precip"
        precipLabel.backgroundColor = UIColor.clear
        precipLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        precipLabel.textAlignment = .center
        containerView.addSubview(precipLabel)
        
        // Day label
        let windLabel = UILabel(frame: CGRect(x: windX, y: inset, width: windWidth, height: fontSize))
        windLabel.text = "Wind/Hum"
        windLabel.backgroundColor = UIColor.clear
        windLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        windLabel.textAlignment = .center
        containerView.addSubview(windLabel)
        
        self.tableView.tableHeaderView = containerView
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.title = "Areas"
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewWillAppear(animated)
        
        self.update()
        
    }
    
    func update() {
        
        guard let areaId = self.areaId else {
            return
        }
        
        Area.fetchHourly(id: areaId, completion: { (area) in
            self.area = area
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.area?.hourlyByDay?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.area?.hourlyByDay?[section][0].day ?? ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.area?.hourlyByDay?[section].count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  AreaHourlyCellV1(style: .subtitle, reuseIdentifier: "AreaHourlyCellV1")
        
        guard let hour = self.area?.hourlyByDay?[indexPath.section][indexPath.row] else {
            return cell
        }
        
        cell.timeLabel.text = hour.time
        
        if let temperature = hour.temperature {
            cell.tempLabel.text = "\(temperature)˚"
        }
        
        if let sky = hour.sky {
            cell.skyLabel.text = "\(sky)% cloudy"
        }
        
        if let precipitationChance = hour.precipitationChance {
            cell.precipLabel.text = "\(precipitationChance)%"
        }
        
        if let windSustained = hour.wind?.sustained {
            cell.windLabel.text = "\(windSustained) mph"
        }
        
        if let humidity = hour.humidity {
            cell.humLabel.text = "\(humidity)%"
        }
        
        cell.conditionsLabel.text = hour.conditionsFormatted
        cell.conditionsLabel.isHidden = hour.conditionsFormatted?.characters.count == 0
        
        cell.iconImage.image = hour.symbol?.image
        cell.selectionStyle = .none
        
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
