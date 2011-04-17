//
//  AreasViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "AreasTableViewDelegate.h"


@interface AreasViewController : UIViewController {

	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	AreasTableViewDelegate *myTableDelegate;
	BOOL showStates;
	
	NSString *stateCode;
	NSString *stateName;
	
}

@property (nonatomic, retain) AreasTableViewDelegate *myTableDelegate;

- (id) initWithStateCode: (NSString *) code name: (NSString *) name;
- (void) setShowStates: (BOOL) show;
@end
