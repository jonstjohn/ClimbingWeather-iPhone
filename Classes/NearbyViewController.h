//
//  NearbyViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AreasTableViewDelegate.h"


@interface NearbyViewController : UIViewController <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
	CLLocation *lastLocation;
	
	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	//NSMutableData *responseData;
	AreasTableViewDelegate *myTableDelegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager; 
@property (nonatomic, retain) AreasTableViewDelegate *myTableDelegate;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void) search: (NSString *) text;

@end
