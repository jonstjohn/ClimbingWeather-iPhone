//
//  AreaHourlyCell.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaHourlyCellV1.h"


@implementation AreaHourlyCellV1

@synthesize dayLabel;
@synthesize timeLabel;
@synthesize tempLabel;
@synthesize skyLabel;
@synthesize precipLabel;
@synthesize windLabel;
@synthesize humLabel;
@synthesize conditionsLabel;
@synthesize iconImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
        dayLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: dayLabel];
		
        timeLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: timeLabel];
		
        tempLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: tempLabel];
		
        skyLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: skyLabel];
		
        precipLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: precipLabel];
		
        windLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: windLabel];
		
        humLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: humLabel];
		
        conditionsLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: conditionsLabel];
		
        iconImage = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: iconImage];
		[iconImage setContentMode: UIViewContentModeScaleAspectFit];
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = [[self contentView] bounds];
	//float h = bounds.size.height;
	float w = bounds.size.width;
	//float valueWidth = 200.0;
	
	float inset = 5.0;
	float columnSpacing = 5.0;
	
	float big = 16.0;
	float small = 12.0;
	
	float timeRowHeight = 30.0;
	float conditionsRowHeight = 13.0;
	float tempRowHeight = 17.0;
	float skyRowHeight = 13.0;
	
	float secondRowY = inset + 20.0;
	float thirdRowY = secondRowY + 20.0;
	
	float timeX = inset;
	float timeY = timeRowHeight / 2.0 - big / 2.0;
	float timeWidth = 65.0;
	
	float iconX = timeX + timeWidth + columnSpacing;
	float iconWidth = 30.0;
	
	float highX = iconX + iconWidth + columnSpacing;
	float highWidth = 70.0;
	
	float precipX = highX + highWidth + columnSpacing;
	float precipWidth = 50.0;
	
	float windX = precipX + precipWidth + columnSpacing;
	float windWidth = 60.0;
	

	
	// Day
	/*
	CGRect innerFrameDay = CGRectMake(dayX, inset, dayWidth, big + 1.0);
	[dayLabel setFont: [UIFont systemFontOfSize: big]];
	[dayLabel setTextAlignment: UITextAlignmentCenter];
	[dayLabel setFrame: innerFrameDay];
	 */
	
	// Time
	CGRect innerFrameTime = CGRectMake(timeX, timeY, timeWidth, timeRowHeight);
    timeLabel.textAlignment = NSTextAlignmentCenter;
	[timeLabel setFont: [UIFont systemFontOfSize: small]];
	[timeLabel setFrame: innerFrameTime];
	
	// Icon
	CGRect innerFrameIcon = CGRectMake(iconX, inset, iconWidth, iconWidth);
	[iconImage setFrame: innerFrameIcon];
	
	// Temp
	CGRect innerFrameTemp = CGRectMake(highX, inset, highWidth, tempRowHeight);
	[tempLabel setFont: [UIFont systemFontOfSize: big]];
    tempLabel.textAlignment = NSTextAlignmentCenter;
	[tempLabel setFrame: innerFrameTemp];
	
	// Sky
	CGRect innerFrameSky = CGRectMake(highX, secondRowY, highWidth, skyRowHeight);
	[skyLabel setFont: [UIFont systemFontOfSize: small]];
    skyLabel.textAlignment = NSTextAlignmentCenter;
	[skyLabel setFrame: innerFrameSky];
	
	// Precip Day
	CGRect innerFramePrecip = CGRectMake(precipX, timeY, precipWidth, timeRowHeight);
	[precipLabel setFont: [UIFont systemFontOfSize: big]];
    precipLabel.textAlignment = NSTextAlignmentCenter;
	[precipLabel setFrame: innerFramePrecip];
	
	// Wind
	CGRect innerFrameWind = CGRectMake(windX, inset, windWidth, tempRowHeight);
	[windLabel setFont: [UIFont systemFontOfSize: big]];
    windLabel.textAlignment = NSTextAlignmentCenter;
	[windLabel setFrame: innerFrameWind];
	
	// Humidity
	CGRect innerFrameHum = CGRectMake(windX, secondRowY, windWidth, skyRowHeight);
	[humLabel setFont: [UIFont systemFontOfSize: small]];
    humLabel.textAlignment = NSTextAlignmentCenter;
	[humLabel setFrame: innerFrameHum];
	
	// Conditions
	CGRect innerFrameConditions = CGRectMake(timeX + 5.0, thirdRowY, w, conditionsRowHeight);
	[conditionsLabel setFont: [UIFont systemFontOfSize: small]];
    conditionsLabel.textAlignment = NSTextAlignmentLeft;
	[conditionsLabel setFrame: innerFrameConditions];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}




@end
