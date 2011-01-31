//
//  StatesViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StatesViewController.h"
#import "AreasViewController.h"
#import "MyManager.h"


@implementation StatesViewController

- (id) init
{
	// Call the super-class's designated initialize
	[super initWithNibName: @"StatesViewController" bundle: nil];
	
	// Get tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle: @"By State"];
	
	// Add image
	UIImage *i = [UIImage imageNamed:@"icon_blog.png"];
	
	// Put image on tab
	[tbi setImage: i];
	states = [[NSMutableArray alloc] 
		initWithObjects: 
			  [NSArray arrayWithObjects: @"AZ", @"Arizona", nil],
			  [NSArray arrayWithObjects: @"CA", @"California", nil],
			  [NSArray arrayWithObjects: @"WV", @"West Virginia", nil],
			nil
	];
	//states = [NSArray arrayWithObjects: @"Arizona", @"California", @"Colorado", nil];
	
	
	return self;
}

- (void) viewDidLoad
{
	//[[[self navigationController] ] setTitle: @"Find Areas"];
	[super viewDidLoad];

}

- (void) viewDidAppear: (BOOL) animated
{
	[[self tabBarController] setTitle: @"US States"];
	[[self navigationController] setNavigationBarHidden: NO];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [self init];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
	return [states count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCell"];
	
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"UITableViewCell"] autorelease];
	}
	
	[[cell textLabel] setText: [[states objectAtIndex: [indexPath row]] objectAtIndex: 1]]; // @"test"];
	
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"Clicked row at index path %@", indexPath);
	
	MyManager *sharedManager = [MyManager sharedManager];
	NSString *stateCode = [[states objectAtIndex: [indexPath row]] objectAtIndex: 0];
	[sharedManager setStateCode: stateCode];
	[sharedManager setStateName: [[states objectAtIndex: [indexPath row]] objectAtIndex: 1]];
	//[[[self tabBarController] navigationItem] setTitle: @"Find Areas"];
	//[self presentModalViewController:[[AreasViewController alloc] initWithNibName:@"AreasViewController" bundle:nil] animated:NO];
	[[self navigationController] pushViewController: [[AreasViewController alloc] initWithNibName:@"AreasViewController" bundle:nil] animated: YES];
	return;
	
	/*
	responseData = [[NSMutableData data] retain];

	
	NSString *stateCode = [[states objectAtIndex: [indexPath row]] objectAtIndex: 0];
	NSString *url = [NSString stringWithFormat: @"http://www.climbingweather.com/api/state/area/%@", stateCode];
	NSLog(@"URL: %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];

	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	*/

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
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSArray *areas = [responseString JSONValue];
	
	//NSLog("%@", areas);
	[states removeAllObjects];
	for (int i = 0; i < [areas count]; i++) {
		//NSLog(@"%@", [[areas objectAtIndex: i] objectForKey: @"name"]);
		[states addObject: [NSArray arrayWithObjects: [[areas objectAtIndex: i] objectForKey: @"name"], [[areas objectAtIndex: i] objectForKey: @"name"], nil]];
	}
	
	[[self tableView] reloadData];
	
	/*
	NSArray *luckyNumbers = [responseString JSONValue];
	
	NSMutableString *text = [NSMutableString stringWithString:@"Lucky numbers:\n"];
	
	for (int i = 0; i < [luckyNumbers count]; i++)
		[text appendFormat:@"%@\n", [luckyNumbers objectAtIndex:i]];
	
	label.text =  text;
	 */
}


- (void)dealloc {
	[states release];
    [super dealloc];
}


@end
