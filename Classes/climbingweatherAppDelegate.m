//
//  climbingweatherAppDelegate.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/*
#import "climbingweatherAppDelegate.h"
#import "HomeViewController.h"
#import "NearbyViewController.h"
#import "StatesViewController.h"
#import "FavoritesViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "MyManager.h"

@implementation climbingweatherAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Create tabBarController
	UITabBarController *tabController = [[UITabBarController alloc] init];
	[tabController setDelegate: self];
	
	// Create view controllers
	UIViewController *vc1 = [[HomeViewController alloc] init];
	UIViewController *vc2 = [[NearbyViewController alloc] init];
	UIViewController *vc3 = [[StatesViewController alloc] init];
	UIViewController *vc4 = [[FavoritesViewController alloc] init];
	UIViewController *vc5 = [[SearchViewController alloc] init];
	//UIViewController *vc6 = [[MoreViewController alloc] init];
	
	
	// Make an array that contains the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, vc3, vc4, vc5, nil];
	
	[vc1 release];
	[vc2 release];
	[vc3 release];
	[vc4 release];
	[vc5 release];
	//[vc6 release];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.973 green:0.702 blue:0.184 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"SF-UI" size:18.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	
	// Attach to tab bar controller
	[tabController setViewControllers: viewControllers];
	[[tabController navigationItem] setTitle: @"Find Areas"];
	
	
	// Setup navigation controller
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: tabController];
	[navController setNavigationBarHidden: YES];
	[window setRootViewController: navController];
	
	[tabController release];
	[navController release];
	
    [self.window makeKeyAndVisible];

    return YES;
}







- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
*/

