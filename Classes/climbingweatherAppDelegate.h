//
//  climbingweatherAppDelegate.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class StatesViewController;

@interface climbingweatherAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UIWindow *window;
	StatesViewController *statesViewController;
	
	sqlite3_stmt *statement;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

