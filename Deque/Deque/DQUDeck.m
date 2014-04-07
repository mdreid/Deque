//
//  DQUDeck.m
//  Deque
//
//  Created by mdreid 1 on 3/31/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUDeck.h"
#include <stdlib.h>

@implementation DQUDeck

// implements Fisher-Yates shuffle to shuffle the Deck
-(void)shuffle
{
    int sz = 5;//[cards count]
    for (int i = sz-1; i >= 0; i--) {
        //int j = arc4random() % sz;
        
        // exchange cards[i] and cards[j]
        //DQUCard *temp = (DQUCard *)cards[i]
        //cards[i] = cards[j]
        //cards[j] = temp;
    };
}
@end
