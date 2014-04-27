//
//  DQUGame.m
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"
#import <Parse/Parse.h>

int maxHands;
int numCards = 52; // number of cards in deck
NSString *suffix = @"_disp";


@implementation DQUGame
@dynamic deck;
@dynamic discard;
@dynamic ownerID;
@dynamic gameID;
@dynamic hands;
@dynamic numPlayers;
@dynamic numHands;

+ (NSString *)parseClassName {
    return @"DQUHand";
}

- (id) initWithGameName: (NSString *) gn numPlayers: (int) n {
    
    self = [super init];
    
    if (self) {
        // set game name
        self.gameID = gn;
    
        // set number of players
        self.numPlayers = [NSNumber numberWithInt:n];
        
        // initialize hands
        NSMutableArray* array = [[NSMutableArray alloc] init];
        self.hands = array;
    
    }
    return self;
}

- (id) initWithDeckandGameName:(NSString *)gn OwnerName:(NSString *)on numPlayers:(int)n {

    self = [super init];
    
    if (self) {
        self.gameID = gn;
        self.ownerID = on;
        self.numPlayers = [NSNumber numberWithInt:n];
        
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
        
    }
    return self;
}

// add a player to the game (both display hand and personal hand)
- (void) addPlayer:(NSString *)playerName {
    int nh = [self.numHands intValue];
    if (nh < maxHands) {
        DQUHand *p = [[DQUHand alloc] initWithHandID:[playerName copy]];
        DQUHand *pd = [[DQUHand alloc] initWithHandID:[playerName stringByAppendingString:suffix]];
        [self.hands addObject:p];
        [self.hands addObject:pd];
        int val = [self.numHands intValue];
        self.numHands = [NSNumber numberWithInt:val+2];
    }

}

// print game according to dictionary dict
- (void) printGame: (NSMutableDictionary*) dict {
    // print basic gameInfo
    NSLog(@"Game ID: %@\n", self.gameID);
    NSLog(@"Owner ID: %@\n", self.ownerID);
    NSLog(@"Hands: ");
    for (int i = 0; i < [self.hands count]; i++) {
        [self.hands[i] printCards:dict];
    }
}

@end
