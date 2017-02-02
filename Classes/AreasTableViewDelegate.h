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
	BOOL showStates;
}

-(void) clearAll;

@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) UITableView *areasTableView;
@property (nonatomic, strong) NSMutableData *responseData;

- (void) setShowStates: (BOOL) show;

@end
