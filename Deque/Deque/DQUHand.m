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

@synthesize cards;

+ (NSString *)parseClassName {
    return @"DQUHand";
}

-(id)init {
    self = [super init];
    
    static int ind = 0;
    
    cards = [[NSMutableArray alloc] init];
    numCards = 0;
    handID = [NSString stringWithFormat:@"%d", ind++];
    
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
    return numCards;
}

-(NSString *)getHandID {
    return handID;
}

-(void)printCards {
    for (int i = 0; i < numCards; i++) {
        NSLog(@"Rank: %@, Suit: %c", [(DQUCard*)cards[i] rank], [(DQUCard*)cards[i] suit]);
    }
}

-(void)addCard:(DQUCard*)c
{
    [cards addObject:c];
    numCards++;
}

-(void)removeCardAtIndex:(int)i
{
    [cards removeObjectAtIndex:i];
    numCards--;
}

-(DQUCard *)grabAndRemoveCardAtIndex:(int)i
{
    DQUCard *retCard = cards[i];
    [cards removeObjectAtIndex:i];
    numCards--;
    
    return retCard;
}

// give card from own hand and place it in Hand other
//-(void)giveCard:(DQUHand*)other: {
    
//}

// take card from Hand other and place it in own hand
//-(void)takeCard:(DQUHand*) other:(DQUCard*) card {
    
//}
@end
