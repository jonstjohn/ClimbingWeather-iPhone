//
//  NearViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 8/12/15.
//
//

import Foundation
import UIKit

class NearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
  
  @IBOutlet
  var tableView: UITableView!
  
  var data: NSArray
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    self.data = []
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    self.data = []
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.data = self.getData()
  }
  
  func getData() -> NSArray {
    return [
      ["name": "Parley's Canyon", "favorite": "0", "state": "UT", "forecast":[
          ["high":"76", "low": "59", "precip": "61", "hum": "70", "sym": "tstorm1"],
          ["high":"77", "low": "59", "precip": "61", "hum": "70", "sym": "sunny"],
          ["high":"78", "low": "59", "precip": "61", "hum": "70", "sym": "sunny"]
      ]],
      ["name": "Grandeur Peak", "favorite": "0", "state": "UT", "forecast": [
        ["high":"81", "low": "59", "precip": "61", "hum": "70", "sym": "sunny"],
        ["high":"83", "low": "59", "precip": "61", "hum": "70", "sym": "sunny"],
        ["high":"85", "low": "59", "precip": "61", "hum": "70", "sym": "sunny"]
      ]]
    ]
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("areaCell" as String) as! AreaCell
    
    let area = self.data[indexPath.row]["name"] as! String
    let state = self.data[indexPath.row]["state"] as! String
    
    cell.index = indexPath.row
    
    /*
    let high1 = self.data[indexPath.row]["high1"] as! String
    let low1 = self.data[indexPath.row]["low1"] as! String
    let precip1 = self.data[indexPath.row]["precip1"] as! String
    let hum1 = self.data[indexPath.row]["hum1"] as! String
    
    let sym1 = String(format: "%@.png", self.data[indexPath.row]["sym1"] as! String)
    cell.symbolImageView.image = UIImage(named: sym1)
    */
    cell.areaLabel.text = area
    cell.stateLabel.text = state
    
    cell.forecastView.index = indexPath.row
    /*
    cell.tempLabel.text = String(format: "%@ / %@", high1, low1)
    cell.precipLabel.text = String(format: "%@ / %@", precip1, hum1)
 */
    
    return cell
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1;
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("areaForecastCell", forIndexPath: indexPath) as! AreaForecastCell
    
    print(indexPath.item)
    print(indexPath.section)
    
    let cv = collectionView as! AreaForecastCollectionView
    
    print(cv.index)
    
    let area = self.data[cv.index] as! [String: AnyObject]
    let forecast = area["forecast"] as! [[String: String]]
    let forecastItem = forecast[indexPath.item]
    
    let high = forecastItem["high"] as String!
    let low = forecastItem["low"] as String!
    let precip = forecastItem["precip"] as String!
    let hum = forecastItem["hum"] as String!
    
    let sym = String(format: "%@.png", forecastItem["sym"] as String!)
    cell.symbolImageView.image = UIImage(named: sym)
    
    cell.tempLabel.text = String(format: "%@° / %@°", high, low)
    cell.precipLabel.text = String(format: "%@%% / %@%%", precip, hum)
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let cv = collectionView as! AreaForecastCollectionView
    let area = self.data[cv.index] as! [String: AnyObject]
    return area["forecast"]!.count
  }

  
  
}