//
//  DQUHand.m
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUCard.h"
#import "DQUHand.h"
#import <Parse/PFObject+Subclass.h>

//#define DECK_SZ 52;

@implementation DQUHand {
    int numCards;
}

+ (NSString *)parseClassName {
    return @"DQUHand";
}

-(id)init {
    self = [super init];
    int count = 0;
    for (int i = 0; i <= 3; i++) {
        for (int j = 1; j <= 13; j++) {
            DQUCard *card = [[DQUCard alloc] initWithRank:i Suit:j];
            hand[count] = card;
            //[card saveInBackground];
            count++;
        }
    }
    numCards = count;
    return self;
}

-(int)getCardCount {
    return numCards;
}

-(void)printHand {
    for (int i = 0; i < numCards; i++) {
        NSLog(@"Rank: %d, Suit: %d", hand[i].rank, hand[i].suit);
    }
}

// give card from own hand and place it in Hand other
//-(void)giveCard:(DQUHand*)other: {
    
//}

// take card from Hand other and place it in own hand
//-(void)takeCard:(DQUHand*) other:(DQUCard*) card {
    
//}
@end
