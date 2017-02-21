//
//  StatesViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StatesViewControllerV1.h"
#import "AreasViewControllerV1.h"
#import "MyManager.h"
#import "Cache.h"


@implementation StatesViewControllerV1

- (id) init
{
	// Call the super-class's designated initialize
	if (!(self = [super initWithNibName: @"StatesViewControllerV1" bundle: nil])) return nil;
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"By State"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"190-bank.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	// Initialize states
	states = [[NSMutableArray alloc] init];
	
	// Initialize request url
	requestUrl = [[NSString alloc] initWithFormat: @"http://api.climbingweather.com/api/state/list?apiKey=iphone-%@", 
				  [[[UIDevice currentDevice ]identifierForVendor] UUIDString]];
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	// Check cache for data
	Cache *sharedCache = [Cache sharedCache];
	
	// Disable caching
	[sharedCache clearAll];
	
	NSString *cacheString = [sharedCache get: requestUrl];
    
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = adjustForTabbarInsets;
    self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
	
	// Found cache data
	if (cacheString != nil) {
		
		NSArray *stateData = [cacheString JSONValue];
		
		[states removeAllObjects];
		for (int i = 0; i < [stateData count]; i++) {
			
			[states addObject: [stateData objectAtIndex: i]];
			
		}
		
		[[self tableView] reloadData];
		return;
		
	}
	
	// If we didn't find cached data, request
	responseData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: requestUrl]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void) viewDidAppear: (BOOL) animated
{
	[[self tabBarController] setTitle: @"US States"];
	[[self navigationController] setNavigationBarHidden: NO];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [states count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCell"];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"UITableViewCell"];
	}
	
	NSString *label = @"area";
	NSString *areaCount = [[states objectAtIndex: [indexPath row]] objectForKey: @"areas"];
	if (![areaCount isEqualToString: @"1"]) {
		label = [NSString stringWithFormat: @"%@s", label];
	}
	
	[[cell textLabel] setText: [[states objectAtIndex: [indexPath row]] objectForKey: @"name"]];
	[[cell detailTextLabel] setText: [NSString stringWithFormat: @" %@ %@", areaCount, label]];
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{	
	AreasViewControllerV1 *controller = [[AreasViewControllerV1 alloc] initWithStateCode:
									   [[states objectAtIndex: [indexPath row]] objectForKey: @"code"]
										name: [[states objectAtIndex: [indexPath row]] objectForKey: @"name"]];
	[controller setShowStates: NO];
	[[self navigationController] pushViewController:controller animated: YES];
	return;

}

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
	
	// Cache data, expire after 24 hours
	Cache *sharedCache = [Cache sharedCache];
	[sharedCache set: requestUrl withValue: responseString expiresOn: [[NSDate date] timeIntervalSince1970] + 60*60*24];
	
	
	NSArray *stateData = [responseString JSONValue];
	
	[states removeAllObjects];
	for (int i = 0; i < [stateData count]; i++) {
		
		[states addObject: [stateData objectAtIndex: i]];

	}
	
	[[self tableView] reloadData];
	
}



@end