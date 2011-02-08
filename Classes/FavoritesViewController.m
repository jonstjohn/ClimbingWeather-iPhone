//
//  FavoritesViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Favorite.h"
#import "AreasCell.h"
#import "MyManager.h"
#import "AreasViewController.h"
#import "AreaDailyViewController.h"
#import "AreaHourlyViewController.h"
#import "AreaMapViewController.h"
#import "AreaDetailController.h"
#import "AreaAveragesController.h"


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
	
	[[self tableView] setRowHeight: 85.0];
	
	return self;
}

- (void) viewDidAppear: (BOOL) animated
{
	[super viewDidAppear: animated];
	[[self tabBarController] setTitle: @"Favorites"];
	[[self navigationController] setNavigationBarHidden: NO];
	
	// Get favorite areas from db
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	areas = [sharedFavorite getAll];
	[[self tableView] reloadData];
	NSLog(@"Areas: %@", areas);
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	// Get favorite areas from db
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	areas = [sharedFavorite getAll];
	NSLog(@"Areas: %@", areas);
	 */
	
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [areas count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	
	AreasCell *cell = (AreasCell *)[tableView dequeueReusableCellWithIdentifier: @"AreasCell"];
	
	if (!cell) {
		cell = [[[AreasCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"AreasCell"] autorelease];
	}
	
	NSDictionary *area = [areas objectAtIndex: [indexPath row]];
	
	[[cell areaName] setText: [area objectForKey: @"name"]];
	
	//Favorite *sharedFavorite = [Favorite sharedFavorite];
	
	//NSString *imgSrc = @"btn_star_big_off.png";
	//if ([sharedFavorite exists: [area objectForKey: @"id"]]) {
		//imgSrc = @"btn_star_big_on.png";
	//}
	UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_on.png"];
	[[cell favoriteImage] setImage: btnImage forState: UIControlStateNormal];
	[[cell favoriteImage] setTag: 1];
	[[cell favoriteImage] addTarget:self action:@selector(buttonPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
	
	//[[[cell favoriteImage] imageView] setImage: [UIImage imageNamed: @"icon_star.png"]];
	//[[cell favoriteImage] addTarget];
	/*
	NSArray *forecast = [area objectForKey: @"f"];
	NSDictionary *day1 = [forecast objectAtIndex: 0];
	NSDictionary *day2 = [forecast objectAtIndex: 1];
	NSDictionary *day3 = [forecast objectAtIndex: 2];
	[[cell day1Symbol] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [day1 objectForKey: @"sy"]]]];
	[[cell day1Temp] setText: [NSString stringWithFormat: @"%@˚ / %@˚", [day1 objectForKey: @"hi"], [day1 objectForKey: @"l"]]];
	[[cell day1Precip] setText: [NSString stringWithFormat: @"%@%% / %@%%", [day1 objectForKey: @"pd"], [day1 objectForKey: @"pn"]]];
	[[cell day2Symbol] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [day2 objectForKey: @"sy"]]]];
	[[cell day2Temp] setText: [NSString stringWithFormat: @"%@˚ / %@˚", [day2 objectForKey: @"hi"], [day2 objectForKey: @"l"]]];
	[[cell day2Precip] setText: [NSString stringWithFormat: @"%@%% / %@%%", [day2 objectForKey: @"pd"], [day2 objectForKey: @"pn"]]];
	[[cell day3Symbol] setImage: [UIImage imageNamed: [NSString stringWithFormat: @"%@.png", [day3 objectForKey: @"sy"]]]];
	[[cell day3Temp] setText: [NSString stringWithFormat: @"%@˚ / %@˚", [day3 objectForKey: @"hi"], [day3 objectForKey: @"l"]]];
	[[cell day3Precip] setText: [NSString stringWithFormat: @"%@%% / %@%%", [day3 objectForKey: @"pd"], [day3 objectForKey: @"pn"]]];
	*/
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"Clicked row at index path %@", indexPath);
	
	MyManager *sharedManager = [MyManager sharedManager];
	NSString *areaName = [[areas objectAtIndex: [indexPath row]] objectForKey: @"name"];
	sharedManager.areaName = areaName;
	NSString *areaId = [[areas objectAtIndex: [indexPath row]] objectForKey: @"area_id"];
	sharedManager.areaId = areaId;
	
	// Create tabBarController
	UITabBarController *tabController = [[UITabBarController alloc] init];
	
	// Create view controllers
	UIViewController *vc1 = [[AreaDailyViewController alloc] init];
	UIViewController *vc2 = [[AreaHourlyViewController alloc] init];
	UIViewController *vc3 = [[AreaMapViewController alloc] init];
	UIViewController *vc4 = [[AreaAveragesController alloc] init];
	UIViewController *vc5 = [[AreaDetailController alloc] init];
	
	
	// Make an array that contains the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, vc3, vc4, vc5, nil];
	
	// Attach to tab bar controller
	[tabController setViewControllers: viewControllers];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
	[vc4 release];
	[vc5 release];
	
	[[tabController navigationItem] setTitle: areaName];
	
	[[self navigationController] pushViewController: tabController animated: YES];
	
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

- (IBAction) buttonPressed: (id) sender
{
	NSLog(@"Pressed");
	NSLog(@"%i", ((UIButton*)sender).tag);
	
	NSIndexPath *indexPath = [[self tableView] indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
	
	NSString *areaId = [[areas objectAtIndex: [indexPath row]] objectForKey: @"area_id"];
	NSString *name = [[areas objectAtIndex: [indexPath row]] objectForKey: @"name"];
	
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	
	// If this is a favorite, remove
	if ([sharedFavorite exists: areaId]) {
		NSLog(@"Favorite exists");
		[sharedFavorite remove: areaId];
		UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_off.png"];
		[(UIButton *) sender setImage: btnImage forState: UIControlStateNormal];
		// If isn't a favorite, add
	} else {
		NSLog(@"Favorite does not exist, add");
		[sharedFavorite add: areaId withName: name];
		UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_on.png"];
		[(UIButton *) sender setImage: btnImage forState: UIControlStateNormal];
	}
	NSLog(@"%@", areaId);
	NSLog(@"%@", indexPath);
	areas = [sharedFavorite getAll];
	[[self tableView] reloadData];
	/*
	 switch ( ((UIButton*)sender).tag ){
	 
	 case 1:
	 <something>
	 break;
	 case 2:
	 <something else>
	 break;
	 
	 default:
	 <default something>
	 }
	 */
}


@end
