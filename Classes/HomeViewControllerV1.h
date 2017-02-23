//
//  HomeViewController.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewControllerV1 : UIViewController <UITextViewDelegate>
{
	UITabBarController *settingsTab;
}

- (IBAction)showNearby: (id)sender;
- (IBAction)showByState: (id)sender;
- (IBAction)showFavorites: (id)sender;
- (IBAction)showSettings: (id)sender;

@end
