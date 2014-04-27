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
    PFQuery *query = [DQUHand query];
    NSLog(@"the hand ID we're looking for is: %@", handID);
    [query whereKey:@"handID" equalTo:handID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSLog(@"successfully retrieved %lu objects.", (unsigned long) objects.count);
            
            for (PFObject *object in objects) {
                NSLog(@"one item found.");
            }
        }
        else {
            NSLog(@"OHSHIT ERROR.");
        }
    }];
    
    
    
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

- (void) retrieveGameWithID:(NSString *)gameID
{
    
}

- (void) sendGame
{
    
}

@end
