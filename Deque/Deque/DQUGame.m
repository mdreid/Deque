//
//  DQUGame.m
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"

@implementation DQUGame

@synthesize deck = _deck;
@synthesize discard = _discard;
@synthesize ownerID = _ownerID;
@synthesize gameID = _gameID;
@synthesize hands = _hands;

int numCards = 52;
+ (NSString *)parseClassName {
    return @"DQUHand";
}

- (id) initWithGameName: (NSString *) gn OwnerName: (NSString *) on numPlayers: (int) n {
    
    self = [super init];
    
    // set game name
    _gameID = gn;
    
    // set owner name
    _ownerID = on;
    
    // set number of players
    numPlayers = n;
    
    // build deck
    DQUHand *dk = [[DQUHand alloc] initWithHandID:@"deck"];
    for (int i = 0; i < numCards; i++) {
        [dk addCard:i];
    }
    [dk shuffle];
    _deck = dk;
    
    // initialize discard
    DQUHand *ds = [[DQUHand alloc] initWithHandID:@"discard"];
    _discard = ds;
    
    // make hands array
    NSMutableArray* array = [[NSMutableArray alloc] init];
    DQUHand *r1 = [[DQUHand alloc] initWithHandID:@"r1"];
    DQUHand *r2 = [[DQUHand alloc] initWithHandID:@"r2"];
    [array addObject:r1];
    [array addObject:r2];
    _hands = array;
    return self;
}
@end
