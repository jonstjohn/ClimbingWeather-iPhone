//
//  MoreController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"


@implementation MoreViewController

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"MoreViewController" bundle: nil];
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"Settings"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"20-gear2.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	[[self navigationItem] setTitle: @"Settings"];
	
	//[[self tableView] setRowHeight: 85.0];
	
	// Create the table view delegate
	//myTableDelegate = [[AreasTableViewDelegate alloc] init];
	
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

- (void) viewDidAppear: (BOOL) animated
{
	[super viewDidAppear: animated];
	[[self tabBarController] setTitle: @"About / Settings"];
	[[self navigationController] setNavigationBarHidden: NO];
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


- (void)dealloc {
    [super dealloc];
}


@end
