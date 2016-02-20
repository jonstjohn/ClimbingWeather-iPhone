//
//  Favorite.m
//  climbingweather
//
//  Created by Jonathan StJohn on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Favorite.h"
#import "Database.h"


@implementation Favorite

static Favorite *mySharedFavorite = nil;

#pragma mark Singleton Methods
+ (Favorite *)sharedFavorite {
    @synchronized(self) {
        if(mySharedFavorite == nil)
            mySharedFavorite = [[super allocWithZone:NULL] init];
    }
    return mySharedFavorite;
}
+ (Favorite *)allocWithZone:(NSZone *)zone {
    return [mySharedFavorite retain];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (NSUInteger)retainCount {
    return NSUIntegerMax; //denotes an object that cannot be released
}
- (oneway void)release {
    // never release
}
- (id)autorelease {
    return self;
}
- (id)init {
	areas = [[NSMutableArray alloc] init];
	return [super init];
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [super dealloc];
}

- (BOOL) exists:(NSString *) areaId {
	
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	
	char *sql = "SELECT area_id FROM favorite WHERE area_id = ?";
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	sqlite3_bind_int(statement, 1, [areaId intValue]);
	
	while(sqlite3_step(statement) == SQLITE_ROW) {
		
		return YES;
		
	}
	
	//sqlite3_close(db);
	
	return NO;
}

- (void) add:(NSString *)areaId withName:(NSString *)name {
	
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	
	sqlite3_stmt *stmt;
	const char *sql = "REPLACE INTO favorite(area_id, name) VALUES (?, ?)";
	NSLog(@"%s", sql);
	sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
	//sqlite3_bind_text(stmt, 1, [areaId UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(stmt, 1, [areaId intValue]);
	sqlite3_bind_text(stmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
	if (sqlite3_step(stmt) == SQLITE_DONE) {
		NSLog(@"REPLACE INTO succeeded");
	} else {
		NSLog(@"ERROR SAVING: %s", sqlite3_errmsg(db));
	}
	sqlite3_finalize(stmt);
	//sqlite3_close(db);

	
}

- (void) remove:(NSString *)areaId {
	
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	
	sqlite3_stmt *stmt;
	const char *sql = "DELETE FROM favorite WHERE area_id = ?";
	sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
	//sqlite3_bind_text(stmt, 1, [areaId UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(stmt, 1, [areaId intValue]);
	if (sqlite3_step(stmt) == SQLITE_DONE) {
		NSLog(@"DELETE succeeded");
	} else {
		NSLog(@"ERROR DELETING: %s", sqlite3_errmsg(db));
	}
	sqlite3_finalize(stmt);
	//sqlite3_close(db);
	
}

- (NSMutableArray *) getAll
{
	Database *sharedDatabase = [Database sharedDatabase];
	sqlite3 *db = [sharedDatabase open];
	
	char *sql = "SELECT area_id, name FROM favorite ORDER BY name ASC";
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
	
	[areas removeAllObjects];
	
	while(sqlite3_step(statement) == SQLITE_ROW) {
		
		char *cAreaId = (char *) sqlite3_column_text(statement, 0);
		char *cName = (char *) sqlite3_column_text(statement, 1);
		NSString *areaId = [NSString stringWithUTF8String: cAreaId];
		NSString *name = [NSString stringWithUTF8String: cName];
		
		
		[areas addObject: 
			[NSDictionary dictionaryWithObjectsAndKeys: 
				areaId, @"area_id", 
				name, @"name",
				nil
			 ]
		 ];
		
		//char *cResponseString = (char *) sqlite3_column_text(statement, 0);
		//sqlite3_close(db);
		//return YES;
		
	}
	return areas;
}

@end
