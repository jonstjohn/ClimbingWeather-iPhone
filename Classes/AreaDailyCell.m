//
//  AreaDailyCell.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaDailyCell.h"


@implementation AreaDailyCell

@synthesize dayLabel;
@synthesize dateLabel;
@synthesize highLabel;
@synthesize lowLabel;
@synthesize precipDayLabel;
@synthesize precipNightLabel;
@synthesize windLabel;
@synthesize humLabel;
@synthesize conditionsLabel;
@synthesize iconImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dayLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: dayLabel];
		[dayLabel release];
		
        dateLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		//[[dateLabel adjustsFontSizeToFitWidth: : 12.0];
		
		[[self contentView] addSubview: dateLabel];
		[dateLabel release];
		
        highLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: highLabel];
		[highLabel release];
		
        lowLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: lowLabel];
		[lowLabel release];
		
        precipDayLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: precipDayLabel];
		[precipDayLabel release];
		
        precipNightLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: precipNightLabel];
		[precipNightLabel release];
		
        windLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: windLabel];
		[windLabel release];
		
        humLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: humLabel];
		[humLabel release];
		
        conditionsLabel = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: conditionsLabel];
		[conditionsLabel release];
		
        iconImage = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: iconImage];
		[iconImage setContentMode: UIViewContentModeScaleAspectFit];
		[iconImage release];
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
	float columnSpacing = 10.0;
	
	float secondRowY = inset + 20.0;
	float thirdRowY = secondRowY + 20.0;
	
	float dayX = inset;
	float dayWidth = 50.0;
	
	float iconX = dayX + dayWidth + columnSpacing;
	float iconWidth = 40.0;
	
	float highX = iconX + iconWidth + columnSpacing;
	float highWidth = 50.0;
	
	float precipX = highX + highWidth + columnSpacing;
	float precipWidth = 50.0;
	
	float windX = precipX + precipWidth + columnSpacing;
	float windWidth = 60.0;
	
	float big = 16.0;
	float small = 12.0;
	
	// Day
	CGRect innerFrame1 = CGRectMake(dayX, inset, dayWidth, big + 1.0);
	[dayLabel setFont: [UIFont systemFontOfSize: big]];
	[dayLabel setTextAlignment: UITextAlignmentCenter];
	[dayLabel setFrame: innerFrame1];
	
	// Date
	CGRect innerFrame2 = CGRectMake(dayX, secondRowY, dayWidth, small + 1.0);
	[dateLabel setTextAlignment: UITextAlignmentCenter];
	[dateLabel setFont: [UIFont systemFontOfSize: small]];
	[dateLabel setFrame: innerFrame2];
	
	// Icon
	CGRect innerFrameIcon = CGRectMake(iconX, inset, iconWidth, big + small + 2.0);
	[iconImage setFrame: innerFrameIcon];
	
	// High
	CGRect innerFrame3 = CGRectMake(highX, inset, highWidth, big + 1.0);
	[highLabel setFont: [UIFont systemFontOfSize: big]];
	[highLabel setTextAlignment: UITextAlignmentCenter];
	[highLabel setFrame: innerFrame3];
	
	// Low
	CGRect innerFrameLow = CGRectMake(highX, secondRowY, highWidth, small + 1.0);
	[lowLabel setFont: [UIFont systemFontOfSize: small]];
	[lowLabel setTextAlignment: UITextAlignmentCenter];
	[lowLabel setFrame: innerFrameLow];
	
	// Precip Day
	CGRect innerFramePrecipDay = CGRectMake(precipX, inset, precipWidth, big + 1.0);
	[precipDayLabel setFont: [UIFont systemFontOfSize: big]];
	[precipDayLabel setTextAlignment: UITextAlignmentCenter];
	[precipDayLabel setFrame: innerFramePrecipDay];
	
	// Precip Night
	CGRect innerFramePrecipNight = CGRectMake(precipX, secondRowY, precipWidth, small + 1.0);
	[precipNightLabel setFont: [UIFont systemFontOfSize: small]];
	[precipNightLabel setTextAlignment: UITextAlignmentCenter];
	[precipNightLabel setFrame: innerFramePrecipNight];
	
	// Wind
	CGRect innerFrameWind = CGRectMake(windX, inset, windWidth, big + 1.0);
	[windLabel setFont: [UIFont systemFontOfSize: big]];
	[windLabel setTextAlignment: UITextAlignmentCenter];
	[windLabel setFrame: innerFrameWind];
	
	// Humidity
	CGRect innerFrameHum = CGRectMake(windX, secondRowY, windWidth, small + 1.0);
	[humLabel setFont: [UIFont systemFontOfSize: small]];
	[humLabel setTextAlignment: UITextAlignmentCenter];
	[humLabel setFrame: innerFrameHum];
	
	// Conditions
	CGRect innerFrameConditions = CGRectMake(dayX + 5.0, thirdRowY, w, small + 1.0);
	[conditionsLabel setFont: [UIFont systemFontOfSize: small]];
	[conditionsLabel setTextAlignment: UITextAlignmentLeft];
	[conditionsLabel setFrame: innerFrameConditions];
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
