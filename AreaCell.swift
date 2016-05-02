//
//  AreaCell.swift
//  climbingweather
//
//  Created by Jon St. John on 8/13/15.
//
//

import Foundation
import UIKit

class AreaCell: UITableViewCell {
  
  @IBOutlet weak var areaLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  @IBOutlet weak var precipLabel: UILabel!
  @IBOutlet weak var symbolImageView  : UIImageView!
  
  @IBOutlet weak var forecastView: AreaForecastCollectionView!
  
  var index: Int!


}