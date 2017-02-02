//
//  Cache.m
//  climbingweather
//
//  Created by Jonathan StJohn on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cache.h"
#import "Database.h"

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
    return mySharedCache;
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
	return [super init];
}

- (NSString *) get: (NSString *) cacheKey {

	// Check for cached data
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	char *sql = "SELECT value FROM cache WHERE cache_key = ? and expires > ?";
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	sqlite3_bind_text(statement, 1, [cacheKey UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 2, [[NSDate date] timeIntervalSince1970]);
	
	while(sqlite3_step(statement) == SQLITE_ROW) {
		
		NSLog(@"loading from cache");
		char *cResponseString = (char *) sqlite3_column_text(statement, 0);
		NSString *responseString = [[NSString alloc] initWithUTF8String: cResponseString];
		//sqlite3_close(db);
		return responseString;
		
	}
	
	//sqlite3_close(db);
	
	return nil;
	
}

- (void) set: (NSString *) cacheKey withValue: (NSString *) value expiresOn: (int) expires {
	
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	
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
	//sqlite3_close(db);
	
}

- (void) clearAll {
	
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	const char *sql = "DELETE FROM cache";
	
	char *db_err = "";
	sqlite3_exec(db, sql, NULL, 0, &db_err);
	//sqlite3_close(db);

}

@end
