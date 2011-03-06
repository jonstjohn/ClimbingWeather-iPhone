//
//  AreaHourlyViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaHourlyViewController.h"
#import "AreaHourlyCell.h"
#import "MyManager.h"


@implementation AreaHourlyViewController

- (id) init
{
	// Setup tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	[tbi setTitle: @"Hourly"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"icon_time.png"];
	[tbi setImage: i];
	
	days = [[NSMutableArray alloc] initWithObjects: nil];
	[[self tableView] setRowHeight: 65.0];
	
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


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
	UIView *containerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, rowHeight)] autorelease];
	[containerView setBackgroundColor: [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5]];
	//[containerView setAlpha: 0.75];
	UILabel *dayLabel = [[[UILabel alloc] initWithFrame: CGRectMake(dayX, inset, dayWidth, fontSize)] autorelease];
	[dayLabel setText: @"Forecast"];
	[dayLabel setBackgroundColor:[UIColor clearColor]];
	[dayLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[dayLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: dayLabel];
	
	UILabel *highLabel = [[[UILabel alloc] initWithFrame: CGRectMake(highX, inset, highWidth, fontSize)] autorelease];
	[highLabel setText: @"Temp/Sky"];
	[highLabel setBackgroundColor:[UIColor clearColor]];
	[highLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[highLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: highLabel];
	
	UILabel *precipLabel = [[[UILabel alloc] initWithFrame: CGRectMake(precipX, inset, precipWidth, fontSize)] autorelease];
	[precipLabel setText: @"Precip"];
	[precipLabel setBackgroundColor:[UIColor clearColor]];
	[precipLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[precipLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: precipLabel];
	
	UILabel *windLabel = [[[UILabel alloc] initWithFrame: CGRectMake(windX, inset, windWidth, fontSize)] autorelease];
	[windLabel setText: @"Wind/Hum"];
	[windLabel setBackgroundColor:[UIColor clearColor]];
	[windLabel setFont: [UIFont systemFontOfSize: fontSize]];
	[windLabel setTextAlignment: UITextAlignmentCenter];
	[containerView addSubview: windLabel];
	
	[[self tableView] setTableHeaderView: containerView];
	 
	
	[[self navigationController] setNavigationBarHidden: NO];
}

- (void) viewDidAppear:(BOOL)animated
{
	// Send request for JSON data
	MyManager *sharedManager = [MyManager sharedManager];
	NSLog(@"Hourly view area id is: %@", [sharedManager areaId]);
	
	responseData = [[NSMutableData data] retain];
	
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/hourly/%@?apiKey=android-%@",
					 [sharedManager areaId], [[UIDevice currentDevice] uniqueIdentifier]];
	NSLog(@"URL: %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	AreaHourlyCell *cell = (AreaHourlyCell *)[tableView dequeueReusableCellWithIdentifier: @"AreaHourlyCell"];
	
	//NSLog(@"Table: %@", [indexPath row]);
	if (!cell) {
		cell = [[[AreaHourlyCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"AreaHourlyCell"] autorelease];
	}
	//NSLog(@"Row: %@", [indexPath row]);
	NSArray *hours = [[days objectAtIndex: [indexPath section]] objectForKey: @"f"];
	NSString *temp = [[hours objectAtIndex: [indexPath row]] objectForKey: @"t"];
	NSString *sky = [[hours objectAtIndex: [indexPath row]] objectForKey: @"sk"];
	NSString *conditions = [[hours objectAtIndex: [indexPath row]] objectForKey: @"c"];
	
	[[cell timeLabel] setText: [[hours objectAtIndex: [indexPath row]] objectForKey: @"ti"]];
	[[cell tempLabel] setText: [NSString stringWithFormat: @"%@˚", temp]];
	[[cell skyLabel] setText: [NSString stringWithFormat: @"%@%% cloudy", sky]];
	[[cell precipLabel] setText: [NSString stringWithFormat: @"%@%%", [[hours objectAtIndex: [indexPath row]] objectForKey: @"p"]]];
	[[cell windLabel] setText: [NSString stringWithFormat: @"%@ mph", [[hours objectAtIndex: [indexPath row]] objectForKey: @"ws"]]];
	[[cell humLabel] setText: [NSString stringWithFormat: @"%@%%", [[hours objectAtIndex: [indexPath row]] objectForKey: @"h"]]];
	[[cell conditionsLabel] setText: conditions];
	if ([conditions length] == 0) {
		[[cell conditionsLabel] setHidden: YES];
	} else {
		[[cell conditionsLabel] setHidden: NO];
	}
	
	[[cell iconImage] setImage: [UIImage imageNamed: [[hours objectAtIndex: [indexPath row]] objectForKey: @"sy"]]];
	return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSArray *hours = [[days objectAtIndex: [indexPath section]] objectForKey: @"f"];
	NSLog(@"Conditions: %@", [[hours objectAtIndex: [indexPath row]] objectForKey: @"c"]);
	if ([[[hours objectAtIndex: [indexPath row]] objectForKey: @"c"] length] == 0) {
		return 53.0;
	} else {
		return 68.0;
	}
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [[[days objectAtIndex: section] objectForKey: @"f"] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
	return [days count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [[days objectAtIndex: section] objectForKey: @"n"];

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
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSDictionary *json = [responseString JSONValue];
	
	//NSDictionary *data = [responseString JSONValue];
	//NSDictionary *json = [data objectForKey: @"results"];
	
	
	[days removeAllObjects];
	
	NSArray *forecastJson = [json objectForKey: @"f"];
	
	// Dictionary with keys 'dy' (day) and values array of forecast dictionary
	NSMutableDictionary *daysData = [[[NSMutableDictionary alloc] init] autorelease];
	
	// Temporary place to store day order
	NSMutableArray *daysTemp = [[NSMutableArray alloc] initWithObjects: nil];
	
	
	for (int i = 0; i < [forecastJson count]; i++) {
		
		NSString *dy = [[forecastJson objectAtIndex: i] objectForKey: @"dy"];

		if (![daysData objectForKey: dy]) {
			[daysData setObject: [[NSMutableArray alloc] initWithObjects: nil] forKey: dy];
			NSLog(@"Added");
			[daysTemp addObject: dy];
		}
		[[daysData objectForKey: dy] addObject: [forecastJson objectAtIndex: i]];
		
	}
	
	// Add objects stored in daysData in the order that they are stored in daysTemp
	for (int i = 0; i < [daysTemp count]; i++) {
		
		[days addObject: [
						  [NSDictionary alloc] initWithObjectsAndKeys: 
						  [daysTemp objectAtIndex: i], @"n", 
						  [daysData objectForKey: [daysTemp objectAtIndex: i]], @"f", nil
						  ]];
		
	}
	
	[daysTemp release];
	
	[[self tableView] reloadData];
	
}

/*
 Days =
   [
     {
       'n': 'Today',
       'f': [{}, {}, {}]
*/

- (void)dealloc {
    [super dealloc];
}


@end
