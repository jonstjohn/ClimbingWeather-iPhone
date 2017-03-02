//
//  AreaDailyViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaDailyViewControllerV1 : UIViewController <UITableViewDelegate> {
	NSMutableArray *days;
	IBOutlet UITableView *dailyTableView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSMutableData *responseData;
}

@end
