//
//  NearbyViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface NearbyViewController : UIViewController <CLLocationManagerDelegate>
{
	NSMutableArray *areas;
	CLLocationManager *locationManager;
	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSMutableData *responseData;
}

@property (nonatomic, retain) CLLocationManager *locationManager;  

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void) search: (NSString *) text;

@end
