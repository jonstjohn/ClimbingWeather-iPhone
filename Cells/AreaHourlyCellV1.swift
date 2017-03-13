//
//  AreaHourlyCell.swift
//  climbingweather
//
//  Created by Jon St. John on 3/3/17.
//
//

import Foundation
import UIKit

class AreaHourlyCellV1: UITableViewCell {
    
    let dayLabel = UILabel(frame: CGRect.zero)
    let timeLabel = UILabel(frame: CGRect.zero)
    let tempLabel = UILabel(frame: CGRect.zero)
    let precipLabel = UILabel(frame: CGRect.zero)
    let skyLabel = UILabel(frame: CGRect.zero)
    let windLabel = UILabel(frame: CGRect.zero)
    let humLabel = UILabel(frame: CGRect.zero)
    let conditionsLabel = UILabel(frame: CGRect.zero)
    let iconImage = UIImageView(frame: CGRect.zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.dayLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.tempLabel)
        self.contentView.addSubview(self.precipLabel)
        self.contentView.addSubview(self.windLabel)
        self.contentView.addSubview(self.skyLabel)
        self.contentView.addSubview(self.humLabel)
        self.contentView.addSubview(self.conditionsLabel)
        self.iconImage.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.iconImage)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.contentView.bounds.size.width
        
        let inset = 5.0
        let columnSpacing = 5.0
        
        let timeRowHeight = 30.0
        let conditionsRowHeight = 13.0
        let tempRowHeight = 17.0
        let skyRowHeight = 13.0
        
        let big = 16.0
        let small = 12.0
        
        let secondRowY = inset + 20.0
        let thirdRowY = secondRowY + 20.0
        
        let timeX = inset
        let timeY = timeRowHeight / 2.0 - big / 2.0
        let timeWidth = 65.0

        let iconX = timeX + timeWidth + columnSpacing
        let iconWidth = 30.0
        
        let highX = iconX + iconWidth + columnSpacing
        let highWidth = 70.0
        
        let precipX = highX + highWidth + columnSpacing
        let precipWidth = 50.0
        
        let windX = precipX + precipWidth + columnSpacing
        let windWidth = 60.0
        
        // Time
        timeLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        timeLabel.textAlignment = .center;
        timeLabel.frame = CGRect(x: timeX, y: timeY, width: timeWidth, height: timeRowHeight)
        
        // Icon
        iconImage.frame = CGRect(x: iconX, y: inset, width: iconWidth, height: iconWidth)
        
        // Temp
        tempLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        tempLabel.textAlignment = .center
        tempLabel.frame = CGRect(x: highX, y: inset, width: highWidth, height: tempRowHeight)
        
        // Sky
        skyLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        skyLabel.textAlignment = .center
        skyLabel.frame = CGRect(x: highX, y: secondRowY, width: highWidth, height: skyRowHeight)
        
        // Precip
        precipLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        precipLabel.textAlignment = .center
        precipLabel.frame = CGRect(x: precipX, y: timeY, width: precipWidth, height: timeRowHeight)
        
        // Wind
        windLabel.font = UIFont.systemFont(ofSize: CGFloat(big))
        windLabel.textAlignment = .center
        windLabel.frame = CGRect(x: windX, y: inset, width: windWidth, height: tempRowHeight)
        
        // Humidity
        humLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        humLabel.textAlignment = .center
        humLabel.frame = CGRect(x: windX, y: secondRowY, width: windWidth, height: skyRowHeight)
        
        // Conditions
        conditionsLabel.font = UIFont.systemFont(ofSize: CGFloat(small))
        conditionsLabel.textAlignment = .left
        conditionsLabel.frame = CGRect(x: timeX + 5.0, y: thirdRowY, width: Double(w), height: conditionsRowHeight)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
