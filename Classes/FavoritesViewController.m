//
//  FavoritesViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Favorite.h"
#import "AreasTableViewDelegate.h"

@implementation FavoritesViewController

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"FavoritesViewController" bundle: nil];
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"Favorites"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"icon_star.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	[[self navigationItem] setTitle: @"Home"];
	
	// Create the table view delegate
	myTableDelegate = [[AreasTableViewDelegate alloc] init];
	
	return self;
}

- (void) viewDidAppear: (BOOL) animated
{
	[super viewDidAppear: animated];

	[[self tabBarController] setTitle: @"Favorites"];
	[[self navigationController] setNavigationBarHidden: NO];
	
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	NSMutableArray *areas = [sharedFavorite getAll];
	
	if ([areas count] == 0) {
		[myTableDelegate clearAll];
		return;
	}
	NSMutableArray *areaIds = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [areas count]; i++) {
		[areaIds addObject: [[areas objectAtIndex: i] objectForKey: @"area_id"]];
	}
	NSString *areaIdStr = [areaIds componentsJoinedByString:@","];
	
	 [[NSNotificationCenter defaultCenter] addObserver:self
	 selector:@selector(dataLoaded:)
	 name:@"AreaDataLoaded" object:nil];
	
	[myTableDelegate setResponseData: [[NSMutableData data] retain]];
	[myTableDelegate setShowStates: YES];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *tempUnit = [NSString stringWithFormat: @"%@", [[prefs stringForKey: @"tempUnit"] isEqualToString: @"c"] ? @"c" : @"f"];
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/list/ids-%@?days=3&apiKey=iphone-%@&tempUnit=%@",
					 areaIdStr, [[UIDevice currentDevice] uniqueIdentifier], tempUnit];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	[activityIndicator setHidesWhenStopped: NO];
	[activityIndicator startAnimating];
	
	[myTable setHidden: YES];
	
	[[NSURLConnection alloc] initWithRequest:request delegate: myTableDelegate];
	
	[areaIds release];
	
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[myTable setDelegate: myTableDelegate];
	[myTable setDataSource: myTableDelegate];
	[myTableDelegate setAreasTableView: myTable];
	[myTable setSeparatorStyle: UITableViewCellSeparatorStyleNone];
	
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

- (void)viewWillAppear:(BOOL)animated  
{  
    NSIndexPath *tableSelection = [myTable indexPathForSelectedRow];  
    [myTable deselectRowAtIndexPath:tableSelection animated:NO];  
}  

- (void) dataLoaded:(NSNotification *) notification
{	
    [activityIndicator setHidden: YES];
	
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[myTableDelegate release];
    [super dealloc];
}

@end
