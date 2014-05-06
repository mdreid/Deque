//
//  DQUNewGameViewController.h
//  Deque
//
//  Created by mdreid 1 on 5/1/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQUNewGameViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic) IBOutlet UITextField *gn;
@property (nonatomic) IBOutlet UITextField *on;
@property (nonatomic) IBOutlet UITextField *n;
@property (nonatomic) NSString *gameName;
@property (nonatomic) NSString *ownerName;
@property (nonatomic) NSNumber *numPlayers;
-(IBAction) StartGame_OnClick: (id) sender;

@end
