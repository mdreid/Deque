//
//  DQUDataServer.h
//  Deque
//
//  Created by Xixia Wang on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQUHand.h"

@interface DQUDataServer : NSObject


// the properties

// the methods

// retrieve hand from the server.
- (DQUHand *) retrieveHandWithID:(NSString *)handID;

// retrieve game from the server.
- (void) retrieveGameWithID:(NSString *)gameID;


@end
