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
- (DQUHand *) retrieveHandWithID:(NSString *)handID forGameID:(NSString *)gameID;

// update hand on the server.
- (void) sendHand:(DQUHand *)hand forGameID:(NSString *)gameID;

// retrieve game from the server.
// will ultimately be:
// - (DQUGame *) retrieveGameWithID:(NSSTring *)gameID;
- (void) retrieveGameWithID:(NSString *)gameID;

// will ultimately be:
// - (void) sendGame:(DQUGame *)game;
- (void) sendGame;


@end
