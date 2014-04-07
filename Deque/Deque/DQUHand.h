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
    DQUCard *hand[52];
    //@property (readonly) int numCards;
    //NSArray *hand;
}
// name of the class
+ (NSString *)parseClassName;
// take card from another hand and add to current hand
//- (void) takeCard;
// take card from current hand and add to another hand
//- (void) giveCard;

// returns int number of cards
- (int) getCardCount;

-(void) printHand;

@end
