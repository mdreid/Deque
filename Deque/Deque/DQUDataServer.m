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

- (DQUHand *) retrieveHandWithID:(NSString *)handID forGameID:(NSString *)gameID
{
    __block DQUHand *theHand = nil;
    PFQuery *query = [DQUGame query];
    NSLog(@"the hand ID we're looking for is: %@", handID);
    NSLog(@"the game ID we're looking for is: %@", gameID);
    
    [query whereKey:@"gameID" equalTo:gameID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"successfully retrieved %lu objects.", (unsigned long) objects.count);
            PFObject *object = objects[0];
            
            // this will be an array of pfObjects.
            NSArray *hands = [object objectForKey:@"hands"];
            
            for (PFObject* h in hands) {
                // need to find this hand
                PFQuery *queryCard = [DQUHand query];
                [queryCard getObjectWithId:h.objectId];
                
                
                NSString *temp = [h objectForKey:@"handID"];
                if (temp == handID) {
                    theHand = [[DQUHand alloc] initWithHandID:temp];
                    theHand.cards = [[theHand objectForKey:@"cards"] mutableCopy];
                    break;
                }
            }
        }
        else {
            NSLog(@"OHSHIT ERROR.");
        }
    }];
    
    return theHand;
    
    
    
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

- (void) sendHand:(DQUHand *)hand forGameID:(NSString *)gameID
{
    
}

- (DQUGame *) retrieveGameWithID:(NSString *)gameID
{
    PFQuery *query = [DQUGame query];
    NSLog(@"the game ID we're looking for is: %@", gameID);
    
    __block DQUGame *game = nil;
    
    [query whereKey:@"gameID" equalTo:gameID];
    
    @property (nonatomic) NSMutableArray *hands;
    @property DQUHand *deck;
    @property DQUHand *discard;
    @property NSNumber *numHands;
    @property (retain) NSString *objID;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSUInteger count = objects.count;
            if (count == 0) {
                NSLog(@"%@ could not be found.", gameID);
                return;
            }
            
            // actually found something. just assume there can only be one.
            PFObject *object = objects[0];
            NSString *ownerName = [object objectForKey:@"ownerID"];
            NSNumber *numPlayers = [object objectForKey:@"numPlayers"];
            
            game = [[DQUGame alloc] initWithGameName:gameID numPlayers:[numPlayers intValue]];
            game.ownerID = ownerName;
            game.numHands = [object objectForKey:@"numHands"];
            
            // need to grab the hands, the deck, and discard.
            PFObject *objDeck = [object objectForKey:@"deck"];
            PFObject *objDiscard = [object objectForKey:@"discard"];
            
            NSArray *currHands = [object objectForKey:@"hands"];
            
            PFQuery *handsQuery = [DQUHand query];
            
            // load in the deck.
            [handsQuery getObjectInBackgroundWithId:objDeck.objectId block:^(PFObject *obj, NSError *error) {
                if (!error) {
                    game.deck = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
                    game.deck.cards = [[obj objectForKey:@"cards"] mutableCopy];
                }
                else {
                    NSLog(@"error within query for deck.");
                }
            }];
            
            // load in the discard deck.
            [handsQuery getObjectInBackgroundWithId:objDiscard.objectId block:^(PFObject *obj, NSError *error) {
                if (!error) {
                    game.discard = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
                    game.discard.cards = [[obj objectForKey:@"cards"] mutableCopy];
                }
                else {
                    NSLog(@"error within query for discard deck.");
                }
            }];
            
            for (PFObject *h in currHands) {
                [handsQuery getObjectInBackgroundWithId:h.objectId block:^(PFObject *obj, NSError *error) {
                    if (!error) {
                        DQUHand *curr = [[DQUHand alloc] initWithHandID:[obj objectForKey:@"handID"]];
                        curr.cards = [[obj objectForKey:@"cards"] mutableCopy];
                    }
                    else {
                        NSLog(@"error within query for hands.");
                    }
                }];
            }
            
        }
        else {
            NSLog(@"SHIT HAPPENED");
        }
    }];
    
    return game;

}

- (void) sendGame:(DQUGame *)game;
{
    
}

@end
