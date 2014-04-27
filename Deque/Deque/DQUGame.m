//
//  DQUGame.m
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"
#import <Parse/PFObject+Subclass.h>
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
    return @"DQUGame";
}

- (id) initWithGameName: (NSString *) gn OwnerName: (NSString *) on numPlayers: (int) n {
    
    self = [super init];
    
    if (self) {
        // set game name
        self.gameID = gn;
    
        // set owner name
        self.ownerID = on;
    
        // set number of players
        self.numPlayers = [NSNumber numberWithInt:n];
        
        // initialize hands
        NSMutableArray* array = [[NSMutableArray alloc] init];
        self.hands = array;
    
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
