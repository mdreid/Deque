//
//  DQUGame.m
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"
#import <Parse/PFObject+Subclass.h>

int numCards = 52; // number of cards in deck
NSString *suffix = @"_disp";

@implementation DQUGame
@dynamic deck;
@dynamic discard;
@dynamic table;
@dynamic ownerID;
@dynamic gameID;
@dynamic hands;
@dynamic numPlayers;
@dynamic numHands;
@dynamic objID;

+ (NSString *)parseClassName {
    return @"DQUGame";
}

// Basic instance of the class
- (id) initWithoutInfo {
    
    self = [super init];
    
    if (self) {
        self.gameID = nil;
        self.deck = nil;
        self.discard = nil;
        self.ownerID = nil;
        self.table = nil;
        self.numPlayers = nil;
        self.numHands = nil;
        self.objID = nil;
        
        // make hands array
        NSMutableArray* array = [[NSMutableArray alloc] init];
        self.hands = array;
        
    }
    return self;
}


// Client-side-->DB
// This is the real initialization (ya'll others are just copying #oftenimitatedneverduplicated)
- (id) initWithDeckandGameName:(NSString *)gn OwnerName:(NSString *)on numPlayers:(int)n {
    
    self = [super init];
    
    if (self) {
        __block DQUGame *useSelf = self;
        
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
        
        // initialize table
        DQUHand *t = [[DQUHand alloc] initWithHandID:@"table"];
        self.table = t;
        
        // make hands array
        NSMutableArray* array = [[NSMutableArray alloc] init];
        self.hands = array;
        
        // make owner's own hands
        DQUHand *o = [[DQUHand alloc] initWithHandID:[on copy]];
        DQUHand *od = [[DQUHand alloc] initWithHandID:[on stringByAppendingString:suffix]];
        [self.hands addObject:o];
        [self.hands addObject:od];
        self.numHands = [NSNumber numberWithInt:2];
        
        // save
//        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (!error) {
//                [useSelf.deck saveOwnObjID];
////                [useSelf.deck printID];
//                [useSelf.discard saveOwnObjID];
////                [useSelf.discard printID];
//                
//                for (DQUHand *h in useSelf.hands) {
//                    [h saveOwnObjID];
////                    [h printID];
//                }
//                
//            }
//            else {
//                NSLog(@"error in callback for save.");
//            }
//        }];
        
    }
    return self;
}

// add a player to the game (both display hand and personal hand)
- (void) addPlayer:(NSString *)playerName {
    int nh = [self.numHands intValue];
    int maxHands = [self.numPlayers intValue] * 2;
    if (nh < maxHands) {
        __block DQUHand *p = [[DQUHand alloc] initWithHandID:[playerName copy]];
        __block DQUHand *pd = [[DQUHand alloc] initWithHandID:[playerName stringByAppendingString:suffix]];
        [self.hands addObject:p];
        [self.hands addObject:pd];
        int val = [self.numHands intValue];
        self.numHands = [NSNumber numberWithInt:val+2];
        
        [p saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [p saveOwnObjID];
            }
            else {
                NSLog(@"Something happened in trying to save hand from adding a player.");
            }
        }];
        
        [pd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [pd saveOwnObjID];
            }
            else {
                NSLog(@"Something happened in trying to save hand from adding a player.");
            }
        }];
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
        [self.hands[i] printID];
    }
}

// draws card from deck and adds it to hand specified by handID
- (void) drawFromDeck:(NSString *)handID {
    if ([self isEmpty:@"deck"]) {
        NSLog(@"No cards left in deck!");
    }
    int c = [self.deck grabAndRemoveCardAtIndex:0];
    int h = [self findHandIndex:handID];
    [self.hands[h] addCard:c];
}

- (int) findHandIndex:(NSString *)handID {
    for (int i = 0; i < [self.hands count]; i++) {
        DQUHand *h = self.hands[i];
        if ([h.handID isEqualToString:handID]) {
            return i;
        }
    }
    return -1; // hand not found
}

// returns whether hand specified by handID is empty
- (BOOL) isEmpty:(NSString *)handID {
    if ([handID isEqualToString:@"deck"]) {
        return [self.deck getCardCount] == 0;
    }
    if ([handID isEqualToString:@"discard"]) {
        return [self.discard getCardCount] == 0;
    }
    
    int c = [self findHandIndex:handID];
    return [self.hands[c] getCardCount] == 0;
}


// deal num per hands cards
- (void) dealCards:(int)numPerHand {
    for (int i = 0; i < [self.hands count]; i++) {
        if (![self.hands[i] isDisplayHand]) {
            for (int j = 0; j < numPerHand; j++) {
                [self drawFromDeck:[self.hands[i] getHandID]];
            }
        }
    }
}

- (void) giveCard:(NSString *)src :(NSString *)dst :(int)index { // src is person giving
    int s = [self findHandIndex:src];
    int d = [self findHandIndex:dst];
    int c = [self.hands[s] grabAndRemoveCardAtIndex:index];
    [self.hands[d] addCard:c];
}

- (void) takeCard:(NSString *)from :(NSString *)to :(int)index {
    [self giveCard:from:to:index];
}

@end
