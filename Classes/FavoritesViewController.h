//
//  FavoritesViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavoritesViewController : UITableViewController {
	NSMutableArray *areas;
	NSMutableData *responseData;
}

@end
