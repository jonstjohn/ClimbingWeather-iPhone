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
	UITableView *areasTableView;
	NSMutableData *responseData;
	UITabBarController *tabController;
}

-(void) clearAll;

@property (nonatomic, retain) NSMutableArray *areas;
@property (nonatomic, retain) UITableView *areasTableView;
@property (nonatomic, retain) NSMutableData *responseData;

@end
