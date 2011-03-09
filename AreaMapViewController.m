//
//  AreaMapViewController.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AreaMapViewController.h"
#import "MapPoint.h"
#import "MyManager.h"

@implementation AreaMapViewController

- (id) init
{
	// Setup tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	[tbi setTitle: @"Map"];
	
	UIImage *i = [UIImage imageNamed:@"icon_blog.png"];
	[tbi setImage: i];
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate: self];
	
	[locationManager setDistanceFilter: kCLDistanceFilterNone];
	[locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
	
	[mapView setShowsUserLocation: YES];
	
	return self;
}

- (void) mapView: (MKMapView *) mv didAddAnnotationViews: (NSArray *) views
{

	MKAnnotationView *annotationView = [views objectAtIndex: 0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 10000, 10000);
	[mv setRegion: region animated: NO];
	[mv setHidden: NO];
}

- (MKAnnotationView *) mapView: (MKMapView *) mv viewForAnnotation: (id <MKAnnotation>) annotation
{
	if ([mv userLocation] == annotation) {
		return nil;
	}
	
	NSString *identifier = @"climbing_area";
	
	MKAnnotationView *annotationView = [mv dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (annotationView == nil) {
		annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
													   reuseIdentifier:identifier]
						  autorelease];
		
		[annotationView setImage: [UIImage imageNamed:@"climbing.png"]];
		
		[annotationView setCanShowCallout: YES];
	}
	return annotationView;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Send request for JSON data
	MyManager *sharedManager = [MyManager sharedManager];
	
	responseData = [[NSMutableData data] retain];
	
	NSString *url = [NSString stringWithFormat: @"http://api.climbingweather.com/api/area/detail/%@?apiKey=android-%@",
					 [sharedManager areaId], [[UIDevice currentDevice] uniqueIdentifier]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	[mapView setHidden: YES];
	
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
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	NSDictionary *detail = [responseString JSONValue];
	
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [[detail objectForKey: @"latitude"] floatValue];
	coordinate.longitude = [[detail objectForKey: @"longitude"] floatValue];
	MapPoint *mp = [[MapPoint alloc] initWithCoordinate: coordinate title: [detail objectForKey: @"name"] ];
	[mapView addAnnotation: mp];
	[mp release];
	
	[responseString release];
	
	
}


- (void)dealloc {
	[responseData release];
	//[window release];
	[locationManager release];
    [super dealloc];
}


@end
