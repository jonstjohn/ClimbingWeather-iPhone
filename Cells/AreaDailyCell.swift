//
//  AreaDailyCell.swift
//  climbingweather
//
//  Created by Jon St. John on 3/3/17.
//
//

import Foundation
import UIKit

class AreaDailyCell: UITableViewCell {
    
    let dayLabel = UILabel(frame: CGRect.zero)
    let dateLabel = UILabel(frame: CGRect.zero)
    let highLabel = UILabel(frame: CGRect.zero)
    let lowLabel = UILabel(frame: CGRect.zero)
    let precipDayLabel = UILabel(frame: CGRect.zero)
    let precipNightLabel = UILabel(frame: CGRect.zero)
    let windLabel = UILabel(frame: CGRect.zero)
    let humLabel = UILabel(frame: CGRect.zero)
    let conditionsLabel = UILabel(frame: CGRect.zero)
    let iconImage = UIImageView(frame: CGRect.zero)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.dayLabel)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.highLabel)
        self.contentView.addSubview(self.lowLabel)
        self.contentView.addSubview(self.precipDayLabel)
        self.contentView.addSubview(self.precipNightLabel)
        self.contentView.addSubview(self.windLabel)
        self.contentView.addSubview(self.humLabel)
        self.contentView.addSubview(self.conditionsLabel)
        self.iconImage.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.iconImage)

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.contentView.bounds.size.width
        
        let inset = 5.0
        let columnSpacing = 10.0
        
        let secondRowY = inset + 20.0
        let thirdRowY = secondRowY + 20.0
        
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
        
        let big = 16.0
        let small = 12.0
        
        // Day
        dayLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        dayLabel.textAlignment = .center;
        dayLabel.frame = CGRect(x: dayX, y: inset, width: dayWidth, height: big + 1.0)

        // Date
        dateLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        dateLabel.textAlignment = .center
        dateLabel.frame = CGRect(x: dayX, y: secondRowY, width: dayWidth, height: small + 1.0)
        
        // Icon
        iconImage.frame = CGRect(x: iconX, y: inset, width: iconWidth, height: big + small + 2.0)
        
        // High
        highLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        highLabel.textAlignment = .center
        highLabel.frame = CGRect(x: highX, y: inset, width: highWidth, height: big + 1.0)
        
        // Low
        lowLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        lowLabel.textAlignment = .center
        lowLabel.frame = CGRect(x: highX, y: secondRowY, width: highWidth, height: small + 1.0)
        
        // Precip day
        precipDayLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        precipDayLabel.textAlignment = .center
        precipDayLabel.frame = CGRect(x: precipX, y: inset, width: precipWidth, height: big + 1.0)
        
        // Precip night
        precipNightLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        precipNightLabel.textAlignment = .center
        precipNightLabel.frame = CGRect(x: precipX, y: secondRowY, width: precipWidth, height: small + 1.0)
        
        // Wind
        windLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        windLabel.textAlignment = .center
        windLabel.frame = CGRect(x: windX, y: inset, width: windWidth, height: big + 1.0)
        
        // Humidity
        humLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        humLabel.textAlignment = .center
        humLabel.frame = CGRect(x: windX, y: secondRowY, width: windWidth, height: small + 1.0)
        
        // Conditions
        conditionsLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        conditionsLabel.textAlignment = .left
        conditionsLabel.frame = CGRect(x: dayX + 5.0, y: thirdRowY, width: Double(w), height: small + 1.0)


    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
