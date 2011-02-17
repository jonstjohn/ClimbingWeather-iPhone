//
//  SearchViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UISearchBarDelegate> {
	NSMutableArray *areas;
	IBOutlet UITableView *myTable;
	NSMutableData *responseData;
}

- (void) search: (NSString *) text;

@end
