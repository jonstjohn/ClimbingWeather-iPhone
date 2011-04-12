//
//  AreaHourlyViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaHourlyViewController : UITableViewController {
	NSMutableArray *days;
	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSMutableData *responseData;
}

@end
