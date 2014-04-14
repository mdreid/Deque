//
//  DQU_MainHandViewController.m
//  Deque
//
//  Created by Xixia Wang on 4/13/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_MainHandViewController.h"

@interface DQU_MainHandViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *deckButton;
- (IBAction)deckButtonTapped:(id)sender;

@property (strong, nonatomic) NSMutableArray *cardValues;
@property (nonatomic, copy) NSString *handID;
@property (nonatomic, copy) NSString *deckID;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation DQU_MainHandViewController

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
    self.cardValues = [@[] mutableCopy];
    
    // query for hands.
    PFQuery *query = [PFQuery queryWithClassName:@"Hands"];
    
    [query whereKey:@"Name" equalTo:@"User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.",(unsigned long) objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                self.handID = [NSString stringWithString:object.objectId];
                for (NSString *strTemp in object[@"Cards"]) {
                    NSLog(@"card: %@", strTemp);
                    [self.cardValues addObject: strTemp];
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
    
    [query whereKey:@"Name" equalTo:@"Deck"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // the find succeeded.
            for (PFObject *object in objects) {
                self.deckID = [NSString stringWithString:object.objectId];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)deckButtonTapped:(id)sender {
    // TODO
}

#pragma mark - UICollectionView Datasource
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
    DQU_CardCell *myCard = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    
    NSString *label;
    long row = [indexPath row];
    
    label = _cardValues[row];
    myCard.labelView.text = label;
    
    return myCard;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: fires when a cell is selected.
    PFQuery *query = [PFQuery queryWithClassName:@"Hands"];
    long row = [indexPath row];
    NSString *selectedCard = _cardValues[row];
    
    [query getObjectInBackgroundWithId:self.handID block:^(PFObject *object, NSError *e) {
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
    [query getObjectInBackgroundWithId:self.deckID block:^(PFObject *object, NSError *e) {
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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: fires when a cell is unselected.
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(152, 126);
    return retval;
}

//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(30, 20, 30, 20);
//}


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
