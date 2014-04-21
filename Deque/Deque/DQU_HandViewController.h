//
//  DQU_HandViewController.h
//  Deque
//
//  Created by Xixia Wang on 4/6/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DQU_HandCard.h"

@interface DQU_HandViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *deckValues;

@end
