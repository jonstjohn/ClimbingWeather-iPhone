//
//  climbingweatherAppDelegate.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "climbingweatherAppDelegate.h"
#import "HomeViewController.h"
#import "NearbyViewController.h"
#import "StatesViewControllerV1.h"
#import "FavoritesViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "MyManager.h"
#import "climbingweather-swift.h"

@implementation climbingweatherAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Create tabBarController
	UITabBarController *tabController = [[UITabBarController alloc] init];
	[tabController setDelegate: self];
	
    //
	// Create view controllers
    //
    
	UIViewController *vc1 = [[HomeViewController alloc] init];
    
    // Nearby areas
    AreasViewController *vc2 = [[AreasViewController alloc] init];
    [vc2 setSearchAsLocationWithLatitude:@"37.7397" longitude:@"-119.5730"];
    
    UITabBarItem *tbi2 = [[UITabBarItem alloc] initWithTitle: @"Nearby Areas" image: [UIImage imageNamed:@"73-radar.png"] selectedImage: [UIImage imageNamed: @"73-radar.png"]];
    vc2.tabBarItem = tbi2;
    
    // States
    UIViewController *vc3 = [[StatesViewController alloc] init];
    UITabBarItem *tbi3 = [[UITabBarItem alloc] initWithTitle: @"By State" image: [UIImage imageNamed:@"190-bank.png"] selectedImage: [UIImage imageNamed: @"190-bank.png"]];
    vc3.tabBarItem = tbi3;
    
    // Favorites
    AreasViewController *vc4 = [[AreasViewController alloc] init];
    UITabBarItem *tbi4 = [[UITabBarItem alloc] initWithTitle: @"Favorites" image: [UIImage imageNamed:@"icon_star.png"] selectedImage: [UIImage imageNamed: @"icon_star.png"]];
    vc4.tabBarItem = tbi4;
    [vc4 setSearchAsFavorites];
	//UIViewController *vc4 = [[FavoritesViewController alloc] init];
	UIViewController *vc5 = [[SearchViewController alloc] init];
	
	// Make an array that contains the two view controllers
	NSArray *viewControllers = [NSArray arrayWithObjects: vc1, vc2, vc3, vc4, vc5, nil];
	
	//[vc6 release];
	
	// Attach to tab bar controller
	[tabController setViewControllers: viewControllers];
	[[tabController navigationItem] setTitle: @"Find Areas"];
	
	
	// Setup navigation controller
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: tabController];
	[navController setNavigationBarHidden: YES];
	[window setRootViewController: navController];
	
	
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}



@end

