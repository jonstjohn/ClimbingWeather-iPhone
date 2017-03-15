//
//  AreaDailyCell.swift
//  climbingweather
//
//  Created by Jon St. John on 3/13/17.
//
//

import UIKit

class AreaDailyCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var symbol: UIImageView!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var precipDay: UILabel!
    @IBOutlet weak var precipNight: UILabel!
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
    
    func populate(_ forecast: ForecastDay) {
        
        self.day.text = forecast.day
        self.date.text = forecast.dateFormatted
        self.symbol.image = forecast.symbol?.image
        self.high.text = forecast.highFormatted
        self.low.text = forecast.lowFormatted
        self.precipDay.text = forecast.precipitationChanceDayFormatted
        self.precipNight.text = forecast.precipitationChanceNightFormatted
        self.wind.text = forecast.windSustainedFormatted
        self.humidity.text = forecast.humidityFormatted
        self.conditions.text = forecast.conditionsFormatted
        
    }
    
}
