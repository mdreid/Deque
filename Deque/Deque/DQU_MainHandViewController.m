//
//  DQU_MainHandViewController.m
//  Deque
//
//  Created by Xixia Wang on 4/13/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_MainHandViewController.h"
#import "DQUAppDelegate.h"

@interface DQU_MainHandViewController () <UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    DQUAppDelegate *appDel;
}

@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *deckButton;

@property (nonatomic, copy) NSString *handID;
@property (nonatomic, copy) NSString *deckID;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)deckButtonTapped:(id)sender;
- (IBAction)displayActionSheet:(id)sender;


@end

@implementation DQU_MainHandViewController

@synthesize cardValues;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)cardValues
{
    if (cardValues) {
        cardValues = [[NSMutableArray alloc] init];
    }
    return cardValues;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardValues = [@[] mutableCopy];
    
    appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
    
    PFQuery *query = [PFQuery queryWithClassName:@"DQUHand"];
    NSLog(@"the hand ID we're looking for is: %@", [[appDel currHand] getHandID]);
//    [query whereKey:@"handID" equalTo:@"myhand"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // find succeeded. there should only ever be one return object for the query.
            NSLog(@"successfully retrieved %lu objects.", (unsigned long) objects.count);
//            DQUHand *hand = (DQUHand*) objects[0];
            
            for (PFObject *object in objects) {
                DQUHand *h = [[DQUHand alloc] initWithHandID:[object objectForKey:@"handID"]];
                NSLog(@"%@", [h getHandID]);
                h.cards = (NSMutableArray *)[object objectForKey:@"cards"];
                [h printCards:appDel.allCards];
//                if ([h getHandID] == [[appDel currHand] getHandID]) {
//                    NSLog(@"successfully found %d cards in hand.", [h getCardCount]);
//                    [h printCards];
//                }
            }
//            
//            NSLog(@"successfully found %d cards in hand.", [hand getCardCount]);
            
        }
    }];
        
//    [query whereKey:@"Name" equalTo:@"User"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.",(unsigned long) objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//                self.handID = [NSString stringWithString:object.objectId];
//                for (NSString *strTemp in object[@"Cards"]) {
//                    NSLog(@"card: %@", strTemp);
//                    [cardValues addObject: strTemp];
//                }
//            }
//            [self.collectionView reloadData];
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
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
    return cardValues.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DQU_CardCell *myCard = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    
    NSString *label;
    long row = [indexPath row];
    
    label = cardValues[row];
    myCard.labelView.text = label;
    
    return myCard;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"What would you like to do?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Give to...", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Hands"];
//    long row = [indexPath row];
//    NSString *selectedCard = _cardValues[row];
//    
//    [query getObjectInBackgroundWithId:self.handID block:^(PFObject *object, NSError *e) {
//        NSMutableArray* temp = [@[] mutableCopy];
//        
//        for (NSString *strTemp in object[@"Cards"]) {
//            if (![strTemp isEqualToString:selectedCard]) {
//                NSLog(@"put in: %@", strTemp);
//                [temp addObject:(NSString *) strTemp];
//            }
//        }
//        object[@"Cards"] = [NSArray arrayWithArray:temp];
//        [object saveInBackground];
//    }];
//    
//    query = [PFQuery queryWithClassName:@"Hands"];
//    [query getObjectInBackgroundWithId:self.deckID block:^(PFObject *object, NSError *e) {
//        NSMutableArray* temp = [@[] mutableCopy];
//        for (NSString *strTemp in object[@"Cards"]) {
//            [temp addObject:(NSString *) strTemp];
//        }
//        [temp addObject:(NSString *) selectedCard];
//        object[@"Cards"] = [NSArray arrayWithArray:temp];
//        [object saveInBackground];
//    }];
//    
//    [self.collectionView reloadData];    
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

#pragma mark - UIActionSheet stuff
- (IBAction)displayActionSheet:(id)sender
{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"What would you like to do?"
//                                  delegate:self
//                                  cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"Give to...", nil];
}

- (void)showActionSheet:(id)sender
{
    
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
