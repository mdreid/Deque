//
//  DQUHand.m
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUHand.h"
#import <Parse/PFObject+Subclass.h>

//#define DECK_SZ 52;

@implementation DQUHand
@dynamic cards;
@dynamic handID;
@dynamic objID;

+ (NSString *)parseClassName {
    return @"DQUHand";
}

// cards is simply going to be an array of indices.
-(id)initWithHandID:(NSString*) handName {
    self = [super init];
    
     suffix = @"_disp";
    
    if (self) {
        self.cards = [[NSMutableArray alloc] init];
        self.handID = [NSString stringWithString:handName];
    }
    
    return self;
}

-(int)getCardCount {
    return (int)[self.cards count];
}

-(NSString *)getHandID {
    return self.handID;
}

- (BOOL) isDisplayHand {
    return ([self.handID rangeOfString:suffix].location == NSNotFound);
}

-(void)printCards:(NSMutableDictionary *)allCards {
    int count = [self getCardCount];
    for (int i = 0; i < count; i++) {
        int ind = [self.cards[i] intValue];
        DQUCard* currCard = allCards[[NSNumber numberWithInt:ind]];
        
        NSLog(@"Rank: %@, Suit: %c", [currCard rank], [currCard suit]);
    }
}

// objects will all be NSNumbers.
-(void)addCard:(int)i
{
    NSNumber* ind = [NSNumber numberWithInt:i];
    [self.cards addObject:ind];
}

-(void)removeCardAtIndex:(int)i
{
    [self.cards removeObjectAtIndex:i];
}

-(int)drawCard
{
    int retInd = [self.cards[0] intValue];
    [self.cards removeObjectAtIndex:0];
    
    return retInd;
}

-(int)grabAndRemoveCardAtIndex:(int)i
{
    int retInd = [self.cards[i] intValue];
    [self.cards removeObjectAtIndex:i];
    
    return retInd;
}

- (void)shuffle
{
    NSUInteger count = [self.cards count];
    for (NSUInteger i = 0; i < count; i++) {
        // select a random element between i and end of array to swap with
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((int)nElements) + i;
        
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void)saveOwnObjID
{
    self.objID = self.objectId;
}

- (void)saveAsObjectID:(NSString*)objID
{
    self.objID = [NSString stringWithString:objID];
}

- (void)printID
{
    NSLog(@"%@ has object ID: %@", self.handID, self.objID);
}

// give card from own hand and place it in Hand other
//-(void)giveCard:(DQUHand*)other: {
    
//}

// take card from Hand other and place it in own hand
//-(void)takeCard:(DQUHand*) other:(DQUCard*) card {
    
//}
@end
