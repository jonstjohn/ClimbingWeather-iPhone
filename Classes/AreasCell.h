//
//  AreasCell.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreasCell : UITableViewCell {
	UIImageView *favoriteImage;
	UILabel *areaName;
	UIImageView *day1Symbol;
	UILabel *day1High;
	UILabel *day1Low;
	UIImageView *day2Symbol;
	UILabel *day2High;
	UILabel *day2Low;
}

@property (nonatomic, retain) UIImageView *favoriteImage;
@property (nonatomic, retain) UILabel *areaName;
@property (nonatomic, retain) UIImageView *day1Symbol;
@property (nonatomic, retain) UILabel *day1High;
@property (nonatomic, retain) UILabel *day1Low;
@property (nonatomic, retain) UIImageView *day2Symbol;
@property (nonatomic, retain) UILabel *day2High;
@property (nonatomic, retain) UILabel *day2Low;

@end
