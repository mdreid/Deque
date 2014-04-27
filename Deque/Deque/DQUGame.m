//
//  DQUGame.m
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"

int numHands; // current number of hands
int maxHands; // max number of hands
int numCards = 52; // number of cards in deck
NSString *suffix = @"_disp";


@implementation DQUGame
@dynamic deck;
@dynamic discard;
@dynamic ownerID;
@dynamic gameID;
@dynamic hands;

+ (NSString *)parseClassName {
    return @"DQUHand";
}

- (id) initWithGameName: (NSString *) gn OwnerName: (NSString *) on numPlayers: (int) n {
    
    self = [super init];
    
    if (self) {
        // set game name
        self.gameID = gn;
    
        // set owner name
        self.ownerID = on;
    
        // set number of players
        numPlayers = n;
        maxHands = (numPlayers * 2) + 2;
        numHands = 2;
    
        // build deck
        DQUHand *dk = [[DQUHand alloc] initWithHandID:@"deck"];
        for (int i = 0; i < numCards; i++) {
            [dk addCard:i];
        }
        [dk shuffle];
        self.deck = dk;
    
        // initialize discard
        DQUHand *ds = [[DQUHand alloc] initWithHandID:@"discard"];
        self.discard = ds;
    
        // make hands array and add host player
        NSMutableArray* array = [[NSMutableArray alloc] init];
        DQUHand *p1 = [[DQUHand alloc] initWithHandID:[on copy]];
        DQUHand *p1d = [[DQUHand alloc] initWithHandID:[on stringByAppendingString:suffix]];
        [array addObject:p1];
        [array addObject:p1d];
        self.hands = array;
    }
    return self;
}

// add a player to the game (both display hand and personal hand)
- (void) addPlayer:(NSString *)playerName {
    if (numHands < maxHands) {
        DQUHand *p = [[DQUHand alloc] initWithHandID:[playerName copy]];
        DQUHand *pd = [[DQUHand alloc] initWithHandID:[playerName stringByAppendingString:suffix]];
        [self.hands addObject:p];
        [self.hands addObject:pd];
        numHands = numHands + 2;
    }
}

@end
