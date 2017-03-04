//
//  AreasCell.swift
//  climbingweather
//
//  Created by Jon St. John on 3/3/17.
//
//

import Foundation
import UIKit

class AreasCell: UITableViewCell {
    
    let favoriteImage = UIButton(frame: CGRect.zero)
    let areaName = UILabel(frame: CGRect.zero)
    let day1Symbol = UIImageView(frame: CGRect.zero)
    let day1Temp = UILabel(frame: CGRect.zero)
    let day1Precip = UILabel(frame: CGRect.zero)
    let day2Symbol = UIImageView(frame: CGRect.zero)
    let day2Temp = UILabel(frame: CGRect.zero)
    let day2Precip = UILabel(frame: CGRect.zero)
    let day3Symbol = UIImageView(frame: CGRect.zero)
    let day3Temp = UILabel(frame: CGRect.zero)
    let day3Precip = UILabel(frame: CGRect.zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.favoriteImage)
        self.contentView.addSubview(self.areaName)
        
        self.day1Symbol.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.day1Symbol)
        
        self.contentView.addSubview(self.day1Temp)
        self.contentView.addSubview(self.day1Precip)
        
        self.day2Symbol.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.day2Symbol)
        
        self.contentView.addSubview(self.day2Temp)
        self.contentView.addSubview(self.day2Precip)
        
        self.day3Symbol.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.day3Symbol)
        
        self.contentView.addSubview(self.day3Temp)
        self.contentView.addSubview(self.day3Precip)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.contentView.bounds
        let w = Double(bounds.size.width)
        
        let inset = 10.0
        let columnSpacing = 3.0
        let rowSpacing = 5.0
        
        let big = 18.0
        let small = 12.0
        let smaller = 10.0
        
        let firstRowHeight = big + 12.0
        let secondRowY = inset + firstRowHeight + rowSpacing
        let thirdRowY = secondRowY + 18.0
        
        let favoriteWidth = 30.0
        
        let areaNameX = inset + favoriteWidth + columnSpacing + 2.0
        let areaNameWidth = w - columnSpacing * 2.0 - favoriteWidth - inset
        
        let favoriteX = inset
        
        let symbolWidth = 25.0
        let tempWidth = 65.0
        
        let day1SymbolX = inset
        let day1TempX = day1SymbolX + symbolWidth + columnSpacing
        
        let day2SymbolX = day1TempX + tempWidth + columnSpacing
        let day2TempX = day2SymbolX + symbolWidth + columnSpacing
        
        let day3SymbolX = day2TempX + tempWidth + columnSpacing
        let day3TempX = day3SymbolX + symbolWidth + columnSpacing
        
        // Favorite
        favoriteImage.frame = CGRect(x: favoriteX, y: inset, width: favoriteWidth, height: favoriteWidth)
        
        // Area name
        areaName.font = UIFont.systemFont(ofSize: CGFloat(big))
        areaName.textAlignment = .left
        areaName.frame = CGRect(x: areaNameX, y: inset, width: areaNameWidth, height: firstRowHeight)
        
        // Day 1 symbol
        day1Symbol.frame = CGRect(x: day1SymbolX, y: secondRowY, width: symbolWidth, height: symbolWidth)
        
        // Day 1 Temp
        day1Temp.textAlignment = .center
        day1Temp.font = UIFont.systemFont(ofSize: CGFloat(small))
        day1Temp.frame = CGRect(x: day1TempX, y: secondRowY, width: tempWidth, height: small + 1.0)
        
        // Day 1 Precip
        day1Precip.textAlignment = .center
        day1Precip.font = UIFont.systemFont(ofSize: CGFloat(smaller))
        day1Precip.frame = CGRect(x: day1TempX, y: thirdRowY, width: tempWidth, height: smaller + 1.0)
        
        // Day 2 symbol
        day2Symbol.frame = CGRect(x: day2SymbolX, y: secondRowY, width: symbolWidth, height: symbolWidth)
        
        // Day 2 Temp
        day2Temp.textAlignment = .center
        day2Temp.font = UIFont.systemFont(ofSize: CGFloat(small))
        day2Temp.frame = CGRect(x: day2TempX, y: secondRowY, width: tempWidth, height: small + 1.0)
        
        // Day 2 Precip
        day2Precip.textAlignment = .center
        day2Precip.font = UIFont.systemFont(ofSize: CGFloat(smaller))
        day2Precip.frame = CGRect(x: day2TempX, y: thirdRowY, width: tempWidth, height: smaller + 1.0)
        
        // Day 3 symbol
        day3Symbol.frame = CGRect(x: day3SymbolX, y: secondRowY, width: symbolWidth, height: symbolWidth)
        
        // Day 3 Temp
        day3Temp.textAlignment = .center
        day3Temp.font = UIFont.systemFont(ofSize: CGFloat(small))
        day3Temp.frame = CGRect(x: day3TempX, y: secondRowY, width: tempWidth, height: small + 1.0)
        
        // Day 3 Precip
        day3Precip.textAlignment = .center
        day3Precip.font = UIFont.systemFont(ofSize: CGFloat(smaller))
        day3Precip.frame = CGRect(x: day3TempX, y: thirdRowY, width: tempWidth, height: smaller + 1.0)
        
    }

}
