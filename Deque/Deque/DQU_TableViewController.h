//
//  DQU_TableViewController.h
//  Deque
//
//  Created by Linda Wang on 4/23/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQUAppDelegate.h"

@interface DQU_TableViewController : UIViewController <UIActionSheetDelegate>
{
    DQUAppDelegate *appDel;
    NSInteger myHandInd;
    NSInteger numHands;
    NSMutableArray *availColors;
    NSMutableArray *scrollViews;
    NSMutableArray *userInds;
    UIScrollView *tableScroll;
    NSMutableArray *avatars;
    
    float cardWidthHeightRatio;
}

@property (strong, nonatomic) IBOutlet UIButton *deck;
@property (strong, nonatomic) IBOutlet UIButton *trash;

@end
