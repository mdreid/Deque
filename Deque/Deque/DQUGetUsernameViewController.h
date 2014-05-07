//
//  DQUGetUsernameViewController.h
//  Deque
//
//  Created by mdreid 1 on 5/7/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQUGetUsernameViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *un;
-(IBAction) GoNext_OnClick: (id) sender;

@end
