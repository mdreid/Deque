//
//  DQU_DisplayHandViewController.h
//  Deque
//
//  Created by Xixia Wang on 5/12/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQUAppDelegate.h"

@interface DQU_DisplayHandViewController : UIViewController
{
    DQUAppDelegate *appDel;
    NSInteger cardSelected;
    NSInteger myHandInd;
    
    NSTimer *refreshTimer;
    NSString *currentUser;
}

@property UIScrollView *myHandScroll;

@end
