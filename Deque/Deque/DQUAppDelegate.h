//
//  DQUAppDelegate.h
//  Deque
//
//  Created by Xixia Wang on 3/30/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DQUHand.h"
#import "DQUCard.h"

@interface DQUAppDelegate : UIResponder <UIApplicationDelegate>
{
    // this simplistic game's objects
    DQUHand *currHand;
    DQUHand *currDeck;
    
    NSString *idHand;
    NSString *idDeck;
}

@property (strong, nonatomic) UIWindow *window;

-(DQUHand *) currHand;
-(DQUHand *) currDeck;

@end
