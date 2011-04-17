//
//  AreasTableViewDelegate.m
//  climbingweather
//
//  Created by Jonathan StJohn on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreasTableViewDelegate.h"

#import "AreaDailyViewController.h"
#import "AreaHourlyViewController.h"
#import "AreaMapViewController.h"
#import "AreaDetailController.h"
#import "AreaAveragesController.h"
#import "MyManager.h"
#import "AreasCell.h"
#import "Favorite.h"

@implementation AreasTableViewDelegate

@synthesize areas;
@synthesize areasTableView;
@synthesize responseData;

- (id) init {
	
	areas = [[NSMutableArray alloc] initWithObjects: nil];
	showStates = NO;
	return [super init];
	
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [areas count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	AreasCell *cell = (AreasCell *)[tableView dequeueReusableCellWithIdentifier: @"AreasCell"];
	
	if (!cell) {
		cell = [[[AreasCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"AreasCell"] autorelease];
	}
	
	NSDictionary *area = [areas objectAtIndex: [indexPath row]];
	
	if (showStates) {
		[[cell areaName] setText: [NSString stringWithFormat: @"%@ (%@)", [area objectForKey: @"name"], [area objectForKey: @"state"]]];
	} else {
		[[cell areaName] setText: [area objectForKey: @"name"]];
	}
	
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	
	NSString *imgSrc = @"btn_star_big_off.png";
	if ([sharedFavorite exists: [area objectForKey: @"id"]]) {
		imgSrc = @"btn_star_big_on.png";
	}
	UIImage *btnImage = [UIImage imageNamed: imgSrc];

	[[cell favoriteImage] setImage: btnImage forState: UIControlStateNormal];
	[[cell favoriteImage] setTag: 1];
	[[cell favoriteImage] addTarget:self action:@selector(buttonPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
	
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
	MyManager *sharedManager = [MyManager sharedManager];
	NSString *areaName = [[areas objectAtIndex: [indexPath row]] objectForKey: @"name"];
	sharedManager.areaName = areaName;
	NSString *areaId = [[areas objectAtIndex: [indexPath row]] objectForKey: @"id"];
	sharedManager.areaId = areaId;
	
	// Create or retrieve tab bar controller
	if (tabController == nil) {
	
		// Create tabBarController
		//UITabBarController *tabController = [[UITabBarController alloc] init];
		tabController = [[UITabBarController alloc] init];
		
		// Create view controllers
		UIViewController *vc1 = [[AreaDailyViewController alloc] init];
		UIViewController *vc2 = [[AreaHourlyViewController alloc] init];
		UIViewController *vc3 = [[AreaMapViewController alloc] init];
		//UIViewController *vc4 = [[AreaAveragesController alloc] init];
		//UIViewController *vc5 = [[AreaDetailController alloc] init];
		
		
		// Make an array that contains the two view controllers
		NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, vc3, nil];
		
		// Attach to tab bar controller
		[tabController setViewControllers: viewControllers];
		
		[vc1 release];
		[vc2 release];
		[vc3 release];
		//[vc4 release];
		//[vc5 release];
		
	}
	
	[tabController setSelectedIndex: 0];
	[[tabController navigationItem] setTitle: areaName];
	
	[(UINavigationController *)[[tableView window] rootViewController] pushViewController: tabController animated: YES];
	
}

- (IBAction) buttonPressed: (id) sender
{
	UITableView *myTable = (UITableView *) [[[sender superview] superview] superview];
	
	NSIndexPath *indexPath = [myTable indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
	
	
	NSString *areaId = [[[self areas] objectAtIndex: [indexPath row]] objectForKey: @"id"];
	NSString *name = [[[self areas] objectAtIndex: [indexPath row]] objectForKey: @"name"];
	
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	
	// If this is a favorite, remove
	if ([sharedFavorite exists: areaId]) {
		
		[sharedFavorite remove: areaId];
		UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_off.png"];
		[(UIButton *) sender setImage: btnImage forState: UIControlStateNormal];
		[btnImage release];
		
		// If isn't a favorite, add
	} else {
		
		[sharedFavorite add: areaId withName: name];
		UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_on.png"];
		[(UIButton *) sender setImage: btnImage forState: UIControlStateNormal];
		[btnImage release];
	}
	
	//[myTable release];
	//[indexPath release];
	//[sharedFavorite release];
	
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
	
	[areasTableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
	[responseData release];
	
	NSDictionary *data = [responseString JSONValue];
	NSArray *areasJson = [data objectForKey: @"results"];
	
	[areas removeAllObjects];
	
	for (int i = 0; i < [areasJson count]; i++) {
		[areas addObject: [areasJson objectAtIndex: i]];
	}
	
	// [activityIndicator setHidden: YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AreaDataLoaded" object:nil];
	[areasTableView setHidden: NO];
	
	[areasTableView setRowHeight: 85.0];
	[areasTableView reloadData];
	
	[responseString release];
}

- (void) clearAll {
	[areas removeAllObjects];
	[areasTableView reloadData];
}

- (void) setShowStates:(BOOL)show
{
	showStates = show;
}

- (void) dealloc {
	[areasTableView release];
	[areas release];
	[responseData release];
	[tabController release];
	[super dealloc];
}

@end
