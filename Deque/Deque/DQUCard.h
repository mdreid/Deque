//
//  DQUCard.h
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//
// Header file for card class

#import <Parse/Parse.h>


@interface DQUCard : PFObject<PFSubclassing>

@property (readonly) int rank;
@property (readonly) char suit;
@property (readonly, nonatomic, retain) NSString *text;

+ (NSString *)parseClassName;
-(id) initWithRank:(int)r Suit:(char)s;
-(id) initWithText:(NSString *)string;

@end
