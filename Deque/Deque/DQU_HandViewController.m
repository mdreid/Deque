//
//  DQU_HandViewController.m
//  Deque
//
//  Created by Xixia Wang on 4/6/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_HandViewController.h"

@interface DQU_HandViewController ()

@end

@implementation DQU_HandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFQuery queryWithClassName:@"Hands"];
//    NSMutableArray *_cardValues = [[NSMutableArray alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
//    _cardValues = [@[@"first element"] mutableCopy];
    
    [query whereKey:@"Name" equalTo:@"Xixia"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                for (NSString *strTemp in object[@"Cards"]) {
                    NSLog(@"card: %@", strTemp);
                    [temp addObject:(NSString *) strTemp];
//                    NSLog(@"%@", _cardValues[0]);
                }
//                [_cardValues addObject:(NSString*) [object objectForKey:@"Cards"]];
//                [_cardValues addObject:(NSString*) @"hello"];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
//    NSLog(@"%@", _cardValues[0]);
//    _cardValues = temp;
    
    _cardValues = [@[@"ace of hearts",
                     @"ace of spades",
                     @"ace of clubs",
                     @"ace of diamonds"] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cardValues.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DQU_HandCard *myCard = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
    NSString *label;
    long row = [indexPath row];
    
    label = _cardValues[row];
    myCard.cardView.text = label;
    
    return myCard;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
