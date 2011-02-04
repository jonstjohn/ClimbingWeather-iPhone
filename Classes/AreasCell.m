//
//  AreasCell.m
//  climbingweather
//Temp
//  Created by Jonathan StJohn on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreasCell.h"


@implementation AreasCell

@synthesize favoriteImage;
@synthesize areaName;
@synthesize day1Symbol;
@synthesize day1Temp;
@synthesize day1Precip;
@synthesize day2Symbol;
@synthesize day2Temp;
@synthesize day2Precip;
@synthesize day3Symbol;
@synthesize day3Temp;
@synthesize day3Precip;

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
		
        day1Temp = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day1Temp];
		[day1Temp release];
		
        day1Precip = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day1Precip];
		[day1Precip release];
		
        day2Symbol = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day2Symbol];
		[day2Symbol setContentMode: UIViewContentModeScaleAspectFit];
		[day2Symbol release];
		
        day2Temp = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day2Temp];
		[day2Temp release];
		
        day2Precip = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day2Precip];
		[day2Precip release];
		
        day3Symbol = [[UIImageView alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day3Symbol];
		[day3Symbol setContentMode: UIViewContentModeScaleAspectFit];
		[day3Symbol release];
		
        day3Temp = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day3Temp];
		[day3Temp release];
		
        day3Precip = [[UILabel alloc] initWithFrame: CGRectZero];
		[[self contentView] addSubview: day3Precip];
		[day3Precip release];
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
	
	float symbolWidth = 25.0;
	float tempWidth = 65.0;
	
	float day1SymbolX = areaNameX;
	float day1TempX = day1SymbolX + symbolWidth + columnSpacing;
	
	float day2SymbolX = day1TempX + tempWidth + columnSpacing;
	float day2TempX = day2SymbolX + symbolWidth + columnSpacing;
	
	float day3SymbolX = day2TempX + tempWidth + columnSpacing;
	float day3TempX = day3SymbolX + symbolWidth + columnSpacing;
	
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
	
	// Day 1 Temp
	CGRect innerFrameDay1Temp = CGRectMake(day1TempX, secondRowY, tempWidth, small + 1.0);
	//[day1Temp setBackgroundColor: [UIColor purpleColor]];
	[day1Temp setTextAlignment: UITextAlignmentCenter];
	[day1Temp setFont: [UIFont systemFontOfSize: small]];
	[day1Temp setFrame: innerFrameDay1Temp];
	
	// Day 1 Precip
	CGRect innerFrameDay1Precip = CGRectMake(day1TempX, thirdRowY, tempWidth, smaller + 1.0);
	[day1Precip setTextAlignment: UITextAlignmentCenter];
	[day1Precip setFont: [UIFont systemFontOfSize: smaller]];
	[day1Precip setFrame: innerFrameDay1Precip];
	
	// Day 2 Symbol
	CGRect innerFrameDay2Symbol = CGRectMake(day2SymbolX, secondRowY, symbolWidth, symbolWidth);
	//[day2Symbol setBackgroundColor: [UIColor grayColor]];
	[day2Symbol setFrame: innerFrameDay2Symbol];
	
	// Day 2 Temp
	CGRect innerFrameDay2Temp = CGRectMake(day2TempX, secondRowY, tempWidth, small + 1.0);
	//[day2Temp setBackgroundColor: [UIColor purpleColor]];
	[day2Temp setTextAlignment: UITextAlignmentCenter];
	[day2Temp setFont: [UIFont systemFontOfSize: small]];
	[day2Temp setFrame: innerFrameDay2Temp];
	
	// Day 2 Precip
	CGRect innerFrameDay2Precip = CGRectMake(day2TempX, thirdRowY, tempWidth, smaller + 1.0);
	[day2Precip setTextAlignment: UITextAlignmentCenter];
	[day2Precip setFont: [UIFont systemFontOfSize: smaller]];
	[day2Precip setFrame: innerFrameDay2Precip];
	
	// Day 3 Symbol
	CGRect innerFrameDay3Symbol = CGRectMake(day3SymbolX, secondRowY, symbolWidth, symbolWidth);
	//[day3Symbol setBackgroundColor: [UIColor grayColor]];
	[day3Symbol setFrame: innerFrameDay3Symbol];
	
	// Day 3 Temp
	CGRect innerFrameDay3Temp = CGRectMake(day3TempX, secondRowY, tempWidth, small + 1.0);
	//[day3Temp setBackgroundColor: [UIColor purpleColor]];
	[day3Temp setTextAlignment: UITextAlignmentCenter];
	[day3Temp setFont: [UIFont systemFontOfSize: small]];
	[day3Temp setFrame: innerFrameDay3Temp];
	
	// Day 3 Precip
	CGRect innerFrameDay3Precip = CGRectMake(day3TempX, thirdRowY, tempWidth, smaller + 1.0);
	[day3Precip setTextAlignment: UITextAlignmentCenter];
	[day3Precip setFont: [UIFont systemFontOfSize: smaller]];
	[day3Precip setFrame: innerFrameDay3Precip];
	
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
