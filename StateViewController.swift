//
//  StateViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 8/12/15.
//
//

import Foundation
import UIKit

class StateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
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
      ["name": "Alaska", "areas": "3", "code": "AK"],
      ["name": "Alabama", "areas": "13", "code": "AL"],
      ["name": "Arkansas", "areas": "9", "code": "AR"],
      ["name": "Arizona", "areas": "43", "code": "AZ"],
      ["name": "California", "areas": "141", "code": "CA"],
      ["name": "Colorado", "areas": "92", "code": "CO"],
      ["name": "Connecticut", "areas": "3", "code": "CT"],
      ["name": "Georgia", "areas": "7", "code": "GA"],
      ["name": "", "areas": "", "code": ""],
      ["name": "", "areas": "", "code": ""],
      ["name": "", "areas": "", "code": ""],
      ["name": "", "areas": "", "code": ""]
    ]
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let CellID: NSString = "Cell"
    var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellID as String) as? UITableViewCell
    if (cell == nil) {
      cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellID as String)
    }
    print(self.data[indexPath.row]["areas"])
    
    let areaCount = self.data[indexPath.row]["areas"]
    let areaStr = String(format: "%@ areas", areaCount as! String)
    cell!.textLabel!.text = self.data[indexPath.row]["name"] as? String
    cell!.detailTextLabel!.text = areaStr;
    return cell!
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("You selected cell #\(indexPath.row)!")
  }
  
  
}