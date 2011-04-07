//
//  FavoritesViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreasTableViewDelegate.h"


@interface FavoritesViewController : UIViewController {

	IBOutlet UITableView *myTable;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	AreasTableViewDelegate *myTableDelegate;
}

@end
