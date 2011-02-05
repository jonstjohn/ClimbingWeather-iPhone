//
//  Cache.h
//  climbingweather
//
//  Created by Jonathan StJohn on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Cache : NSObject {

	sqlite3 *database;
}

@property (nonatomic, assign) sqlite3 *database;

+ (Cache *) sharedCache;
- (NSString *) get: (NSString *) cacheKey;
- (void) set: (NSString *) cacheKey withValue: (NSString *) value expiresOn: (int) expires;
- (void) clearAll;

@end
