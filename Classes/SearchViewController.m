//
//  SearchViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

@synthesize myTableDelegate;

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"SearchViewController" bundle: nil];
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"Search"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"icon_magnify_glass.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	// Create the table view delegate
	myTableDelegate = [[AreasTableViewDelegate alloc] init];
	
	//[[self navigationItem] setTitle: @"Search"];
	
	return self;
}

- (void) viewDidAppear: (BOOL) animated
{
	[[self tabBarController] setTitle: @"Search Areas"];
	[[self navigationController] setNavigationBarHidden: NO];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[myTable setDelegate: myTableDelegate];
	[myTable setDataSource: myTableDelegate];
	[myTableDelegate setAreasTableView: myTable];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dataLoaded:)
                                                 name:@"AreaDataLoaded" object:nil];
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




- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	[self search: [searchBar text]];
}

/*
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	NSLog(@"end editing");
	NSLog(@"%@", [searchBar text]);
}
 */

- (void) search: (NSString *) text
{
	[myTableDelegate setResponseData: [[NSMutableData data] retain]];
	
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/LIST/%@?days=3&apiKey=android-",
					 text, [[UIDevice currentDevice] uniqueIdentifier]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate: myTableDelegate];
	
}

- (void) dataLoaded:(NSNotification *)notification{
	
    //[activityIndicator setHidden: YES];
	
}

- (void)dealloc
{    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[myTableDelegate dealloc];
	[super dealloc];
}


@end
