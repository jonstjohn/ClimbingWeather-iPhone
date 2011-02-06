//
//  AreasViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"


@interface AreasViewController : UITableViewController {
	NSMutableArray *areas;
	IBOutlet UITableView *myTable;
	NSMutableData *responseData;
}

- (IBAction) clickFavorite: (id) sender;

@end
