//
//  HomeViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewControllerV1.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"


@implementation HomeViewControllerV1

- (id) init
{
	// Call the super-class's designated initialize
	if (!(self = [super initWithNibName: @"HomeViewControllerV1" bundle: nil])) return nil;
	
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

/*
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	NSString *searchBarText = [NSString stringWithFormat: @"%@", [searchBar text]];
	
	
	//SearchViewController *svc = [[SearchViewController alloc] init];
	//[svc setInitialSearch: searchBarText];
	//[[self navigationController] pushViewController: svc animated: NO];
	
	
	[[[[self tabBarController] viewControllers] objectAtIndex: 4] setInitialSearch: searchBarText];
	[searchBarText release];
	[[self tabBarController] setSelectedIndex: 4];
	
}
*/

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	NSString *searchBarText = [NSString stringWithFormat: @"%@", [textField text]];
	
	/*
	 SearchViewController *svc = [[SearchViewController alloc] init];
	 [svc setInitialSearch: searchBarText];
	 [[self navigationController] pushViewController: svc animated: NO];
	 */
	
	// TODO [[[[self tabBarController] viewControllers] objectAtIndex: 4] setInitialSearch: searchBarText];
	//[searchBarText release];
	[[self tabBarController] setSelectedIndex: 4];
	return YES;
}

- (IBAction) showSettings: (id) sender
{
	//MoreViewController *moreVc = [[MoreViewController alloc] init];
	//[[self navigationController] pushViewController: moreVc animated: NO];
	// Create tabBarController
	if (settingsTab == nil) {
		//UITabBarController *tabController = [[[UITabBarController alloc] init] autorelease];
		settingsTab = [[UITabBarController alloc] init];
	
		// Create view controllers
		UIViewController *vc1 = [[AboutViewController alloc] init];
		UIViewController *vc2 = [[SettingsViewController alloc] init];
	
		// Make an array that contains the two view controllers
		NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, nil];
	
		// Attach to tab bar controller
		[settingsTab setViewControllers: viewControllers];
	
	}

	[[self navigationController] pushViewController: settingsTab animated: NO];
}



@end
