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

@property (nonatomic, retain) UIButton *favoriteImage;
@property (nonatomic, retain) UILabel *areaName;
@property (nonatomic, retain) UIImageView *day1Symbol;
@property (nonatomic, retain) UILabel *day1Temp;
@property (nonatomic, retain) UILabel *day1Precip;
@property (nonatomic, retain) UIImageView *day2Symbol;
@property (nonatomic, retain) UILabel *day2Temp;
@property (nonatomic, retain) UILabel *day2Precip;
@property (nonatomic, retain) UIImageView *day3Symbol;
@property (nonatomic, retain) UILabel *day3Temp;
@property (nonatomic, retain) UILabel *day3Precip;

@end
