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

- (void)showActionSheet:(id)sender;

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
    
    NSString *ID = [appDel.currGame getUser];
    int handInd = [appDel.currGame findHandIndex:ID];
    
//    DQUHand *aHand = [[DQUHand alloc] initWithHandID:@"hi"];
//    [aHand addCard:1];
//    [aHand addCard:3];
//    [aHand addCard:5];
//    [aHand addCard:7];
    
    [self drawDisplayHandCard:_myHandScroll withHand:appDel.currGame.hands[handInd]];
    
    
}

- (void) drawDisplayHandCard: (UIScrollView *)scrollView withHand:(DQUHand *) aHand {
    
    CGFloat paperwidth = 80 * 5 / 7;
    NSUInteger numberOfPapers = [aHand getCardCount];
    CGFloat tablePaperWidth = 80 * 5 / 7;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 568, 100)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(tablePaperWidth * i, 0, paperwidth, scrollView.bounds.size.height);
        btn.bounds = CGRectMake(tablePaperWidth * i, 0, paperwidth, scrollView.bounds.size.height);
        [btn.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [btn.layer setBorderWidth: 0.8];
        
        // grab the card to show.
        int cardID = [aHand.cards[i] intValue];
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        
        UIImage *image = [UIImage imageNamed:aCard.picName];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        
        /*
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tablePaperWidth * i, 0, paperwidth, scrollView.bounds.size.height)];
        imageView.image = [UIImage imageNamed:aCard.picName];
        [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [imageView.layer setBorderWidth: 1.0];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
         */
        
        [scrollView addSubview:btn];
        
    }
    
    CGSize contentSizeTable = CGSizeMake(tablePaperWidth * numberOfPapers, scrollView.bounds.size.height);
    scrollView.contentSize = contentSizeTable;
    
    [self.view addSubview:scrollView];
    
    
}

//- (void)didTapCard:(UIButton *)btn
//{
//    NSLog(@"tapped card index %ld", (long)btn.tag);
//    [self showActionSheetCard:];
//}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
//    [self showActionSheetCard];
}

- (void)showActionSheet:(id)sender
{
    NSString *actionSheetTitle = @"CARD"; //Action Sheet Title
    NSString *destructiveTitle = @"Discard"; //Action Sheet Button Titles
    
    NSMutableArray *names = [appDel.currGame findHandIDs];
    
    NSMutableArray *optionNames = [[NSMutableArray alloc] init];
    for (NSString *n in names) {
        [optionNames addObject:[NSString stringWithFormat:@"Give to %@", n]];
    }
    
    NSString *toggle = @"Toggle";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:toggle];
    for (NSString *title in optionNames) {
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:cancelTitle];
    actionSheet.cancelButtonIndex = [optionNames count] + 1;
    
    [actionSheet showInView:self.view];
    
}

// TODO: why isn't this being called??
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    // after any action, must do an update to the database.
    NSLog(@"I clicked a button...");
    
    if  ([buttonTitle isEqualToString:@"Discard"]) {
//        NSLog(@"going to discard card at index: %d", actionSheet.ind);
        NSLog(@"Destructive pressed --> Delete Something");
    }
    if ([buttonTitle rangeOfString:@"Give to"].location != NSNotFound) {
        
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
