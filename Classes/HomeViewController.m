//
//  HomeViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"HomeViewController" bundle: nil];
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"Home"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"icon_home.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	[[self navigationItem] setTitle: @"Home"];
	
	return self;
}

// Did appears
- (void) viewDidAppear: (BOOL) animated
{
	[[self tabBarController] setTitle: @"Home"];
	[[self navigationController] setNavigationBarHidden: YES];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	NSString *searchBarText = [NSString stringWithFormat: @"%@", [searchBar text]];
	[[[[self tabBarController] viewControllers] objectAtIndex: 4] setInitialSearch: searchBarText];
	[searchBarText release];
	[[self tabBarController] setSelectedIndex: 4];
}

- (IBAction) showNearby: (id) sender
{
	[[self tabBarController] setSelectedIndex: 1];
}

- (IBAction) showByState: (id) sender
{
	[[self tabBarController] setSelectedIndex: 2];
}

- (IBAction) showFavorites: (id) sender
{
	[[self tabBarController] setSelectedIndex: 3];
}

- (IBAction) showSearch: (id) sender
{
	[[self tabBarController] setSelectedIndex: 4];
}

- (void)dealloc {
    [super dealloc];
}


@end
