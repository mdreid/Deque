//
//  DQU_HandViewController.m
//  Deque
//
//  Created by Xixia Wang on 4/6/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_HandViewController.h"

@interface DQU_HandViewController ()
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *deckButton;
@property(nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, copy) NSString *handID;
@property (nonatomic, copy) NSString *deckID;
@end

@implementation DQU_HandViewController

@synthesize deckValues;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSMutableArray *)deckValues
{
    if (deckValues) {
        deckValues = [[NSMutableArray alloc] init];
    }
    return deckValues;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deckValues = [@[] mutableCopy];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFQuery queryWithClassName:@"Hands"];
    
    [query whereKey:@"Name" equalTo:@"Deck"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.",(unsigned long) objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                self.deckID = [NSString stringWithString:object.objectId];
                for (NSString *strTemp in object[@"Cards"]) {
//                    NSLog(@"card: %@", strTemp);
                    [deckValues addObject: strTemp];
                }
            }
            [self.collectionView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    // query for decks.
    query = [PFQuery queryWithClassName:@"Hands"];
    
    [query whereKey:@"Name" equalTo:@"User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // the find succeeded.
            for (PFObject *object in objects) {
                self.handID = [NSString stringWithString:object.objectId];
            }
        }
    }];
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
    return deckValues.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DQU_HandCard *myCard = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
    NSString *label;
    long row = [indexPath row];
    
    label = deckValues[row];
    myCard.cardView.text = label;
    
    return myCard;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: fires when a cell is selected.
    PFQuery *query = [PFQuery queryWithClassName:@"Hands"];
    long row = [indexPath row];
    NSString *selectedCard = deckValues[row];
    
    [query getObjectInBackgroundWithId:self.deckID block:^(PFObject *object, NSError *e) {
        NSMutableArray* temp = [@[] mutableCopy];
        
        for (NSString *strTemp in object[@"Cards"]) {
            if (![strTemp isEqualToString:selectedCard]) {
                NSLog(@"put in: %@", strTemp);
                [temp addObject:(NSString *) strTemp];
            }
        }
        object[@"Cards"] = [NSArray arrayWithArray:temp];
        [object saveInBackground];
    }];
    
    query = [PFQuery queryWithClassName:@"Hands"];
    [query getObjectInBackgroundWithId:self.handID block:^(PFObject *object, NSError *e) {
        NSMutableArray* temp = [@[] mutableCopy];
        for (NSString *strTemp in object[@"Cards"]) {
            [temp addObject:(NSString *) strTemp];
        }
        [temp addObject:(NSString *) selectedCard];
        object[@"Cards"] = [NSArray arrayWithArray:temp];
        [object saveInBackground];
    }];
    
    [self.collectionView reloadData];
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
