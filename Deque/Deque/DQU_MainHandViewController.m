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
     NSInteger cardSelected;
     NSInteger myHandInd;
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
     
     // set up the current user information for this view.
     appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
     NSString *ID = [appDel.currGame getUser];
     myHandInd = [appDel.currGame findHandIndex:ID];
     
     // initialize the scroll view.
     _myHandScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 568, 100)];
     _myHandScroll.showsHorizontalScrollIndicator = NO;
     
     [self.view addSubview:_myHandScroll];
     [self drawDisplayHandCard:appDel.currGame.hands[myHandInd]];
     
}

- (void) drawDisplayHandCard:(DQUHand *) aHand {
     
     CGFloat paperwidth = 80 * 5 / 7;
     NSUInteger numberOfPapers = [aHand getCardCount];
     NSLog(@"number of cards: %ld", (long) numberOfPapers);
     CGFloat tablePaperWidth = 80 * 5 / 7;
     
     [_myHandScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     
     for (NSUInteger i = 0; i < numberOfPapers; i++) {
          UIButton *btn = [[UIButton alloc] init];
          btn.frame = CGRectMake(tablePaperWidth * i, 0, paperwidth, _myHandScroll.bounds.size.height);
          btn.bounds = CGRectMake(tablePaperWidth * i, 0, paperwidth, _myHandScroll.bounds.size.height);
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
          
          [_myHandScroll addSubview:btn];
          
     }
     
     CGSize contentSizeTable = CGSizeMake(tablePaperWidth * numberOfPapers, _myHandScroll.bounds.size.height);
     _myHandScroll.contentSize = contentSizeTable;
     
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
     //    [self showActionSheetCard];
}

- (void)showActionSheet:(id)sender
{
     NSString *actionSheetTitle = @"CARD"; //Action Sheet Title
     NSString *destructiveTitle = @"Discard"; //Action Sheet Button Titles
     
     UIButton *btn = (UIButton *)sender;
     cardSelected = btn.tag;
     
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
     int removedCard = -1;
     
     // after any action, must do an update to the database.
     NSLog(@"action sheet coming from card number %ld", (long)cardSelected);
     
     if  ([buttonTitle isEqualToString:@"Discard"]) {
          // at this point, it is out of the hand.
          removedCard = [appDel.currGame.hands[myHandInd] grabAndRemoveCardAtIndex:(int)cardSelected];
          [appDel.currGame.discard addCard:(int)cardSelected];
          
          
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
     
     // update the hand on the database.
     
     // redraw the view.
     [self drawDisplayHandCard:appDel.currGame.hands[myHandInd]];
     
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

-(IBAction)deckButtonTapped:(id)sender {
     // TODO
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
