//
//  MyManager.h
//  climbingweather
//
//  Created by Jonathan StJohn on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyManager : NSObject {
	NSString *stateCode;
	NSString *stateName;
	NSString *areaId;
	NSString *areaName;

}

@property (nonatomic, retain) NSString *stateCode;
@property (nonatomic, retain) NSString *stateName;
@property (nonatomic, retain) NSString *areaId;
@property (nonatomic, retain) NSString *areaName;

+ (id) sharedManager;

@end
