//
//  DQU_MainHandViewController.m
//  Deque
//
//  Created by Xixia Wang on 4/13/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_MainHandViewController.h"

@interface DQU_MainHandViewController () <UIActionSheetDelegate>
{

}

- (void)showActionSheet:(id)sender;

@property (nonatomic, copy) NSString *handID;
@property (nonatomic, copy) NSString *deckID;

@end

// ------------------------------------------------------------------

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
     NSLog(@"%s", __PRETTY_FUNCTION__);
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     
     // set up the current user information for this view.
     appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
     NSString *ID = [appDel.currGame getUser];
     NSLog(@"Who the hell are you?!?!! lol im %@\n", ID);
     myHandInd = [appDel.currGame findHandIndex:ID];
     
     // initialize the scroll view.
     _myHandScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, 568, 200)];
     _myHandScroll.showsHorizontalScrollIndicator = NO;
     
     [self.view addSubview:_myHandScroll];
     NSLog(@"We still good bud");
     NSLog(@"%ld", (long)myHandInd);
     [self drawDisplayHandCard:appDel.currGame.hands[myHandInd]];
     
}

- (void) drawDisplayHandCard:(DQUHand *) aHand {
     
     CGFloat paperwidth = 200 * 6 / 7;
     NSUInteger numberOfPapers = [aHand getCardCount];
     NSLog(@"DQU_MainHandViewController: number of cards: %ld", (long) numberOfPapers);
     CGFloat tablePaperWidth = 200 * 6 / 7;
     
     [_myHandScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     
     for (NSUInteger i = 0; i < numberOfPapers; i++) {
          UIButton *btn = [[UIButton alloc] init];
          btn.frame = CGRectMake((tablePaperWidth + 5)  * i, 0, paperwidth, _myHandScroll.bounds.size.height);
          btn.bounds = CGRectMake((tablePaperWidth + 5) * i, 0, paperwidth, _myHandScroll.bounds.size.height);
          
          [btn.layer setBorderColor: [[UIColor grayColor] CGColor]];
          [btn.layer setBorderWidth: 0.5];
          
          // grab the card to show.
          int cardID = [aHand.cards[i] intValue];
          DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
          CGSize firstSize = CGSizeMake(200 * 6 / 7, 200.0);
          
          UIImage *image = [self imageWithImage: [UIImage imageNamed:aCard.picName] convertToSize:firstSize];
          [btn setImage:image forState:UIControlStateNormal];
          [btn setImage:image forState:UIControlStateHighlighted];
          btn.tag = i;
          [btn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
          
          [_myHandScroll addSubview:btn];
          
     }
     
     CGSize contentSizeTable = CGSizeMake((tablePaperWidth + 5) * numberOfPapers, _myHandScroll.bounds.size.height);
     _myHandScroll.contentSize = contentSizeTable;
     
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
     UIGraphicsBeginImageContext(size);
     [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
     UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return destImage;
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
     
     NSString *toggle = @"Display";
     NSString *cancelTitle = @"Cancel";
     NSString *table = @"Place on Table";
     
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
     [actionSheet addButtonWithTitle:table];
     [actionSheet addButtonWithTitle:cancelTitle];
     actionSheet.cancelButtonIndex = [optionNames count] + 3;
     
     // TODO: why is the second to last part bold? ...figure out a way to fix this.
     
     [actionSheet showInView:self.view];
     
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     //Get the name of the current pressed button
     NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
     int removedCard = -1;
     
     // after any action, must do an update to the database.
     NSLog(@"action sheet coming from card number %ld", (long)cardSelected);
     
     if  ([buttonTitle isEqualToString:@"Discard"]) {
          // at this point, it is out of the hand.
          removedCard = [appDel.currGame.hands[myHandInd] grabAndRemoveCardAtIndex:(int)cardSelected];
          [appDel.currGame.discard addCard:removedCard];
          
          [DQUDataServer sendHand:appDel.currGame.discard];
          [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
     }
     if ([buttonTitle isEqualToString:@"Place on Table"]) {
          // place it on the table.
          
          NSLog(@"placing on table");
          removedCard = [appDel.currGame.hands[myHandInd] grabAndRemoveCardAtIndex:(int)cardSelected];
          [appDel.currGame.table addCard:removedCard];
          
          [DQUDataServer sendHand:appDel.currGame.table];
          [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
     }
     if ([buttonTitle rangeOfString:@"Give to"].location != NSNotFound) {
          NSArray *array = [buttonTitle componentsSeparatedByString:@"Give to "];
          
          // will only be the 'first' item of the array, since only one user.
          NSInteger otherHandInd = [appDel.currGame findHandIndex:array[1]];
          
          // the transfer.
          removedCard = [appDel.currGame.hands[myHandInd] grabAndRemoveCardAtIndex:(int) cardSelected];
          [appDel.currGame.hands[(int)otherHandInd] addCard:removedCard];
          
          [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
          [DQUDataServer sendHand:appDel.currGame.hands[otherHandInd]];
     }
     if ([buttonTitle isEqualToString:@"Display"]) {
          // either move to display hand
          // TODO: make an option to switch to display hand.
          removedCard = [appDel.currGame.hands[myHandInd] grabAndRemoveCardAtIndex:(int)cardSelected];
          [appDel.currGame.hands[myHandInd + 1] addCard:removedCard];
          
          [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
          [DQUDataServer sendHand:appDel.currGame.hands[myHandInd + 1]];
     }
     if ([buttonTitle isEqualToString:@"Cancel Button"]) {
          // cancel is pressed. nothing should happen.
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
