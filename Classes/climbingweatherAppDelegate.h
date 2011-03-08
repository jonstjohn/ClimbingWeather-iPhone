//
//  climbingweatherAppDelegate.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface climbingweatherAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UIWindow *window;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

