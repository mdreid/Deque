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

/*
@property(nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *deckButton; */

@property (nonatomic, copy) NSString *handID;
@property (nonatomic, copy) NSString *deckID;

/*
- (IBAction)deckButtonTapped:(id)sender;
- (IBAction)displayActionSheet:(id)sender;*/


@end

@implementation DQU_MainHandViewController
- (IBAction)myButton:(id)sender {
    
}

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
    
    
    DQUHand *aHand = [[DQUHand alloc] initWithHandID:@"hi"];
    [aHand addCard:1];
    [aHand addCard:3];
    [aHand addCard:5];
    [aHand addCard:7];
    
    [self drawDisplayHandCard:_myHandScroll withHand:aHand];
    
    
}

- (void) drawDisplayHandCard: (UIScrollView *)scrollView withHand:(DQUHand *) aHand {
    
    CGFloat paperwidth = 80 * 5 / 7;
    NSUInteger numberOfPapers = [aHand getCardCount];
    
    CGFloat tablePaperWidth = 80 * 5 / 7;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 568, 100)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tablePaperWidth * i, 0, paperwidth, scrollView.bounds.size.height)];
        
        int cardID = [aHand.cards[i] intValue];
        
        
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        imageView.image = [UIImage imageNamed:aCard.picName];
        [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [imageView.layer setBorderWidth: 1.0];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        
        [scrollView addSubview:imageView];
        
    }
    
    CGSize contentSizeTable = CGSizeMake(tablePaperWidth * numberOfPapers, scrollView.bounds.size.height);
    scrollView.contentSize = contentSizeTable;
    
    [self.view addSubview:scrollView];
    
    
}


-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [self showActionSheetCard];
}


- (void)showActionSheetCard
{
    NSString *actionSheetTitle = @"CARD"; //Action Sheet Title
    NSString *destructiveTitle = @"Discard"; //Action Sheet Button Titles
    NSString *other1 = @"Give to Player";
    NSString *other2 = @"Toggle";

    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2,  nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheetCard:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Discard"]) {
        NSLog(@"Destructive pressed --> Delete Something");
    }
    if ([buttonTitle isEqualToString:@"Give to Player"]) {
        NSLog(@"Other 1 pressed");
    }
    if ([buttonTitle isEqualToString:@"Toggle"]) {
        NSLog(@"Other 2 pressed");
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
    
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
