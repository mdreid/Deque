//
//  DQUCard.h
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//
// Header file for card class

@interface DQUCard : NSObject

@property (readonly) NSString* rank;
@property (readonly) char suit;
@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic, retain) NSString *picName;

-(id) initWithRank:(NSString*)r Suit:(char)s Name:(NSString *)n Pic:(NSString *)p;

@end
