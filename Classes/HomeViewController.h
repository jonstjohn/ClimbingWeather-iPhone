//
//  HomeViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController <UISearchBarDelegate>
{
}

- (IBAction)showNearby: (id)sender;
- (IBAction)showByState: (id)sender;
- (IBAction)showFavorites: (id)sender;
- (IBAction)showSearch: (id)sender;

@end
