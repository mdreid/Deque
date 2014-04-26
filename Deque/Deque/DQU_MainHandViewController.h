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


@interface DQU_MainHandViewController : UIViewController
{

}

// maintain a "current" hand for the app.
@property (strong, nonatomic) NSMutableArray *cardValues;

@end
