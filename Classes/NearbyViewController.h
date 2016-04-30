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
	
	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	AreasTableViewDelegate *myTableDelegate;
}

//@property (nonatomic, retain) CLLocationManager *locationManager; 
//@property (nonatomic, retain) AreasTableViewDelegate *myTableDelegate;

- (void) search: (NSString *) text;

- (void) refreshResults;
- (IBAction)clickRefresh: (id)sender;

@end
