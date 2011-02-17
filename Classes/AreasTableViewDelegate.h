//
//  AreasTableViewDelegate.h
//  climbingweather
//
//  Created by Jonathan StJohn on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AreasTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *areas;
}

@property (nonatomic, retain) NSMutableArray *areas;

@end
