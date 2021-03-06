//
//  DQU_DisplayHandViewController.m
//  Deque
//
//  Created by Xixia Wang on 5/12/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_DisplayHandViewController.h"
#import "DQU_TableViewController.h"
#import "DQU_HandViewController.h"

@interface DQU_DisplayHandViewController () <UIActionSheetDelegate>
{
    
}

- (void)showActionSheet:(id)sender;

@property (nonatomic, copy) NSString *handID;
@property (nonatomic, copy) NSString *deckID;

@end

@implementation DQU_DisplayHandViewController

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
    
    // set up the current user information for this view.
    appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
    currentUser = [appDel.currGame getUser];
    
    self.view.backgroundColor = appDel.barColor;
    
    //draw the switch views button.
    UIButton *switchBtn = [[UIButton alloc] init];
    switchBtn.frame = CGRectMake(10.0, 280.0, 100.0, 40.0);
    switchBtn.bounds = CGRectMake(10.0, 280.0, 100.0, 40.0);
    
    UIImage *switchImg = [UIImage imageNamed:@"switch.png"];
    
    [switchBtn setImage:switchImg forState:UIControlStateNormal];
    [switchBtn setImage:switchImg forState:UIControlStateHighlighted];
    [switchBtn addTarget:self action:@selector (showActionSheetView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchBtn];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector: @selector(callRepeatedlyHand:) userInfo: nil repeats:YES];
    
    [self drawEverything];
    
}

- (void)showActionSheetView:(id)sender
{
    NSString *title = @"Switch to another view";
    NSString *cancelTitle = @"Cancel";
    NSString *tableView = @"Switch to Table View";
    NSString *handView = @"Switch to Hand View";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: nil];
    
    [actionSheet addButtonWithTitle:tableView];
    [actionSheet addButtonWithTitle:handView];
    [actionSheet addButtonWithTitle:cancelTitle];
    
    actionSheet.cancelButtonIndex = [actionSheet numberOfButtons] - 1;
    
    [actionSheet setTag:1];
    
    [actionSheet showInView:self.view];
    
}

- (void) drawEverything
{
    for (UIView *subview in [self.view subviews]) {
        if([subview isKindOfClass:[UIScrollView class]]) {
            for (UIView *c in [subview subviews]) {
                if ([c isKindOfClass:[UIButton class]]) {
                    [c removeFromSuperview];
                }
            }
            [subview removeFromSuperview];
            
        } else {
            
        }
    }
    
    myHandInd = [appDel.currGame findHandIndex:currentUser];
    
    // initialize the scroll view.
    _myHandScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [yHandStart floatValue], [widthTotal floatValue], [heightHandView floatValue])];
    _myHandScroll.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_myHandScroll];
    [self drawDisplayHandCard:appDel.currGame.hands[myHandInd + 1]];
}

- (void) callRepeatedlyHand:(id)sender
{
    appDel.currGame = [DQUDataServer retrieveGameWithID:appDel.currGame.gameID];
    [appDel.currGame setUser:currentUser];
    [appDel.currGame printGame:appDel.allCards];
    [self drawEverything];
}

- (void) drawDisplayHandCard:(DQUHand *) aHand {
    
    CGFloat paperwidth = [heightHandView floatValue] * appDel.cardWidthHeightRatio;
    float padding = 5.0;
    NSUInteger numberOfPapers = [aHand getCardCount];
    NSLog(@"DQU_MainHandViewController: number of cards: %ld", (long) numberOfPapers);
    
    [_myHandScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(((paperwidth + (2 * padding)) * i) + padding, 0, paperwidth, _myHandScroll.bounds.size.height);
        btn.bounds = CGRectMake(((paperwidth + (2 * padding)) * i) + padding, 0, paperwidth, _myHandScroll.bounds.size.height);
        
        [btn.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [btn.layer setBorderWidth: 0.5];
        
        // grab the card to show.
        int cardID = [aHand.cards[i] intValue];
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        CGSize firstSize = CGSizeMake(paperwidth, [heightHandView floatValue]);
        
        UIImage *image = [self imageWithImage: [UIImage imageNamed:aCard.picName] convertToSize:firstSize];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        
        [_myHandScroll addSubview:btn];
        
    }
    
    CGSize contentSizeTable = CGSizeMake((paperwidth + (2 * padding)) * numberOfPapers, _myHandScroll.bounds.size.height);
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
    NSString *actionSheetTitle = @"What would you like to do with this card?"; //Action Sheet Title
    NSString *destructiveTitle = @"Discard"; //Action Sheet Button Titles
    
    UIButton *btn = (UIButton *)sender;
    cardSelected = btn.tag;
    
    NSMutableArray *names = [appDel.currGame findHandIDs];
    
    NSMutableArray *optionNames = [[NSMutableArray alloc] init];
    for (NSString *n in names) {
        [optionNames addObject:[NSString stringWithFormat:@"Give to %@", n]];
    }
    
    NSString *toggle = @"Return to Hand";
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
    actionSheet.cancelButtonIndex = [actionSheet numberOfButtons] - 1;
    
    [actionSheet setTag:0];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    int removedCard = -1;
    
    switch ( actionSheet.tag )
    {
        case 0: // when a card is clicked - that action sheet.
        {
            // after any action, must do an update to the database.
            NSLog(@"action sheet coming from card number %ld", (long)cardSelected);
            
            if  ([buttonTitle isEqualToString:@"Discard"]) {
                // at this point, it is out of the hand.
                removedCard = [appDel.currGame.hands[myHandInd + 1] grabAndRemoveCardAtIndex:(int)cardSelected];
                [appDel.currGame.discard addCard:removedCard];
                
                [DQUDataServer sendHand:appDel.currGame.discard];
                [DQUDataServer sendHand:appDel.currGame.hands[myHandInd + 1]];
            }
            if ([buttonTitle isEqualToString:@"Place on Table"]) {
                // place it on the table.
                
                NSLog(@"placing on table");
                removedCard = [appDel.currGame.hands[myHandInd + 1] grabAndRemoveCardAtIndex:(int)cardSelected];
                [appDel.currGame.table addCard:removedCard];
                
                [DQUDataServer sendHand:appDel.currGame.table];
                [DQUDataServer sendHand:appDel.currGame.hands[myHandInd + 1]];
            }
            if ([buttonTitle isEqualToString:@"Return to Hand"]) {
                // either move to display hand
                // TODO: make an option to switch to display hand.
                removedCard = [appDel.currGame.hands[myHandInd + 1] grabAndRemoveCardAtIndex:(int)cardSelected];
                [appDel.currGame.hands[myHandInd] addCard:removedCard];
                
                [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
                [DQUDataServer sendHand:appDel.currGame.hands[myHandInd + 1]];
            }
            if ([buttonTitle isEqualToString:@"Cancel Button"]) {
                // cancel is pressed. nothing should happen.
            }
            
            // update the hand on the database.
            
            // redraw the view.
            [self drawDisplayHandCard:appDel.currGame.hands[myHandInd + 1]];
        }
        case 1:
        {
            [refreshTimer invalidate];
            refreshTimer = nil;
            if ([buttonTitle isEqualToString:@"Switch to Table View"]) {
                DQU_TableViewController *tableVC = (DQU_TableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"tableView"];
                [self presentViewController:tableVC animated:YES completion:nil];
            }
            if ([buttonTitle isEqualToString:@"Switch to Hand View"]) {
                DQU_HandViewController *handVC = (DQU_HandViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainHandView"];
                [self presentViewController:handVC animated:YES completion:nil];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
