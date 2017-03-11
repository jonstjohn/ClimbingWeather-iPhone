//
//  AreaCell.swift
//  climbingweather
//
//  Created by Jon St. John on 3/9/17.
//
//

import UIKit

class AreaCell: UITableViewCell {


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var day1Symbol: UIImageView!
    @IBOutlet weak var day1High: UILabel!
    @IBOutlet weak var day1Low: UILabel!
    @IBOutlet weak var day1PrecipDay: UILabel!
    @IBOutlet weak var day1PrecipNight: UILabel!
    @IBOutlet weak var day2Symbol: UIImageView!
    @IBOutlet weak var day2High: UILabel!
    @IBOutlet weak var day2Low: UILabel!
    @IBOutlet weak var day2PrecipDay: UILabel!
    @IBOutlet weak var day2PrecipNight: UILabel!
    @IBOutlet weak var day3Symbol: UIImageView!
    @IBOutlet weak var day3High: UILabel!
    @IBOutlet weak var day3Low: UILabel!
    @IBOutlet weak var day3PrecipDay: UILabel!
    @IBOutlet weak var day3PrecipNight: UILabel!
    
    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(_ area: Area) {
        self.name.text = area.name
        self.state.text = area.state
        
        if let daily = area.daily, daily.count >= 3 {
            
            let day1 = daily[0]
            let imageStrDay1 = day1.symbol?.rawValue ?? "" // TODO
            self.day1Symbol.image = UIImage(named: imageStrDay1)
            self.day1High.text = day1.highFormatted
            self.day1Low.text = day1.lowFormatted
            self.day1PrecipDay.text = day1.precipitationChanceDayFormatted
            self.day1PrecipNight.text = day1.precipitationChanceNightFormatted
            
            let day2 = daily[1]
            let imageStrDay2 = day2.symbol?.rawValue ?? "" // TODO
            self.day2Symbol.image = UIImage(named: imageStrDay2)
            self.day2High.text = day2.highFormatted
            self.day2Low.text = day2.lowFormatted
            self.day2PrecipDay.text = day2.precipitationChanceDayFormatted
            self.day2PrecipNight.text = day2.precipitationChanceNightFormatted
            
            let day3 = daily[2]
            let imageStrDay3 = day3.symbol?.rawValue ?? "" // TODO
            self.day3Symbol.image = UIImage(named: imageStrDay3)
            self.day3High.text = day3.highFormatted
            self.day3Low.text = day3.lowFormatted
            self.day3PrecipDay.text = day3.precipitationChanceDayFormatted
            self.day3PrecipNight.text = day3.precipitationChanceNightFormatted
            
        }
    }
    
}
