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
	IBOutlet UISearchBar *searchInput;
	
	AreasTableViewDelegate *myTableDelegate;
	NSString *initialSearch;
}


@property (nonatomic, strong) AreasTableViewDelegate *myTableDelegate;
@property (nonatomic, strong) NSString *initialSearch;

- (void) search: (NSString *) text;

@end
