//
//  Favorite.h
//  climbingweather
//
//  Created by Jonathan StJohn on 2/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Favorite : NSObject {

}

+ (Favorite *) sharedFavorite;
- (BOOL) exists: (NSString *) areaId;
- (void) add: (NSString *) areaId withName: (NSString *) name;
- (void) remove: (NSString *) areaId;
- (NSMutableArray *) getAll;

@end
