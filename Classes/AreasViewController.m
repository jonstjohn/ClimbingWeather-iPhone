//
//  AreasViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreasViewController.h"
#import "AreaDailyViewController.h"
#import "AreaHourlyViewController.h"
#import "AreaMapViewController.h"
#import "MyManager.h"

@implementation AreasViewController

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"StatesViewController" bundle: nil];
	
	/*
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"By State"];
	
	// Add image
	//UIImage *i = [UIImage imageNamed:@"Hypno.png"];
	
	// Put image on tab
	//[tbi setImage: i];
	states = [[NSMutableArray alloc] 
			  initWithObjects: 
			  [NSArray arrayWithObjects: @"AZ", @"Arizona", nil],
			  [NSArray arrayWithObjects: @"CA", @"California", nil],
			  [NSArray arrayWithObjects: @"WV", @"West Virginia", nil],
			  nil
			  ];
	//states = [NSArray arrayWithObjects: @"Arizona", @"California", @"Colorado", nil];
	*/
	
	MyManager *sharedManager = [MyManager sharedManager];
	[[self navigationItem] setTitle: [sharedManager stateCode]];
	areas = [[NSMutableArray alloc] initWithObjects: nil];
	
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	MyManager *sharedManager = [MyManager sharedManager];
	NSLog(@"Areas view state code is: %@", [sharedManager stateCode]);
	
	responseData = [[NSMutableData data] retain];
	
	
	//NSString *stateCode = [[states objectAtIndex: [indexPath row]] objectAtIndex: 0];
	NSString *url = [NSString stringWithFormat: @"http://www.climbingweather.com/api/state/area/%@", [sharedManager stateCode]];
	NSLog(@"URL: %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[[self navigationController] setNavigationBarHidden: NO];
	
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
	return [areas count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"Displaying row: %i", [indexPath row]);
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCell"];
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"UITableViewCell"] autorelease];
	}
	NSLog(@"%@", areas);
	[[cell textLabel] setText: [[areas objectAtIndex: [indexPath row]] objectAtIndex: 1]]; // @"test"];
	
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"Clicked row at index path %@", indexPath);

	MyManager *sharedManager = [MyManager sharedManager];
	NSString *areaName = [[areas objectAtIndex: [indexPath row]] objectAtIndex: 1];
	sharedManager.areaName = areaName;
	NSString *areaId = [[areas objectAtIndex: [indexPath row]] objectAtIndex: 0];
	sharedManager.areaId = areaId;
	
	// Create tabBarController
	UITabBarController *tabController = [[UITabBarController alloc] init];
	
	// Create two view controllers
	UIViewController *vc1 = [[AreaDailyViewController alloc] init];
	UIViewController *vc2 = [[AreaHourlyViewController alloc] init];
	UIViewController *vc3 = [[AreaMapViewController alloc] init];
	//UIViewController *vc4 = [[FavoritesViewController alloc] init];
	
	
	// Make an array that contains the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, vc3, nil];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
	
	// Attach to tab bar controller
	[tabController setViewControllers: viewControllers];
	
	[[tabController navigationItem] setTitle: areaName];
	
	[[self navigationController] pushViewController: tabController animated: YES];
	
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
	[connection release];
	
	NSLog(@"Finished loading");
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSLog(@"%@", responseString);
	NSArray *areasJson = [responseString JSONValue];
	
	NSLog(@"Count: %i", [areasJson count]);
	[areas removeAllObjects];
	
	for (int i = 0; i < [areasJson count]; i++) {
		NSLog(@"Area # %i", i);
		NSLog(@"%@", [[areasJson objectAtIndex: i] objectForKey: @"name"]);
		[areas addObject: [NSArray arrayWithObjects: [[areasJson objectAtIndex: i] objectForKey: @"id"], [[areasJson objectAtIndex: i] objectForKey: @"name"], nil]];
		NSLog(@"Added object");
		NSLog(@"%@", areas);
	}
	
	NSLog(@"Reloading table");
	NSLog(@"Areas: %@", areas);
	[[self tableView] reloadData];
	
}


- (void)dealloc {
	[areas release];
    [super dealloc];
}


@end
