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

@property (nonatomic, retain) NSString *stateCode;
@property (nonatomic, retain) NSString *stateName;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *areaName;
@property (nonatomic, assign) sqlite3 *database;

+ (id) sharedManager;

@end
