//
//  Database.h
//  climbingweather
//
//  Created by Jonathan StJohn on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface Database : NSObject {

	sqlite3 *database;
}

@property (nonatomic, assign) sqlite3 *database;

+ (Database *) sharedDatabase;
- (sqlite3 *) open;

@end
