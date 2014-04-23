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

@implementation DQUHand

@dynamic cards;
@dynamic handID;
@dynamic numCards;

+ (NSString *)parseClassName {
    return @"DQUHand";
}

-(id)init {
    self = [super init];
    
    static int ind = 0;
    
    self.cards = [[NSMutableArray alloc] init];
    self.numCards = 0;
    self.handID = [NSString stringWithFormat:@"%d", ind++];
    
//    int count = 0;
//    for (int i = 0; i <= 3; i++) {
//        for (int j = 1; j <= 13; j++) {
//            DQUCard *card = [[DQUCard alloc] initWithRank:i Suit:j];
//            hand[count] = card;
//            //[card saveInBackground];
//            count++;
//        }
//    }
//    numCards = count;
    return self;
}

-(int)getCardCount {
    return self.numCards;
}

-(NSString *)getHandID {
    return self.handID;
}

-(void)printCards {
    for (int i = 0; i < self.numCards; i++) {
        NSLog(@"Rank: %@, Suit: %c", [(DQUCard*)self.cards[i] rank], [(DQUCard*)self.cards[i] suit]);
    }
}

-(void)addCard:(DQUCard*)c
{
    [self.cards addObject:c];
    self.numCards++;
}

-(void)removeCardAtIndex:(int)i
{
    [self.cards removeObjectAtIndex:i];
    self.numCards--;
}

-(DQUCard *)grabAndRemoveCardAtIndex:(int)i
{
    DQUCard *retCard = self.cards[i];
    [self.cards removeObjectAtIndex:i];
    self.numCards--;
    
    return retCard;
}

// give card from own hand and place it in Hand other
//-(void)giveCard:(DQUHand*)other: {
    
//}

// take card from Hand other and place it in own hand
//-(void)takeCard:(DQUHand*) other:(DQUCard*) card {
    
//}
@end
