//
//  DQUGame.m
//  Deque
//
//  Created by Xixia Wang on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGame.h"

@implementation DQUGame

@synthesize gameID = _gameID;
@synthesize numPlayers = _numPlayers;

- (id)initWithTitle:(NSString*)gameID numPlayers:(int)players {
    if ((self = [super init])) {
        self.gameID = gameID;
        self.numPlayers = players;
    }
    return self;
}

@end
