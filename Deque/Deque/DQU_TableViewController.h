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
    NSString *currentUser;
    NSMutableArray *availColors;
    NSMutableArray *scrollViews;
    NSMutableArray *userInds;
    UIScrollView *tableScroll;
    NSMutableArray *avatars;
    
    UIView *sideView;
    
    NSTimer *refreshTimer;
    
    float cardWidthHeightRatio;
    float primaryWidth;
    float sideWidth;
    
    BOOL isOwner;
    
    NSInteger cardSelected;
}

@property (strong, nonatomic) IBOutlet UIButton *deck;
@property (strong, nonatomic) IBOutlet UIButton *trash;

@property UIScrollView *tableScroll;

- (void)handBtnPressed:(id)sender;


@end
