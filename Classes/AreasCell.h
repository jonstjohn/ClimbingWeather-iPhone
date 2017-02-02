//
//  AreasCell.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreasCell : UITableViewCell {
	UIButton *favoriteImage;
	UILabel *areaName;
	UIImageView *day1Symbol;
	UILabel *day1Temp;
	UILabel *day1Precip;
	UIImageView *day2Symbol;
	UILabel *day2Temp;
	UILabel *day2Precip;
	UIImageView *day3Symbol;
	UILabel *day3Temp;
	UILabel *day3Precip;
}

@property (nonatomic, strong) UIButton *favoriteImage;
@property (nonatomic, strong) UILabel *areaName;
@property (nonatomic, strong) UIImageView *day1Symbol;
@property (nonatomic, strong) UILabel *day1Temp;
@property (nonatomic, strong) UILabel *day1Precip;
@property (nonatomic, strong) UIImageView *day2Symbol;
@property (nonatomic, strong) UILabel *day2Temp;
@property (nonatomic, strong) UILabel *day2Precip;
@property (nonatomic, strong) UIImageView *day3Symbol;
@property (nonatomic, strong) UILabel *day3Temp;
@property (nonatomic, strong) UILabel *day3Precip;

@end
