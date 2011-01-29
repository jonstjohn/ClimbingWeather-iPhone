//
//  AreasCell.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreasCell.h"


@implementation AreasCell

@synthesize favoriteImage;
@synthesize areaName;
@synthesize day1Symbol;
@synthesize day1High;
@synthesize day1Precip;
@synthesize day2Symbol;
@synthesize day2High;
@synthesize day2Precip;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		/*
        favoriteImage = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: favoriteImage];
		[favoriteImage setContentMode: UIViewContentModeScaleAspectFit];
		[favoriteImage release];
		 */
		
        areaName = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: areaName];
		[areaName release];
		
        day1Symbol = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day1Symbol];
		[day1Symbol setContentMode: UIViewContentModeScaleAspectFit];
		[day1Symbol release];
		
        day1High = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day1High];
		[day1High release];
		
        day1Precip = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day1Precip];
		[day1Precip release];
		
        day2Symbol = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day2Symbol];
		[day2Symbol setContentMode: UIViewContentModeScaleAspectFit];
		[day2Symbol release];
		
        day2High = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day2High];
		[day2High release];
		
        day2Precip = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day2Precip];
		[day2Precip release];
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = [[self contentView] bounds];
	float h = bounds.size.height;
	float w = bounds.size.width;
	//float valueWidth = 200.0;
	
	float inset = 10.0;
	float columnSpacing = 3.0;
	
	float secondRowY = inset + 25.0;
	float thirdRowY = secondRowY + 18.0;
	
	/*
	float favoriteX = inset;
	float favoriteWidth = 50.0;
	
	float areaNameX = favoriteX + favoriteWidth + columnSpacing;
	float areaNameWidth = w - favoriteWidth - inset * 2.0 - 100.0;
	 
	*/
	float areaNameX = inset;
	float areaNameWidth = w - inset * 2.0;
	
	float symbolWidth = 30.0;
	float tempWidth = 60.0;
	
	float day1SymbolX = areaNameX + columnSpacing;
	float day1HighX = day1SymbolX + symbolWidth + columnSpacing;
	
	float day2SymbolX = day1HighX + tempWidth + columnSpacing;
	float day2HighX = day2SymbolX + symbolWidth + columnSpacing;
	
	//float secondRowHeight = 20.0;
	
	/*
	float highX = iconX + iconWidth + columnSpacing;
	float highWidth = 50.0;
	
	float precipX = highX + highWidth + columnSpacing;
	float precipWidth = 50.0;
	
	float windX = precipX + precipWidth + columnSpacing;
	float windWidth = 60.0;
	*/
	
	float big = 16.0;
	float small = 12.0;
	float smaller = 10.0;
	
	// Favorite
	/*
	CGRect innerFrameIcon = CGRectMake(favoriteX, inset, favoriteWidth, big + small + 2.0);
	[favoriteImage setFrame: innerFrameIcon];
	*/
	
	// Area Name
	CGRect innerFrameAreaName = CGRectMake(areaNameX, inset, areaNameWidth, big + 1.0);
	[areaName setFont: [UIFont systemFontOfSize: big]];
	[areaName setTextAlignment: UITextAlignmentLeft];
	[areaName setFrame: innerFrameAreaName];
	
	// Day 1 Symbol
	CGRect innerFrameDay1Symbol = CGRectMake(day1SymbolX, secondRowY, symbolWidth, symbolWidth);
	//[day1Symbol setBackgroundColor: [UIColor grayColor]];
	[day1Symbol setFrame: innerFrameDay1Symbol];
	
	// Day 1 High
	CGRect innerFrameDay1High = CGRectMake(day1HighX, secondRowY, tempWidth, small + 1.0);
	//[day1High setBackgroundColor: [UIColor purpleColor]];
	[day1High setTextAlignment: UITextAlignmentCenter];
	[day1High setFont: [UIFont systemFontOfSize: small]];
	[day1High setFrame: innerFrameDay1High];
	
	// Day 1 Precip
	CGRect innerFrameDay1Precip = CGRectMake(day1HighX, thirdRowY, tempWidth, smaller + 1.0);
	[day1Precip setTextAlignment: UITextAlignmentCenter];
	[day1Precip setFont: [UIFont systemFontOfSize: smaller]];
	[day1Precip setFrame: innerFrameDay1Precip];
	
	// Day 2 Symbol
	CGRect innerFrameDay2Symbol = CGRectMake(day2SymbolX, secondRowY, symbolWidth, symbolWidth);
	//[day2Symbol setBackgroundColor: [UIColor grayColor]];
	[day2Symbol setFrame: innerFrameDay2Symbol];
	
	// Day 2 High
	CGRect innerFrameDay2High = CGRectMake(day2HighX, secondRowY, tempWidth, small + 1.0);
	//[day2High setBackgroundColor: [UIColor purpleColor]];
	[day2High setTextAlignment: UITextAlignmentCenter];
	[day2High setFont: [UIFont systemFontOfSize: small]];
	[day2High setFrame: innerFrameDay2High];
	
	// Day 2 Precip
	CGRect innerFrameDay2Precip = CGRectMake(day2HighX, thirdRowY, tempWidth, smaller + 1.0);
	[day2Precip setTextAlignment: UITextAlignmentCenter];
	[day2Precip setFont: [UIFont systemFontOfSize: smaller]];
	[day2Precip setFrame: innerFrameDay2Precip];
	
	/*
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
	 */
	
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
