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

// Retrieves DQUHand specified by handID in game gameID from database
- (DQUHand *) retrieveHandWithID:(NSString *)objID {
    __block DQUHand *theHand = nil;
    PFQuery *query = [DQUGame query];
    NSLog(@"the hand ID we're looking for is: %@", objID);
//    
//    [query whereKey:@"gameID" equalTo:gameID];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            NSLog(@"successfully retrieved %lu objects.", (unsigned long) [objects count]);
//            PFObject *object = objects[0];
//            
//            // this will be an array of pfObjects.
//            NSArray *hands = [object objectForKey:@"hands"];
//            
//            for (PFObject* h in hands) {
//                // need to find this hand
//                PFQuery *queryCard = [DQUHand query];
//                [queryCard getObjectWithId:h.objectId];
//                
//                
//                NSString *temp = [h objectForKey:@"handID"];
//                if (temp == handID) {
//                    theHand = [[DQUHand alloc] initWithHandID:temp];
//                    theHand.cards = [[theHand objectForKey:@"cards"] mutableCopy];
//                    break;
//                }
//            }
//        }
//        else {
//            NSLog(@"OHSHIT ERROR.");
//            [DQUDataServer printDebugInfo:error];
//        }
//    }];
//    
//    return theHand;
    
    
    
    // code to store something on database, and grab it back from db
    //    DQUHand *deck = [[DQUHand alloc] init];
    //    [deck saveInBackground];
    //
    //    PFQuery *query = [PFQuery queryWithClassName:@"DQUHand"];
    //    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //        if (!error) {
    //            // The find succeeded.
    //            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
    //            // Do something with the found objects
    ////            for (PFObject *object in objects) {
    ////                DQUHand *h = (DQUHand *)object;
    ////                [h printHand];
    ////                NSLog(@"%@", object.objectId);
    ////            }
    //        } else {
    //            // Log details of the failure
    //            NSLog(@"Error: %@ %@", error, [error userInfo]);
    //        }
    //    }];
    

    
    return [[DQUHand alloc] init];
}

// sends a hand to database to update it
- (void) sendHand:(DQUHand *)hand forGameID:(NSString *)gameID
{
    
}

- (DQUGame *) retrieveGameWithID:(NSString *)gameID forGame:(DQUGame *)theGame
{
    PFQuery *query = [DQUGame query];
    NSLog(@"the game ID we're looking for is: %@", gameID);
    
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
    NSLog(@"grabbed deck.");
    
    [handsQuery whereKey:@"objectId" equalTo:objDiscard.objectId];
    hand = [handsQuery findObjects];
    obj = hand[0];
    
    game.discard = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
    game.discard.cards = [[obj objectForKey:@"cards"] mutableCopy];
    game.discard.objID = [NSString stringWithString:obj.objectId];
    NSLog(@"grabbed discard.");
    
    for (PFObject *h in currHands) {
        [handsQuery whereKey:@"objectId" equalTo:h.objectId];
        hand = [handsQuery findObjects];
        obj = hand[0];
        
        DQUHand *curr = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
        curr.cards = [[obj objectForKey:@"cards"] mutableCopy];
        curr.objID = [NSString stringWithString:obj.objectId];
        [game.hands addObject:curr];
        NSLog(@"grabbed hand");
    }
    
    return game;

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
