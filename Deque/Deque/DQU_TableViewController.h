//
//  DQU_TableViewController.h
//  Deque
//
//  Created by Linda Wang on 4/23/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQU_TableViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *p1Scrollview;

@property (strong, nonatomic) IBOutlet UIScrollView *p2Scrollview;
@property (strong, nonatomic) IBOutlet UIScrollView *p3Scrollview;
@property (strong, nonatomic) IBOutlet UIScrollView *p4Scrollview;

@property (strong, nonatomic) IBOutlet UIScrollView *tableScrollview;

@property (strong, nonatomic) IBOutlet UIButton *deck;


@end
