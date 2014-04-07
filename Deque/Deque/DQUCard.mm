//
//  DQUCard.m
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//
// Implementation file for card class

#import "DQUCard.h"
#import <Parse/PFObject+Subclass.h>
#import <stdlib.h>

@implementation DQUCard
@synthesize rank;
@synthesize suit;
@synthesize text;
// Initializer sets rank and suit
-(id) initWithRank:(int)r Suit:(char)s {
    self = [super init];
    rank = r;
    suit = s;
    return self;
}
// Initializer sets text
-(id) initWithText:(NSString *)string {
    self = [super init];
    text = string;
    return self;
}
+(NSString *)parseClassName {
    return @"Card";
}
@end
