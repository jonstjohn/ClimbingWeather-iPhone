//
//  AreaHourlyCell.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaHourlyCell : UITableViewCell {
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

@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *tempLabel;
@property (nonatomic, retain) UILabel *skyLabel;

@property (nonatomic, retain) UILabel *precipLabel;
@property (nonatomic, retain) UILabel *windLabel;
@property (nonatomic, retain) UILabel *humLabel;

@property (nonatomic, retain) UILabel *conditionsLabel;
@property (nonatomic, retain) UIImageView *iconImage;

@end
