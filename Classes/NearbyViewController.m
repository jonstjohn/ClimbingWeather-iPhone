//
//  NearbyViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyViewController.h"

@implementation NearbyViewController

//@synthesize locationManager;
//@synthesize myTableDelegate;

- (id) init
{
	
	// Call the super-class's designated initialize
	self = [super initWithNibName: @"NearbyViewController" bundle: nil];
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"Nearby Areas"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"73-radar.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	if (self != nil) {
		locationManager = [[CLLocationManager alloc] init];
		[locationManager setDelegate: self];
		[locationManager setDistanceFilter: 5000];
		[locationManager setDesiredAccuracy: kCLLocationAccuracyThreeKilometers];
    }
	
	// Create the table view delegate
	myTableDelegate = [[AreasTableViewDelegate alloc] init];
	
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
}


- (void) viewDidAppear: (BOOL) animated
{
	[super viewDidAppear: animated];
	[[self tabBarController] setTitle: @"Nearby Areas"];
	[[self navigationController] setNavigationBarHidden: NO];
	
	[activityIndicator setHidesWhenStopped: NO];
	[activityIndicator startAnimating];
	
	[locationManager startUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dataLoaded:)
                                                 name:@"AreaDataLoaded" object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[locationManager stopUpdatingLocation];
	[super viewDidDisappear: animated];
}

- (void) refreshResults
{
	
	[activityIndicator setHidden: NO];
	[activityIndicator startAnimating];
	[myTable setHidden: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[myTable setDelegate: myTableDelegate];
	[myTable setDataSource: myTableDelegate];
	[myTableDelegate setAreasTableView: myTable];
	
	[myTable setSeparatorStyle: UITableViewCellSeparatorStyleNone];
/*
	[locationManager startUpdatingLocation];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dataLoaded:)
                                                 name:@"AreaDataLoaded" object:nil];
*/
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

- (void)viewWillAppear:(BOOL)animated  
{  
    NSIndexPath *tableSelection = [myTable indexPathForSelectedRow];  
    [myTable deselectRowAtIndexPath:tableSelection animated:NO];  
}  

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
		[self search: [NSString stringWithFormat: @"%.5f,%.5f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Location update error: %@", [error description]);
}

- (void) search: (NSString *) text
{
	[myTableDelegate setResponseData: [[NSMutableData data] retain]];
	[myTableDelegate setShowStates: YES];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *tempUnit = [NSString stringWithFormat: @"%@", [[prefs stringForKey: @"tempUnit"] isEqualToString: @"c"] ? @"c" : @"f"];
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/list/%@?days=3&apiKey=iphone-%@&maxResults=20&tempUnit=%@",
					 text, [[UIDevice currentDevice] identifierForVendor], tempUnit];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate: myTableDelegate];
	
}

- (void) dataLoaded:(NSNotification *) notification
{	
    [activityIndicator setHidden: YES];
	
}

- (IBAction) clickRefresh: (id) sender
{
	[self refreshResults];
}

- (void)dealloc {
	[locationManager release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[myTableDelegate release];
    [super dealloc];
}


@end
