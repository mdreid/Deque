//
//  DQUAppDelegate.h
//  Deque
//
//  Created by Xixia Wang on 3/30/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DQUGame.h"
#import "DQUDataServer.h"
#import "NewGameViewController.h"

@interface DQUAppDelegate : UIResponder <UIApplicationDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DQUGame *currGame;
@property (retain, nonatomic) NSString *gameID;
@property (strong, nonatomic) NSMutableDictionary *allCards;

@end
