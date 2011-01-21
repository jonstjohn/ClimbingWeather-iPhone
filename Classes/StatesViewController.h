//
//  StatesViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"


@interface StatesViewController : UITableViewController {
	NSMutableArray *states;
	IBOutlet UITableView *myTable;
	NSMutableData *responseData;

}

@end
