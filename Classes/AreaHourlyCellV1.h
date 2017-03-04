//
//  AreaHourlyCell.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaHourlyCellV1 : UITableViewCell {
	UILabel *dayLabel;
	UILabel *timeLabel;
	UILabel *tempLabel;
	UILabel *skypLabel;
	UILabel *precipLabel;
	UILabel *windLabel;
	UILabel *humLabel;
	UILabel *conditionsLabel;
	UIImageView *iconImage;
}

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *skyLabel;

@property (nonatomic, strong) UILabel *precipLabel;
@property (nonatomic, strong) UILabel *windLabel;
@property (nonatomic, strong) UILabel *humLabel;

@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) UIImageView *iconImage;

@end
