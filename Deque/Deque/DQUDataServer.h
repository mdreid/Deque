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
    
}

// the properties

// the methods

+ (NSMutableDictionary*)allCards;

+ (void) setDictionary:(NSMutableDictionary *)dict;

// retrieve hand from the server.
+ (DQUHand *) retrieveHandWithID:(NSString *)objID;

// update hand on the server.
+ (void) sendHand:(DQUHand *)hand;

// retrieve game from the server.
+ (DQUGame *) retrieveGameWithID:(NSString *)gameID;

// update the hands array on the database.
+ (void)updatePlayersForGameID:(NSString *)gameID forHands:(NSMutableArray *)hands withAvatars:(NSMutableArray *)avs;

// will update everything - deck, discard, table, and hands.
+ (void) updateAllHandsForGame:(DQUGame *)game;

// grabs all the games available on the database thus far.
+ (NSArray *) retrieveAllGames;


@end
