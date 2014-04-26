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
@synthesize name;
@synthesize picName;

// Initializer sets rank and suit
-(id) initWithRank:(NSString *)r Suit:(char)s Name:(NSString*)n Pic:(NSString *)p  {
    self = [super init];
    
    if (self) {
        rank = [r copy];
        suit = s;
        name = [n copy];
        picName = [p copy];
    }
    return self;
}

@end
