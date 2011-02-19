//
//  SearchViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreasTableViewDelegate.h"


@interface SearchViewController : UIViewController <UISearchBarDelegate> {
	NSMutableArray *areas;
	IBOutlet UITableView *myTable;
	NSMutableData *responseData;
	AreasTableViewDelegate *myTableDelegate;
}

@property (nonatomic, retain) AreasTableViewDelegate *myTableDelegate;

- (void) search: (NSString *) text;

@end
