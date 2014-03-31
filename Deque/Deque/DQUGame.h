//
//  DQUGame.h
//  Deque
//
//  Created by Xixia Wang on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQUGame : NSObject

@property (strong) NSString *gameID;
@property (assign) int numPlayers;

- (id)initWithTitle:(NSString*)gameID numPlayers:(int)players;

@end
