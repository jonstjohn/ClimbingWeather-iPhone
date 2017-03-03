//
//  AreaMapViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface AreaMapViewControllerV1 : UIViewController <CLLocationManagerDelegate> {
	
	//CLLocationManager *locationManager;
	IBOutlet MKMapView *mapView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSMutableData *responseData;

}

@end
