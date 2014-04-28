//
//  DQUDataServer.h
//  Deque
//
//  Created by Xixia Wang on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQUGame.h"

@interface DQUDataServer : NSObject


// the properties

// the methods

// retrieve hand from the server.
- (DQUHand *) retrieveHandWithID:(NSString *)objID;

// update hand on the server.
- (void) sendHand:(DQUHand *)hand forGameID:(NSString *)gameID;

// retrieve game from the server.
- (DQUGame *) retrieveGameWithID:(NSString *)gameID forGame:(DQUGame *)theGame;

- (void) sendGame:(DQUGame *) game;


@end
