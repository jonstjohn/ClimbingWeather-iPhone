//
//  MapPoint.h
//  climbingweather
//
//  Created by Jonathan StJohn on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject <MKAnnotation> {
	
	NSString *title;
	CLLocationCoordinate2D coordinate;

}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

- (id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *) t;

@end
