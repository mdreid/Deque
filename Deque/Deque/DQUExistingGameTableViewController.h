//
//  DQUExistingGameTableViewController.h
//  Deque
//
//  Created by mdreid 1 on 5/2/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DQUExistingGameTableViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic) NSMutableArray *gameArr;
@property (nonatomic) NSMutableArray *nameArr;
@property (nonatomic) NSString *chosenGameID;
@property (nonatomic) NSString *userName;

@end