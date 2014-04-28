//
//  DQUDataServer.h
//  Deque
//
//  Created by Xixia Wang on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQUGame.h"

@interface DQUDataServer : NSObject {
    NSMutableDictionary *allCards;
}

// the properties

// the methods

- (void) setDictionary:(NSMutableDictionary *)dict;

// retrieve hand from the server.
- (DQUHand *) retrieveHandWithID:(NSString *)objID;

// update hand on the server.
- (void) sendHand:(DQUHand *)hand;

// retrieve game from the server.
- (DQUGame *) retrieveGameWithID:(NSString *)gameID;

// update the hands array on the database.
- (void)updatePlayersForGameID:(NSString *)gameID forHands:(NSMutableArray *)hands;


- (void) sendGame:(DQUGame *) game;


@end
