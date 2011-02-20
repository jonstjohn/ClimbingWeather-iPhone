//
//  SearchViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreasTableViewDelegate.h"


@interface SearchViewController : UIViewController <UISearchBarDelegate>
{
	IBOutlet UITableView *myTable;
	AreasTableViewDelegate *myTableDelegate;
}

@property (nonatomic, retain) AreasTableViewDelegate *myTableDelegate;

- (void) search: (NSString *) text;

@end
