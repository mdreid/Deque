//
//  DQUGame.m
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"

@implementation DQUGame

@dynamic deck;
@dynamic discard;
@dynamic ownerID;
@dynamic gameID;
@dynamic hands;

int numHands;
int maxHands;
int numCards = 52;
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
    
        // make hands array
        NSMutableArray* array = [[NSMutableArray alloc] init];
        DQUHand *r1 = [[DQUHand alloc] initWithHandID:@"r1"];
        DQUHand *r2 = [[DQUHand alloc] initWithHandID:@"r2"];
        [array addObject:r1];
        [array addObject:r2];
        self.hands = array;
    }
    return self;
}

- (void) addPlayer:(NSString *)playerName {
    if (numHands < maxHands) {
        NSString *suffix = @"_disp";
        DQUHand *p = [[DQUHand alloc] initWithHandID:[playerName copy]];
        DQUHand *pd = [[DQUHand alloc] initWithHandID:[playerName stringByAppendingString:suffix]];
        [self.hands addObject:p];
        [self.hands addObject:pd];
        numHands = numHands + 2;
    }
}

@end
