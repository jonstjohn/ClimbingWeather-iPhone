//
//  SettingsViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewControllerV1.h"


@implementation SettingsViewControllerV1

- (id) init
{
	// Call the super-class's designated initialize
	if (!(self = [super initWithNibName: @"SettingsViewController" bundle: nil])) return nil;
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"Settings"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"20-gear2.png"];
	
	// Put image on tab
	[tbi setImage: i];
	
	[[self navigationItem] setTitle: @"Settings"];
	
	return self;
}

- (void) viewDidAppear: (BOOL) animated
{
	[super viewDidAppear: animated];
	[[self tabBarController] setTitle: @"About / Settings"];
	[[self navigationController] setNavigationBarHidden: NO];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	tempUnits.selectedSegmentIndex = [[prefs stringForKey: @"tempUnit"] isEqualToString: @"c"] ? 1 : 0;
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

- (IBAction) updateTempUnits {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	if (tempUnits.selectedSegmentIndex == 0) {
		[prefs setObject:@"f" forKey:@"tempUnit"];
	}
	
	if (tempUnits.selectedSegmentIndex == 1) {
		[prefs setObject:@"c" forKey:@"tempUnit"];
	}
	
}




@end
