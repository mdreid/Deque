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

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DQUHand *currHand;
@property (strong, nonatomic) DQUHand *currDeck;
@property (retain, nonatomic) NSString *idHand;
@property (retain, nonatomic) NSString *idDeck;

@end
