//
//  Database.m
//  climbingweather
//
//  Created by Jonathan StJohn on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Database.h"


@implementation Database

@synthesize database;

static Database *mySharedDatabase = nil;

#pragma mark Singleton Methods
+ (Database *)sharedDatabase {
    @synchronized(self) {
        if(mySharedDatabase == nil)
            mySharedDatabase = [[super allocWithZone:NULL] init];
    }
    return mySharedDatabase;
}
+ (Database *)allocWithZone:(NSZone *)zone {
    return mySharedDatabase;
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
	return [super init];
}

- (sqlite3 *) open {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex: 0];
	
	NSString *fullPath = [path stringByAppendingPathComponent: @"climbingweather.db"];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	BOOL exists = [fm fileExistsAtPath: fullPath];
	
	if (!exists) {
		NSString *pathForStartingDB = [[NSBundle mainBundle] pathForResource: @"climbingweather" ofType: @"db"];
		[fm copyItemAtPath: pathForStartingDB toPath: fullPath error: NULL];
	}
	
	if (database == nil) {
	
		// Open database file if not already open
		//sqlite3 *db;
		const char *cFullPath = [fullPath cStringUsingEncoding: NSUTF8StringEncoding];
		if (sqlite3_open(cFullPath, &database) != SQLITE_OK) {
			NSLog(@"Unable to open db at %@", fullPath);
		}
		
	}
	
	return database;
}


@end
