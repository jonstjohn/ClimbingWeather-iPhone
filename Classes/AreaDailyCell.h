//
//  AreaDailyCell.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaDailyCell : UITableViewCell {
	UILabel *dayLabel;
	UILabel *dateLabel;
	UILabel *highLabel;
	UILabel *lowLabel;
	UILabel *precipDayLabel;
	UILabel *precipNightLabel;
	UILabel *windLabel;
	UILabel *humLabel;
	UILabel *conditionsLabel;
	UIImageView *iconImage;
}

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;

@property (nonatomic, strong) UILabel *precipDayLabel;
@property (nonatomic, strong) UILabel *precipNightLabel;
@property (nonatomic, strong) UILabel *windLabel;
@property (nonatomic, strong) UILabel *humLabel;

@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) UIImageView *iconImage;


@end
