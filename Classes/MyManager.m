//
//  MyManager.m
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@implementation MyManager

@synthesize stateCode;
@synthesize stateName;
@synthesize areaId;
@synthesize areaName;
@synthesize areaListType;
@synthesize areaSearch;
@synthesize database;

#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
	return [super init];
	/*
    if (self = [super init]) {
        stateCode = [[NSString alloc] initWithString:@"Default Property Value"];
    }
	 
    return self;
	 */
}

@end
