//
//  DQUHand.h
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <Parse/Parse.h>
#import "DQUCard.h"

@interface DQUHand : PFObject<PFSubclassing> {
//    DQUCard *hand[52];
    //@property (readonly) int numCards;
    //NSArray *hand;
    int numCards;
    NSString* handID;
}

// items in this array should be of DQUCard
@property (strong, nonatomic) NSMutableArray *cards;

// returns int of number of cards.
-(int) getCardCount;

-(NSString*) getHandID;

// print the cards in this hand.
-(void) printCards;

// add a card to the hand.
-(void) addCard:(DQUCard*)c;

// remove a card in the hand.
-(void) removeCardAtIndex:(int)i;

// return and remove the card in the hand at that index.
-(DQUCard *)grabAndRemoveCardAtIndex:(int)i;

// name of the class
+ (NSString *)parseClassName;



// take card from another hand and add to current hand
//- (void) takeCard;
// take card from current hand and add to another hand
//- (void) giveCard;

@end
