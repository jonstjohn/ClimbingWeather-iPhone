//
//  Cache.m
//  climbingweather
//
//  Created by Jonathan StJohn on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cache.h"

static Cache *mySharedCache = nil;

@implementation Cache

@synthesize database;

#pragma mark Singleton Methods
+ (Cache *)sharedCache {
    @synchronized(self) {
        if(mySharedCache == nil)
            mySharedCache = [[super allocWithZone:NULL] init];
    }
    return mySharedCache;
}
+ (Cache *)allocWithZone:(NSZone *)zone {
    return [mySharedCache retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
    // never release
}
- (id)autorelease {
    return self;
}
- (id)init {
	return [super init];
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [super dealloc];
}

- (sqlite3 *) openDatabase {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex: 0];
	
	NSString *fullPath = [path stringByAppendingPathComponent: @"climbingweather.db"];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	BOOL exists = [fm fileExistsAtPath: fullPath];
	
	if (exists) {
		NSLog(@"%@ exists - opening", fullPath);
	} else {
		NSLog(@"%@ does not exist, copying and opening", fullPath);
		NSString *pathForStartingDB = [[NSBundle mainBundle] pathForResource: @"climbingweather" ofType: @"db"];
		BOOL success = [fm copyItemAtPath: pathForStartingDB toPath: fullPath error: NULL];
		if (!success) {
			NSLog(@"Database copy failed");
		}
	}
	
	// Open database file
	sqlite3 *db;
	const char *cFullPath = [fullPath cStringUsingEncoding: NSUTF8StringEncoding];
	if (sqlite3_open(cFullPath, &db) != SQLITE_OK) {
		NSLog(@"Unable to open db at %@", fullPath);
	}
	
	return db;
}

- (NSString *) get: (NSString *) cacheKey {

	// Check for cached data
	sqlite3 *db = [self openDatabase];
	char *sql = "SELECT value FROM cache WHERE cache_key = ? and expires > ?";
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	sqlite3_bind_text(statement, 1, [cacheKey UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 2, [[NSDate date] timeIntervalSince1970]);
	
	while(sqlite3_step(statement) == SQLITE_ROW) {
		
		NSLog(@"loading from cache");
		char *cResponseString = (char *) sqlite3_column_text(statement, 0);
		NSString *responseString = [[[NSString alloc] initWithUTF8String: cResponseString] autorelease];
		sqlite3_close(db);
		return responseString;
		
	}
	
	return nil;
	
}

- (void) set: (NSString *) cacheKey withValue: (NSString *) value expiresOn: (int) expires {
	
	sqlite3 *db = [self openDatabase];
	
	sqlite3_stmt *stmt;
	const char *sql = "REPLACE INTO cache(cache_key, value, expires) VALUES (?, ?, ?)";
	sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
	sqlite3_bind_text(stmt, 1, [cacheKey UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(stmt, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(stmt, 3, expires); // cache for 24 hours
	if (sqlite3_step(stmt) == SQLITE_DONE) {
		NSLog(@"REPLACE INTO succeeded");
	} else {
		NSLog(@"ERROR SAVING: %s", sqlite3_errmsg(db));
	}
	sqlite3_finalize(stmt);
	sqlite3_close(db);
	
}

- (void) clearAll {
	
	sqlite3 *db = [self openDatabase];
	const char *sql = "DELETE FROM cache";
	
	char *db_err = "";
	sqlite3_exec(db, sql, NULL, 0, &db_err);
	sqlite3_close(db);

}

@end
