//
//  DQU_MainHandViewController.h
//  Deque
//
//  Created by Xixia Wang on 4/13/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DQU_CardCell.h"
#import "DQUAppDelegate.h"

@interface DQU_MainHandViewController : UIViewController
{
    DQUAppDelegate *appDel;
    NSInteger cardSelected;
    NSInteger myHandInd;
    
    NSTimer *refreshTimer;
    NSString *currentUser;
}

@property (strong, nonatomic) IBOutlet UIScrollView *myHandScroll;
-(IBAction) BackClicked:(id)sender;


// maintain a "current" hand for the app.
@property (strong, nonatomic) NSMutableArray *cardValues;

@end
