//
//  MyManager.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface MyManager : NSObject {
	NSString *stateCode;
	NSString *stateName;
	NSString *areaId;
	NSString *areaName;
	
	sqlite3 *database;

}

@property (nonatomic, strong) NSString *stateCode;
@property (nonatomic, strong) NSString *stateName;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *areaListType;
@property (nonatomic, strong) NSString *areaSearch;
@property (nonatomic, assign) sqlite3 *database;

+ (id) sharedManager;

@end
