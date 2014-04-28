//
//  NewGameViewController.h
//  Deque
//
//  Created by mdreid 1 on 4/28/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGameViewController : UIViewController

@property (nonatomic) IBOutlet UITextField *gn;
@property (nonatomic) IBOutlet UITextField *on;
@property (nonatomic) IBOutlet UITextField *n;
@property (nonatomic) NSString *gameName;
@property (nonatomic) NSString *ownerName;
@property (nonatomic) NSNumber *numPlayers;
-(IBAction) StartGame_OnClick: (id) sender;

@end
