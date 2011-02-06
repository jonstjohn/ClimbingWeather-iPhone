//
//  FavoritesViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Favorite.h"


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
	
	return self;
}

- (void) viewDidAppear: (BOOL) animated
{
	[[self tabBarController] setTitle: @"Favorites"];
	[[self navigationController] setNavigationBarHidden: NO];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Get favorite areas from db
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	areas = [sharedFavorite getAll];
	NSLog(@"Areas: %@", areas);
	
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


- (void)dealloc {
    [super dealloc];
}


@end
