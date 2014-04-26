//
//  DQUGame.h
//  Deque
//
//  Created by mdreid 1 on 4/26/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Parse/Parse.h>
#import "DQUHand.h"

@interface DQUGame : PFObject {
    int numPlayers;
}

// name of the class
+ (NSString *)parseClassName;

// make game instance with corresponding game name, owner name and number of players
- (id) initWithGameName: (NSString *) gn OwnerName: (NSString *) on numPlayers: (int) n;

// items in this array should be of type DQUHand
@property (strong, nonatomic) NSMutableArray *hands;
@property (nonatomic) NSString *gameID;
@property (nonatomic) NSString *ownerID;
@property (retain) DQUHand *deck;
@property (retain) DQUHand *discard;

@end
