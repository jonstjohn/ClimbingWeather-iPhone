//
//  AreaDailyViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaDailyViewControllerV1.h"
#import "MyManager.h"
#import "AreaDailyCell.h"
#import "JSON.h"

@implementation AreaDailyViewControllerV1

- (id) init
{
	// Setup tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	[tbi setTitle: @"Daily"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"icon_calendar.png"];
	[tbi setImage: i];
	
	days = [[NSMutableArray alloc] init];
	[dailyTableView setRowHeight: 65.0];
    
	
	return self;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	[days removeAllObjects];
	[dailyTableView reloadData];
	
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	[[self navigationController] setNavigationBarHidden: NO];
	
	[activityIndicator setHidesWhenStopped: NO];
	[activityIndicator startAnimating];
	
	// Send request for JSON data
	MyManager *sharedManager = [MyManager sharedManager];
	
	responseData = [NSMutableData data];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *tempUnit = [NSString stringWithFormat: @"%@", [[prefs stringForKey: @"tempUnit"] isEqualToString: @"c"] ? @"c" : @"f"];
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/daily/%@?apiKey=iphone-%@&tempUnit=%@",
					 [sharedManager areaId], [[[UIDevice currentDevice] identifierForVendor] UUIDString], tempUnit];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	float inset = 2.0;
	float columnSpacing = 10.0;
	
	//float secondRowY = inset + 20.0;
	//float thirdRowY = secondRowY + 20.0;
	
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
	
	float fontSize = 10.0;
	float rowHeight = fontSize + inset * 2.0;
	
	// Set table header
	UIView *containerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, rowHeight)];
	[containerView setBackgroundColor: [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5]];
	//[containerView setAlpha: 0.75];
	UILabel *dayLabel = [[UILabel alloc] initWithFrame: CGRectMake(dayX, inset, dayWidth, fontSize)];
	[dayLabel setText: @"Forecast"];
	[dayLabel setBackgroundColor:[UIColor clearColor]];
	[dayLabel setFont: [UIFont systemFontOfSize: fontSize]];
    dayLabel.textAlignment = NSTextAlignmentCenter;
	[containerView addSubview: dayLabel];
	
	UILabel *highLabel = [[UILabel alloc] initWithFrame: CGRectMake(highX, inset, highWidth, fontSize)];
	[highLabel setText: @"High/Low"];
	[highLabel setBackgroundColor:[UIColor clearColor]];
	[highLabel setFont: [UIFont systemFontOfSize: fontSize]];
    highLabel.textAlignment = NSTextAlignmentCenter;
	[containerView addSubview: highLabel];
	
	UILabel *precipLabel = [[UILabel alloc] initWithFrame: CGRectMake(precipX, inset, precipWidth, fontSize)];
	[precipLabel setText: @"Precip"];
	[precipLabel setBackgroundColor:[UIColor clearColor]];
	[precipLabel setFont: [UIFont systemFontOfSize: fontSize]];
    precipLabel.textAlignment = NSTextAlignmentCenter;
	[containerView addSubview: precipLabel];
	
	UILabel *windLabel = [[UILabel alloc] initWithFrame: CGRectMake(windX, inset, windWidth, fontSize)];
	[windLabel setText: @"Wind/Hum"];
	[windLabel setBackgroundColor:[UIColor clearColor]];
	[windLabel setFont: [UIFont systemFontOfSize: fontSize]];
    windLabel.textAlignment = NSTextAlignmentCenter;
	[containerView addSubview: windLabel];
	
	[dailyTableView setTableHeaderView: containerView];
	
	
	[[self navigationController] setNavigationBarHidden: NO];
	
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [days count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	AreaDailyCell *cell = (AreaDailyCell *)[tableView dequeueReusableCellWithIdentifier: @"AreaDailyCell"];
	
	if (!cell) {
		cell = [[AreaDailyCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"AreaDailyCell"];
	}
	NSString *high = [[days objectAtIndex: [indexPath row]] objectForKey: @"hi"];
	NSString *low = [[days objectAtIndex: [indexPath row]] objectForKey: @"l"];
	NSString *conditions = [[days objectAtIndex: [indexPath row]] objectForKey: @"c"];
	
	[[cell dayLabel] setText: [[days objectAtIndex: [indexPath row]] objectForKey: @"dy"]]; // @"test"];
	[[cell dateLabel] setText: [[days objectAtIndex: [indexPath row]] objectForKey: @"dd"]];
	[[cell highLabel] setText: [NSString stringWithFormat: @"%@˚", high]];
	[[cell lowLabel] setText: [NSString stringWithFormat: @"%@˚", low]];
	[[cell precipDayLabel] setText: [NSString stringWithFormat: @"%@%%", [[days objectAtIndex: [indexPath row]] objectForKey: @"pd"]]];
	[[cell precipNightLabel] setText: [NSString stringWithFormat: @"%@%%", [[days objectAtIndex: [indexPath row]] objectForKey: @"pn"]]];
	[[cell windLabel] setText: [NSString stringWithFormat: @"%@ mph", [[days objectAtIndex: [indexPath row]] objectForKey: @"ws"]]];
	[[cell humLabel] setText: [NSString stringWithFormat: @"%@%%", [[days objectAtIndex: [indexPath row]] objectForKey: @"h"]]];
	[[cell conditionsLabel] setText: conditions];
	if ([conditions length] == 0) {
		[[cell conditionsLabel] setHidden: YES];
	} else {
		[[cell conditionsLabel] setHidden: NO];
	}
	
	[[cell iconImage] setImage: [UIImage imageNamed: [[days objectAtIndex: [indexPath row]] objectForKey: @"sy"]]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	if ([[[days objectAtIndex: [indexPath row]] objectForKey: @"c"] length] == 0) {
		return 53.0;
	} else {
		return 68.0;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	NSDictionary *data = (NSDictionary *)[responseString JSONValue];
	NSDictionary *daysJson = [data objectForKey: @"results"];
	
	[days removeAllObjects];
	
	NSArray *forecastJson = [daysJson objectForKey: @"f"];
	
	for (int i = 0; i < [forecastJson count]; i++) {
		[days addObject: [forecastJson objectAtIndex: i]];
	}
	
	
	[activityIndicator setHidden: YES];
	[dailyTableView reloadData];
	
}




@end