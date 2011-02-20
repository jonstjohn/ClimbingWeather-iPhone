//
//  AreasViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreasViewController.h"

@implementation AreasViewController

- (id) initWithStateCode: (NSString *) code name: (NSString *) name
{
	stateCode = code;
	stateName = name;
	return [self init];
}

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"AreasViewController" bundle: nil];
	
	//MyManager *sharedManager = [MyManager sharedManager];
	[[self navigationItem] setTitle: stateCode];
	
	// Create the table view delegate
	myTableDelegate = [[AreasTableViewDelegate alloc] init];
		
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[myTable setDelegate: myTableDelegate];
	[myTable setDataSource: myTableDelegate];
	[myTableDelegate setAreasTableView: myTable];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dataLoaded:)
                                                 name:@"AreaDataLoaded" object:nil];
	
	[myTableDelegate setResponseData: [[NSMutableData data] retain]];
	
	NSString *url = [NSString stringWithFormat: @"http://www.climbingweather.com/api/state/area/%@?days=3", stateCode];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate: myTableDelegate];
	
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

- (void) dataLoaded:(NSNotification *)notification{
	
    //[activityIndicator setHidden: YES];
	
}

- (void)dealloc {
    [super dealloc];
}

@end
