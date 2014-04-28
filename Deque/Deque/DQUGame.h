//
//  DQUGame.h
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Parse/Parse.h>
#import "DQUHand.h"

@interface DQUGame : PFObject<PFSubclassing>

// name of the class
+ (NSString *)parseClassName;

// make generic game instance
- (id) init;

// make game instance with corresponding game name, owner name, and number of players and deck
- (id) initWithDeckandGameName: (NSString *) gn OwnerName: (NSString *) on numPlayers: (int) n;

// add player
- (void) addPlayer: (NSString *) playerName;

// print game according to dictionary dict
- (void) printGame: (NSMutableDictionary*) dict;

// draw from deck
- (void) drawFromDeck: (NSString *) handID;

// items in this array should be of type DQUHand
@property (nonatomic) NSMutableArray *hands;
@property (nonatomic) NSString *gameID;
@property (nonatomic) NSString *ownerID;
@property DQUHand *deck;
@property DQUHand *discard;
@property NSNumber *numPlayers;
@property NSNumber *numHands;
@property NSString *objID;

@end
