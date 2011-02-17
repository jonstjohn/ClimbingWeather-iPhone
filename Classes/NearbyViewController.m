//
//  NearbyViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyViewController.h"

#import "AreaDailyViewController.h"
#import "AreaHourlyViewController.h"
#import "AreaMapViewController.h"
#import "AreaDetailController.h"
#import "AreaAveragesController.h"
#import "MyManager.h"
#import "AreasCell.h"
#import "Favorite.h"
#import "AreasTableViewDelegate.h"


@implementation NearbyViewController

@synthesize locationManager;

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
	
	areas = [[NSMutableArray alloc] initWithObjects: nil];
	
	// Put image on tab
	[tbi setImage: i];
	
	if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
	
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
	[[self tabBarController] setTitle: @"Nearby Areas"];
	[[self navigationController] setNavigationBarHidden: NO];
	[[self locationManager] startUpdatingLocation];
	[activityIndicator setHidden: NO];
	[activityIndicator startAnimating];
	NSLog(@"setDelegate");
	AreasTableViewDelegate *tableDelegate = [[AreasTableViewDelegate alloc] init];
	[myTable setDelegate: tableDelegate];
	[myTable setDataSource: tableDelegate];
	NSLog(@"setDatasource");
	[myTable setHidden: YES];
	[myTable setSeparatorStyle: UITableViewCellSeparatorStyleNone];
	NSLog(@"done did appear");
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{

	CLLocationCoordinate2D coord = [newLocation coordinate];
	
	[self search: [NSString stringWithFormat: @"ll=%.5f,%.5f", coord.latitude, coord.longitude]];
	
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void) search: (NSString *) text
{
	
	//MyManager *sharedManager = [MyManager sharedManager];
	//NSLog(@"Areas view state code is: %@", [sharedManager stateCode]);
	
	responseData = [[NSMutableData data] retain];
	
	NSString *url = [NSString stringWithFormat: @"http://www.climbingweather.com/api/area/search/%@?days=3", text];
	NSLog(@"URL: %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

/*
- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	NSLog(@"sections");
	return [areas count];
}
 */

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
	
	NSArray *areasJson = [responseString JSONValue];
	
	NSMutableArray *myAreas = [(AreasTableViewDelegate *) [myTable delegate] areas];
	[myAreas removeAllObjects];
	
	for (int i = 0; i < [areasJson count]; i++) {
		[myAreas addObject: [areasJson objectAtIndex: i]];
	}
	
	[activityIndicator setHidden: YES];
	[myTable setHidden: NO];

	[myTable setRowHeight: 85.0];
	[myTable reloadData];
}

/*
- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"cellForRow");
	AreasCell *cell = (AreasCell *)[tableView dequeueReusableCellWithIdentifier: @"AreasCell"];
	
	if (!cell) {
		cell = [[[AreasCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"AreasCell"] autorelease];
	}
	
	NSDictionary *area = [areas objectAtIndex: [indexPath row]];
	
	[[cell areaName] setText: [area objectForKey: @"name"]];
	
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	
	NSString *imgSrc = @"btn_star_big_off.png";
	if ([sharedFavorite exists: [area objectForKey: @"id"]]) {
		imgSrc = @"btn_star_big_on.png";
	}
	UIImage *btnImage = [UIImage imageNamed: imgSrc];
	[[cell favoriteImage] setImage: btnImage forState: UIControlStateNormal];
	[[cell favoriteImage] setTag: 1];
	[[cell favoriteImage] addTarget:self action:@selector(buttonPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
	
	//[[[cell favoriteImage] imageView] setImage: [UIImage imageNamed: @"icon_star.png"]];
	//[[cell favoriteImage] addTarget];
	NSArray *forecast = [area objectForKey: @"f"];
	NSDictionary *day1 = [forecast objectAtIndex: 0];
	NSDictionary *day2 = [forecast objectAtIndex: 1];
	NSDictionary *day3 = [forecast objectAtIndex: 2];
	[[cell day1Symbol] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [day1 objectForKey: @"sy"]]]];
	[[cell day1Temp] setText: [NSString stringWithFormat: @"%@˚ / %@˚", [day1 objectForKey: @"hi"], [day1 objectForKey: @"l"]]];
	[[cell day1Precip] setText: [NSString stringWithFormat: @"%@%% / %@%%", [day1 objectForKey: @"pd"], [day1 objectForKey: @"pn"]]];
	[[cell day2Symbol] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [day2 objectForKey: @"sy"]]]];
	[[cell day2Temp] setText: [NSString stringWithFormat: @"%@˚ / %@˚", [day2 objectForKey: @"hi"], [day2 objectForKey: @"l"]]];
	[[cell day2Precip] setText: [NSString stringWithFormat: @"%@%% / %@%%", [day2 objectForKey: @"pd"], [day2 objectForKey: @"pn"]]];
	[[cell day3Symbol] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [day3 objectForKey: @"sy"]]]];
	[[cell day3Temp] setText: [NSString stringWithFormat: @"%@˚ / %@˚", [day3 objectForKey: @"hi"], [day3 objectForKey: @"l"]]];
	[[cell day3Precip] setText: [NSString stringWithFormat: @"%@%% / %@%%", [day3 objectForKey: @"pd"], [day3 objectForKey: @"pn"]]];
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"Clicked row at index path %@", indexPath);
	
	MyManager *sharedManager = [MyManager sharedManager];
	NSString *areaName = [[areas objectAtIndex: [indexPath row]] objectForKey: @"name"];
	sharedManager.areaName = areaName;
	NSString *areaId = [[areas objectAtIndex: [indexPath row]] objectForKey: @"id"];
	sharedManager.areaId = areaId;
	
	// Create tabBarController
	UITabBarController *tabController = [[UITabBarController alloc] init];
	
	// Create view controllers
	UIViewController *vc1 = [[AreaDailyViewController alloc] init];
	UIViewController *vc2 = [[AreaHourlyViewController alloc] init];
	UIViewController *vc3 = [[AreaMapViewController alloc] init];
	UIViewController *vc4 = [[AreaAveragesController alloc] init];
	UIViewController *vc5 = [[AreaDetailController alloc] init];
	
	
	// Make an array that contains the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, vc3, vc4, vc5, nil];
	
	// Attach to tab bar controller
	[tabController setViewControllers: viewControllers];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
	[vc4 release];
	[vc5 release];
	
	[[tabController navigationItem] setTitle: areaName];
	
	[[self navigationController] pushViewController: tabController animated: YES];
	
}
*/


- (void)dealloc {
	[[self locationManager] dealloc];
    [super dealloc];
}


@end
