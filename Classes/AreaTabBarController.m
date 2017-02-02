    //
//  AreaTabBarController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaTabBarController.h"
#import "AreaDailyViewController.h"


@implementation AreaTabBarController

- (id) init
{
	UIViewController *vc1 = [[AreaDailyViewController alloc] initWithNibName:(NSString *) @"AreaDailyViewController" bundle:(NSBundle *) nil];
	//UIViewController *vc2 = [[NearbyViewController alloc] init];
	//UIViewController *vc3 = [[StatesViewController alloc] init];
	//UIViewController *vc4 = [[FavoritesViewController alloc] init];
	
	
	// Make an array that contains the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects: vc1, nil]; // , vc2, vc3, nil];
	
	//[vc2 release];
	//[vc3 release];
	
	// Attach to tab bar controller
	[self setViewControllers: viewControllers];
	
	// Set tabBarController as root view of the window
	//[[self window] setRootViewController: tabController];
	[[self navigationItem] setTitle: @"Area"];
	
	// The window retains the tabBarController, we can release our reference
	//[tabController release];	
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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




@end
