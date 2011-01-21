//
//  climbingweatherAppDelegate.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatesViewController;

@interface climbingweatherAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	StatesViewController *statesViewController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

