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
	states = [[NSMutableArray alloc] init];
	
	return self;
}

- (void) viewDidLoad
{
	//[[[self navigationController] ] setTitle: @"Find Areas"];
	[super viewDidLoad];
	
	requestUrl = @"http://www.climbingweather.com/api/state/list";
	
	// Check for cached data
	sqlite3 *db = [self openDatabase];
	char *sql = "SELECT value FROM cache WHERE cache_key = ? and expires > ?";
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	sqlite3_bind_text(statement, 1, [requestUrl UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 2, [[NSDate date] timeIntervalSince1970]);
	
	while(sqlite3_step(statement) == SQLITE_ROW) {
		
		NSLog(@"loading from cache");
		char *cResponseString = (const char *) sqlite3_column_text(statement, 0);
		NSString *responseString = [[[NSString alloc] initWithUTF8String: cResponseString] autorelease];
		NSArray *stateData = [responseString JSONValue];
		
		[states removeAllObjects];
		for (int i = 0; i < [stateData count]; i++) {
			
			[states addObject: [stateData objectAtIndex: i]];
			
		}
		
		[[self tableView] reloadData];
		return;
			
	}
	
	responseData = [[NSMutableData data] retain];
	
	
	
	NSLog(@"URL: %@", requestUrl);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: requestUrl]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

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
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"UITableViewCell"] autorelease];
	}
	
	NSString *label = @"area";
	NSString *areaCount = [[states objectAtIndex: [indexPath row]] objectForKey: @"areas"];
	if (![areaCount isEqualToString: @"1"]) {
		label = [NSString stringWithFormat: @"%@s", label];
	}
	
	[[cell textLabel] setText: [[states objectAtIndex: [indexPath row]] objectForKey: @"name"]];
	[[cell detailTextLabel] setText: [NSString stringWithFormat: @" %@ %@", areaCount, label]];
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	NSLog(@"Clicked row at index path %@", indexPath);
	
	MyManager *sharedManager = [MyManager sharedManager];
	NSString *stateCode = [[states objectAtIndex: [indexPath row]] objectForKey: @"code"];
	[sharedManager setStateCode: stateCode];
	[sharedManager setStateName: [[states objectAtIndex: [indexPath row]] objectForKey: @"name"]];
	[[self navigationController] pushViewController: [[AreasViewController alloc] initWithNibName:@"AreasViewController" bundle:nil] animated: YES];
	return;

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
	
	// Cache response string
	//MyManager *mgr = [MyManager sharedManager];
	//sqlite3 *db = [mgr database];
	
	
	sqlite3 *db = [self openDatabase];
	
	sqlite3_stmt *stmt;
	const char *sql = "REPLACE INTO cache(cache_key, value, expires) VALUES (?, ?, ?)";
	sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
	sqlite3_bind_text(stmt, 1, [requestUrl UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(stmt, 2, [responseString UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(stmt, 3, [[NSDate date] timeIntervalSince1970] + 60*60*24); // cache for 24 hours
	if (sqlite3_step(stmt) == SQLITE_DONE) {
		NSLog(@"REPLACE INTO succeeded");
	} else {
		NSLog(@"ERROR SAVING: %s", sqlite3_errmsg(db));
	}
	sqlite3_finalize(stmt);

	[responseData release];
	
	NSArray *stateData = [responseString JSONValue];
	
	[states removeAllObjects];
	for (int i = 0; i < [stateData count]; i++) {
		
		[states addObject: [stateData objectAtIndex: i]];

	}
	
	[[self tableView] reloadData];
	
}

- (id) openDatabase {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex: 0];
	
	NSString *fullPath = [path stringByAppendingPathComponent: @"climbingweather.db"];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	BOOL exists = [fm fileExistsAtPath: fullPath];
	
	if (exists) {
		NSLog(@"%@ exists - opening", fullPath);
	} else {
		NSLog(@"%@ does not exist, copying and opening", fullPath);
		NSString *pathForStartingDB = [[NSBundle mainBundle] pathForResource: @"climbingweather" ofType: @"db"];
		BOOL success = [fm copyItemAtPath: pathForStartingDB toPath: fullPath error: NULL];
		if (!success) {
			NSLog(@"Database copy failed");
		}
	}
	
	// Open database file
	sqlite3 *db;
	const char *cFullPath = [fullPath cStringUsingEncoding: NSUTF8StringEncoding];
	if (sqlite3_open(cFullPath, &db) != SQLITE_OK) {
		NSLog(@"Unable to open db at %@", fullPath);
	}
	
	return db;
}


- (void)dealloc {
	[states release];
    [super dealloc];
}


@end
