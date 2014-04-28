//
//  DQUDataServer.m
//  Deque
//
//  Created by Xixia Wang on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUDataServer.h"
#import <Parse/Parse.h>

@implementation DQUDataServer

- (void) setDictionary:(NSMutableDictionary *)dict
{
    allCards = dict;
}

// Retrieves DQUHand specified by handID in game gameID from database
- (DQUHand *) retrieveHandWithID:(NSString *)objID {
    DQUHand *theHand = nil;
    PFQuery *query = [DQUHand query];
    NSLog(@"the hand ID we're looking for is: %@", objID);
    
    [query whereKey:@"objectId" equalTo:objID];
    NSArray *array = [query findObjects];
    PFObject *hand = array[0];
    
    theHand = [[DQUHand alloc] initWithHandID:[hand objectForKey:@"handID"]];
    theHand.cards = [[hand objectForKey:@"cards"] mutableCopy];
    theHand.objID = [NSString stringWithString:objID];
    
    NSLog(@"found this hand");
    
    return theHand;
}

// sends a hand to database to update it
- (void) sendHand:(DQUHand *)hand
{
    PFQuery *query = [DQUHand query];
    
    NSLog(@"now printing from hand: %@", hand.handID);
    
    [query whereKey:@"objectId" equalTo:hand.objID];
    NSArray *array = [query findObjects];
    PFObject *found = array[0];
    
    found[@"cards"] = [NSArray arrayWithArray:hand.cards];
    
    [found save];

}

- (DQUGame *) retrieveGameWithID:(NSString *)gameID
{
    PFQuery *query = [DQUGame query];
    
    // this will be the game we ultimately return which will be completely filled in.
    DQUGame *game = nil;
    [query whereKey:@"gameID" equalTo:gameID];
    
    NSArray* objects = [query findObjects];
    NSUInteger count = [objects count];
    if (count == 0) {
        NSLog(@"%@ could not be found.", gameID);
        return nil;
    }
    
    // actually found something. just assume there can only be one.
    PFObject *object = objects[0];
    NSString *ownerName = [object objectForKey:@"ownerID"];
    
    game = [[DQUGame alloc] initWithoutInfo];
    game.gameID = [NSString stringWithString:gameID];
    game.ownerID = [NSString stringWithString:ownerName];
    game.numPlayers = [object objectForKey:@"numPlayers"];
    game.numHands = [object objectForKey:@"numHands"];
    game.objID = [NSString stringWithString:object.objectId];
    
    // need to grab the hands, the deck, and discard.
    PFObject *objDeck = [object objectForKey:@"deck"];
    PFObject *objDiscard = [object objectForKey:@"discard"];
    NSArray *currHands = [object objectForKey:@"hands"];
    
    PFQuery *handsQuery = [DQUHand query];
    [handsQuery whereKey:@"objectId" equalTo:objDeck.objectId];
    NSArray* hand = [handsQuery findObjects];
    PFObject *obj = hand[0];
    
    game.deck = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
    game.deck.cards = [[obj objectForKey:@"cards"] mutableCopy];
    game.deck.objID = [NSString stringWithString:obj.objectId];
    
    [handsQuery whereKey:@"objectId" equalTo:objDiscard.objectId];
    hand = [handsQuery findObjects];
    obj = hand[0];
    
    game.discard = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
    game.discard.cards = [[obj objectForKey:@"cards"] mutableCopy];
    game.discard.objID = [NSString stringWithString:obj.objectId];
    
    for (PFObject *h in currHands) {
        [handsQuery whereKey:@"objectId" equalTo:h.objectId];
        hand = [handsQuery findObjects];
        obj = hand[0];
        
        DQUHand *curr = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
        curr.cards = [[obj objectForKey:@"cards"] mutableCopy];
        curr.objID = [NSString stringWithString:obj.objectId];
        [game.hands addObject:curr];
    }
    
    return game;

}

- (void)updatePlayersForGameID:(NSString *)gameID forHands:(NSMutableArray *)hands
{
    PFQuery *query = [DQUGame query];
    
    // this will be the game we ultimately return which will be completely filled in.
    [query whereKey:@"gameID" equalTo:gameID];
    
    NSArray *array = [query findObjects];
    PFObject *found = array[0];
    
    found[@"hands"] = [NSArray arrayWithArray:hands];
    
    [found save];

}

// sends a game to the database
- (void) sendGame:(DQUGame *)game;
{
    
}

// Prints additional information for debugging
+ (void) printDebugInfo:(NSError *)e {
    NSLog(@"Description: %@\n", [e localizedDescription]);
    NSLog(@"Failure reason: %@\n", [e localizedFailureReason]);
    NSLog(@"Suggestion: %@\n", [e localizedRecoverySuggestion]);
}

@end
