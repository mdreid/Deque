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
    NSString *suffix;
}

// items in this array should be of DQUCard
@property (strong, nonatomic) NSMutableArray *cards;
@property (retain) NSString *handID;
@property (retain) NSString *objID;

// initialize a hand with the name 'something'
- (id) initWithHandID:(NSString*) handName;

// returns int of number of cards.
- (int) getCardCount;

// returns the handID. prob will not need later on...gotta think on this.
- (NSString*) getHandID;

// print the cards in this hand.
- (void) printCards:(NSMutableDictionary *)allCards;

// add a card to the hand.
- (void) addCard:(int)i;

- (int) drawCard;

// remove a card in the hand.
- (void) removeCardAtIndex:(int)i;

// return and remove the card in the hand at that index.
- (int)grabAndRemoveCardAtIndex:(int)i;

- (void)shuffle;

- (void)saveOwnObjID;

- (void)saveAsObjectID:(NSString*)objID;

- (void)printID;

- (BOOL) isDisplayHand;

// name of the class
+ (NSString *)parseClassName;



// take card from another hand and add to current hand
//- (void) takeCard;
// take card from current hand and add to another hand
//- (void) giveCard;

@end
