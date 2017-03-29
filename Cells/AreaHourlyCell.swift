//
//  AreaHourlyCell.swift
//  climbingweather
//
//  Created by Jon St. John on 3/13/17.
//
//

import UIKit

class AreaHourlyCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var symbol: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var sky: UILabel!
    @IBOutlet weak var precip: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var conditions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(_ forecast: ForecastHour) {
        
        self.time.text = forecast.time
        self.symbol.image = forecast.symbol?.image
        self.temp.text = forecast.temperatureFormatted
        self.sky.text = forecast.skyFormatted + " cloudy"
        self.precip.text = forecast.precipitationFormatted
        self.wind.text = forecast.windSustainedFormatted
        self.humidity.text = forecast.humidityFormatted
        self.conditions.text = forecast.conditionsFormatted
        
    }
    
}
