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
#import "AreaDetailController.h"
#import "AreaAveragesController.h"
#import "MyManager.h"
#import "AreasCell.h"
#import "Favorite.h"
#import "AreasTableViewDelegate.h"

@implementation AreasViewController

@synthesize listType;
@synthesize listData;

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"StatesViewController" bundle: nil];
	
	MyManager *sharedManager = [MyManager sharedManager];
	[[self navigationItem] setTitle: [sharedManager stateCode]];
		
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//MyManager *sharedManager = [MyManager sharedManager];
	
	responseData = [[NSMutableData data] retain];
	
	// Type is 'state'
	if ([[self listType] isEqualToString: @"state"]) {
	
		NSString *url = [NSString stringWithFormat: @"http://www.climbingweather.com/api/state/area/%@?days=3", [self listData]];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
		[[NSURLConnection alloc] initWithRequest:request delegate:self];
		
	}
	
	// TODO: other types here, such as nearby areas, favorites, search results
	
	[[self navigationController] setNavigationBarHidden: NO];
	
	// Set table delegate
	AreasTableViewDelegate *tableDelegate = [[AreasTableViewDelegate alloc] init];
	[myTable setDelegate: tableDelegate];
	[myTable setDataSource: tableDelegate];
	[myTable setHidden: YES];
	[myTable setRowHeight: 85.0];
	
	NSLog(@"%@", [self listType]);
	NSLog(@"%@", [self listData]);
	
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
	
	NSMutableArray *myAreas = [(AreasTableViewDelegate *) [myTable delegate] areas];
	[myAreas removeAllObjects];
	
	for (int i = 0; i < [areasJson count]; i++) {
		[myAreas addObject: [areasJson objectAtIndex: i]];
	}
	
	//[activityIndicator setHidden: YES];
	[myTable setHidden: NO];
	
	[myTable setRowHeight: 85.0];
	[myTable reloadData];

	
}

- (IBAction) clickFavorite: (id) sender
{
	NSLog(@"clicked favorite");
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) buttonPressed: (id) sender
{
	NSLog(@"Pressed");
	NSLog(@"%i", ((UIButton*)sender).tag);
	
	NSIndexPath *indexPath = [myTable indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
	
	NSString *areaId = [[[myTable areas] objectAtIndex: [indexPath row]] objectForKey: @"id"];
	NSString *name = [[[myTable areas] objectAtIndex: [indexPath row]] objectForKey: @"name"];
	
	Favorite *sharedFavorite = [Favorite sharedFavorite];
	
	// If this is a favorite, remove
	if ([sharedFavorite exists: areaId]) {

		[sharedFavorite remove: areaId];
		UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_off.png"];
		[(UIButton *) sender setImage: btnImage forState: UIControlStateNormal];

		// If isn't a favorite, add
	} else {

		[sharedFavorite add: areaId withName: name];
		UIImage *btnImage = [UIImage imageNamed: @"btn_star_big_on.png"];
		[(UIButton *) sender setImage: btnImage forState: UIControlStateNormal];
	}

}


@end
