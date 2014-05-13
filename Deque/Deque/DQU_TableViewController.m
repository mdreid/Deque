//
//  DQU_TableViewController.m
//  Deque
//
//  Created by Linda Wang on 4/23/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_TableViewController.h"
#import "DQU_MainHandViewController.h"
#import "DQUHand.h"
#import <QuartzCore/QuartzCore.h>

@interface DQU_TableViewController () {

}

@end

// ------------------------------------------------------------------

@implementation DQU_TableViewController

@synthesize tableScroll;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    if ([appDel.currGame.ownerID isEqualToString:[appDel.currGame getUser]]) {
        isOwner = YES;
    }
    else {
        isOwner = NO;
    }
    
    currentUser = [appDel.currGame getUser];
    
    [self createColors];
    
    avatars = [[NSMutableArray alloc] init];
    
    cardWidthHeightRatio = 5.0 / 7;
    
    // load in the images and shuffle.
    [avatars addObject:@"Bulbasaur.png"];
    [avatars addObject:@"Gigglypuff.png"];
    [avatars addObject:@"Pikachu.png"];
    [avatars addObject:@"Squirtle.png"];
    
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target: self selector: @selector(callRepeatedly:) userInfo: nil repeats:YES];
    
    [self drawEverything];
    

}

- (void) callRepeatedly:(id)sender
{
    appDel.currGame = [DQUDataServer retrieveGameWithID:appDel.currGame.gameID];
    [appDel.currGame setUser:currentUser];
    [appDel.currGame printGame:appDel.allCards];
    [self drawEverything];
}

- (void)drawEverything
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    userInds = [[NSMutableArray alloc] init];
    scrollViews = [[NSMutableArray alloc] init];
    
    NSString *ID = [appDel.currGame getUser];
    myHandInd = [appDel.currGame findHandIndex:ID];
    NSArray *otherInds = [NSArray arrayWithArray:[appDel.currGame findHandInds]];
    numHands = [appDel.currGame.numHands intValue];
    
    NSUInteger avCount = [appDel.currGame.avatars count];
    BOOL shouldSave = NO;
    
    // do the check for the avatars.
    for (int i = (int)avCount; i < numHands; i++) {
        shouldSave = YES;
        NSString *newAv = [appDel.currGame chooseAvatar:appDel.currGame.avatars];
        [appDel.currGame.avatars addObject:newAv];
    }
    if (shouldSave == YES) {
        [DQUDataServer updatePlayersForGameID:appDel.currGame.gameID forHands:appDel.currGame.hands withAvatars:appDel.currGame.avatars];
    }
    
    NSInteger widthFactor = [widthTableMain intValue] / numHands;
    primaryWidth = widthFactor * numHands;
    sideWidth = [widthTotal floatValue] - primaryWidth;
    
    // draw the rectangle behind the table scroll.
    // create the overall frame of one player.
    CGRect viewRect = CGRectMake(0, [yTableBotStart floatValue], primaryWidth, [heightTableBot floatValue]);
    UIView* myView = [[UIView alloc] initWithFrame:viewRect];
    // random color .___.
    myView.backgroundColor = [UIColor colorWithRed:((float)255)/255
                                             green:((float)240)/255
                                              blue:((float)235)/255
                                             alpha:1.0];
    
    self.tableScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [yTableCardsStart floatValue], primaryWidth, [heightTableBot floatValue])];
    self.tableScroll.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:myView];
    [self.view addSubview:self.tableScroll];
    
    [userInds addObject:[NSNumber numberWithInteger:myHandInd]];
    
    for (NSNumber *num in otherInds) {
        [userInds addObject:num];
    }
    
    for (int i = 1; i <= numHands; i++) {
        int handInd = [userInds[i - 1] intValue];
        
        UIScrollView *sv = [self drawDisplayCardwithHand:appDel.currGame.hands[handInd + 1] withID:i];
        [scrollViews addObject:sv];
    }
    
    [self drawDisplayTableCardWithHand:appDel.currGame.table];
    
    sideView = [self drawSideView];
    
    // IMPORTANT: always draw this...
    UIView *statusView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 568, 20)];
    // this is a dark blue. should potentially change the theme to revolve around this...
    statusView.backgroundColor = appDel.barColor;
    [self.view addSubview:statusView];
}

// -----------------------------------------------------------------
// should just consider making a separate class related to colors.

- (void)createColors
{
    availColors = [[NSMutableArray alloc] init];
    
    // cool blue.
    [availColors addObject:[UIColor colorWithRed:((float)46)/255
                                           green:((float)185)/255
                                            blue:((float)244)/255
                                           alpha:1.0]];
    [availColors addObject:[UIColor colorWithRed:((float)247)/255
                                           green:((float)98)/255
                                            blue:((float)87)/255
                                           alpha:1.0]];
    [availColors addObject:[UIColor colorWithRed:((float)163)/255
                                           green:((float)219)/255
                                            blue:((float)220)/255
                                           alpha:1.0]];
    [availColors addObject:[UIColor colorWithRed:((float)255)/255
                                           green:((float)161)/255
                                            blue:((float)161)/255
                                           alpha:1.0]];
    [availColors addObject:[UIColor colorWithRed:((float)99)/255
                                           green:((float)174)/255
                                            blue:((float)66)/255
                                           alpha:1.0]];
    
}

// change this to make the colors better.
- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

- (void)showActionSheetDeck:(id)sender
{
    NSString *actionSheetTitle = @"Deck"; //Action Sheet Title
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    
    // after drawing a card, should be switched to hand view.
    NSString *draw = @"Draw Card";
    [actionSheet addButtonWithTitle:draw];
    
    if (isOwner) {
        NSString *shuffle = @"Shuffle Deck";
        // default is 4 right now. Would have liked to parametrize this, but running out of time.
        NSString *deal = @"Deal 4 Cards";             // make sure everyone's hands are empty. redeal.
        
        [actionSheet addButtonWithTitle:shuffle];
        [actionSheet addButtonWithTitle:deal];
    }
    [actionSheet addButtonWithTitle:cancelTitle];
    actionSheet.cancelButtonIndex = [actionSheet numberOfButtons] - 1;
    
    [actionSheet setTag: 0];
    
    [actionSheet showInView:self.view];
    
}

- (void)showActionSheetTrash:(id)sender
{
    int numCards = [appDel.currGame.discard getCardCount];
    NSString *actionSheetTitle = [NSString stringWithFormat:@"Trash: %d cards", numCards];
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: nil];
    
    if (isOwner) {
        NSString *putBack = @"Return to Deck";
        
        [actionSheet addButtonWithTitle:putBack];
        
    }
    
    [actionSheet addButtonWithTitle:cancelTitle];
    actionSheet.cancelButtonIndex = [actionSheet numberOfButtons] - 1;
    
    [actionSheet setTag:1];
    
    [actionSheet showInView:self.view];
    
}

- (void)showActionSheetCards:(id)sender
{
    NSString *actionSheetTitle = @"What would you like to do with this card?";
    NSString *destructiveTitle = @"Discard";
    
    NSString *putInHand = @"Place in My Hand";
    NSString *cancelTitle = @"Cancel";
    
    UIButton *btn = (UIButton *)sender;
    cardSelected = btn.tag;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:putInHand];
    [actionSheet addButtonWithTitle:cancelTitle];
    
    actionSheet.cancelButtonIndex = [actionSheet numberOfButtons] - 1;
    
    [actionSheet setTag:2];
    
    [actionSheet showInView:self.view];
}

// tag 0 = deck. tag 1 = discard.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    switch ( actionSheet.tag )
    {
        case 0: /* deck */
        {
            if  ([buttonTitle isEqualToString:@"Draw Card"]) {
                int drawCardInd = [appDel.currGame.deck drawCard];
                [appDel.currGame.hands[myHandInd] addCard:drawCardInd];
                
                [DQUDataServer sendHand:appDel.currGame.deck];
                [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
                
                // TODO: can probably make this alert more descriptive.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Draw a card" message:@"You have successfully drawn a card!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                // optional - add more buttons:
                [alert addButtonWithTitle:@"Okay"];
                [alert show];
                
            }
            if ([buttonTitle isEqualToString:@"Shuffle Deck"]) {
                [appDel.currGame.deck shuffle];
                
                [DQUDataServer sendHand:appDel.currGame.deck];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shuffle deck" message:@"You have successfully shuffled the deck!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                // optional - add more buttons:
                [alert addButtonWithTitle:@"Okay"];
                [alert show];
            }
            if ([buttonTitle isEqualToString:@"Deal Cards"]) {
                // need to reinitialize the deck, essentially.
                [appDel.currGame.deck emptyHand];
                // TODO: should modularize the deck.
                [appDel.currGame.deck createDeck:52];
                
                // then clear out everyone's hands, including table and discard.
                [appDel.currGame.table emptyHand];
                [appDel.currGame.discard emptyHand];
                for (int i = 0; i < numHands; i++) {
                    [appDel.currGame.hands[i * 2] emptyHand];
                    [appDel.currGame.hands[(i * 2) + 1] emptyHand];
                }
                
                // shuffle then redeal.
                [appDel.currGame.deck shuffle];
                [appDel.currGame dealCards:4];
                
                // send everything back to database.
                [DQUDataServer updateAllHandsForGame:appDel.currGame];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deal cards" message:@"You have successfully dealt all the players!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                // optional - add more buttons:
                [alert addButtonWithTitle:@"Okay"];
                [alert show];
                
                [self viewDidLoad];
            }
            
        }
        case 1:
        {
            if ([buttonTitle isEqualToString:@"Return to Deck"]) {
                // should this be shuffled first? why not...
                
                [appDel.currGame.discard shuffle];
                int numCards = [appDel.currGame.discard getCardCount];
                for (int i = 0; i < numCards; i++) {
                    int removed = [appDel.currGame.discard grabAndRemoveCardAtIndex:0];
                    [appDel.currGame.deck addCard:removed];
                }
                
                [DQUDataServer sendHand:appDel.currGame.deck];
                [DQUDataServer sendHand:appDel.currGame.discard];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Return to Deck" message:@"You have successfully returned all the discarded cards back to the deck!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                // optional - add more buttons:
                [alert addButtonWithTitle:@"Okay"];
                [alert show];
            }
        }
        case 2:
        {
            int removedCard = -1;
            if ([buttonTitle isEqualToString:@"Discard"]) {
                removedCard = [appDel.currGame.table grabAndRemoveCardAtIndex:(int)cardSelected];
                [appDel.currGame.discard addCard:removedCard];
                
                [DQUDataServer sendHand:appDel.currGame.discard];
                [DQUDataServer sendHand:appDel.currGame.table];
            }
            if ([buttonTitle isEqualToString:@"Place in My Hand"]) {
                removedCard = [appDel.currGame.table grabAndRemoveCardAtIndex:(int)cardSelected];
                [appDel.currGame.hands[myHandInd] addCard:removedCard];
                
                [DQUDataServer sendHand:appDel.currGame.hands[myHandInd]];
                [DQUDataServer sendHand:appDel.currGame.table];
            }
            
            [self drawDisplayTableCardWithHand:appDel.currGame.table];
        }
    }
    
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

// --------------------------------------------------------------------
// button actions here.

- (void)handBtnPressed:(id)sender
{
    
    [refreshTimer invalidate];
    refreshTimer = nil;
    
    DQU_MainHandViewController *handVC = (DQU_MainHandViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainHandView"];
    [self presentViewController:handVC animated:YES completion:nil];
}

// --------------------------------------------------------------------
// most of the drawing happens here.

- (UIView *) drawSideView
{
    CGRect viewRect = CGRectMake(primaryWidth, [heightStart floatValue], sideWidth, [heightTableSide floatValue]);
    UIView *side = [[UIView alloc] initWithFrame:viewRect];
    side.backgroundColor = appDel.barColor;
    
    int iconSize = sideWidth * 0.8;
    float iconSizeF = (float) iconSize;
    float sidePadding = (sideWidth - iconSize) / 2.0;
    float heightPadding = 20.0;
    
    CGSize resizeIcon = CGSizeMake((float)iconSize, (float)iconSize);
    
    // draw the hand button.
    UIButton *handBtn = [[UIButton alloc] init];
    handBtn.frame = CGRectMake(sidePadding, heightPadding, (float)iconSize, (float)iconSize);
    handBtn.bounds = CGRectMake(sidePadding, heightPadding, (float)iconSize, (float)iconSize);
    
    UIImage *handImg = [self imageWithImage: [UIImage imageNamed:@"hand_icon.png"] convertToSize: resizeIcon];
    
    [handBtn setImage:handImg forState:UIControlStateNormal];
    [handBtn setImage:handImg forState:UIControlStateHighlighted];
    [handBtn addTarget:self action:@selector(handBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [side addSubview:handBtn];
    
    // draw the deck button.
    UIButton *deckBtn = [[UIButton alloc] init];
    deckBtn.frame = CGRectMake(sidePadding, (heightPadding * 2) + iconSizeF, iconSizeF, iconSizeF);
    deckBtn.bounds = CGRectMake(sidePadding, (heightPadding * 2) + iconSizeF, iconSizeF, iconSizeF);
    
    UIImage *deckImg = [self imageWithImage: [UIImage imageNamed:@"cards_icon.png"] convertToSize: resizeIcon];
    
    [deckBtn setImage:deckImg forState:UIControlStateNormal];
    [deckBtn setImage:deckImg forState:UIControlStateHighlighted];
    [deckBtn addTarget:self action:@selector(showActionSheetDeck:) forControlEvents:UIControlEventTouchUpInside];
    
    [side addSubview:deckBtn];
    
    // draw the trash button.
    UIButton *trashBtn = [[UIButton alloc] init];
    trashBtn.frame = CGRectMake(sidePadding, (heightPadding * 3) + (iconSizeF * 2), iconSizeF, iconSizeF);
    trashBtn.bounds = CGRectMake(sidePadding, (heightPadding * 3) + (iconSizeF * 2), iconSizeF, iconSizeF);
    
    UIImage *trashImg = [self imageWithImage: [UIImage imageNamed:@"trash_icon.png"] convertToSize: resizeIcon];
    
    [trashBtn setImage:trashImg forState:UIControlStateNormal];
    [trashBtn setImage:trashImg forState:UIControlStateHighlighted];
    [trashBtn addTarget:self action:@selector(showActionSheetTrash:) forControlEvents:UIControlEventTouchUpInside];
    
    [side addSubview:trashBtn];

    
    [self.view addSubview:side];
    
    return side;
}

- (UIScrollView *) drawDisplayCardwithHand:(DQUHand *)aHand withID:(int)playerID
{
    int numberOfPapers = [aHand getCardCount];
    float padding = 4.0;
    
    // the max width each view can be.
    // TODO: think about padding?
    NSInteger widthFactor = [widthTableMain intValue] / numHands;
    
    // create the overall frame of one player.
    CGRect viewRect = CGRectMake(widthFactor * (playerID - 1), [heightStart floatValue], widthFactor, [heightTableMain floatValue]);
    UIView* myView = [[UIView alloc] initWithFrame:viewRect];
    UIColor *lighter = [self lighterColorForColor:availColors[playerID - 1]];
    myView.backgroundColor = lighter;
    
    // creates the little strip on the bottom.
    CGRect barRect = CGRectMake(widthFactor * (playerID - 1), [heightTableBarStart floatValue], widthFactor, [heightTableBar floatValue]);
    UIView *barView = [[UIView alloc] initWithFrame:barRect];
    barView.backgroundColor = availColors[playerID - 1];
    
    // also create the label.
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthFactor, [heightTableBar floatValue])];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setText:[aHand getPureHandID]];
    
    [barView addSubview:nameLabel];
    
    // also throw in the avatar.
    float avPadding = 3.0;
    float widthFactorPadding = widthFactor - (2 * avPadding);
    float avatarDim = MIN(widthFactorPadding, [heightAvatar floatValue]);
    CGSize avResize = CGSizeMake(avatarDim, avatarDim);
    float widthStart = (widthFactorPadding - avatarDim) / 2;
    
    NSNumber *corrInd = userInds[playerID - 1];
    
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(widthStart, [yAvatarStartRelative floatValue], avatarDim, avatarDim)];
    av.contentMode = UIViewContentModeCenter;
    av.image = [self imageWithImage: [UIImage imageNamed:appDel.currGame.avatars[[corrInd intValue] / 2]] convertToSize:avResize];
    
    [myView addSubview: av];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(widthFactor * (playerID - 1), [heightTableScrollStart floatValue], widthFactor, [heightTableScroll floatValue])];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    float cardHeight = [heightTableScroll floatValue];
    CGFloat paperwidth = cardHeight * cardWidthHeightRatio;
    
    // create the cards.
    for (int i = 0; i < numberOfPapers; i++) {
        CGSize firstSize = CGSizeMake(cardHeight * cardWidthHeightRatio, cardHeight);
        
        // TODO: come back to this.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((paperwidth + (2 * padding)) * i) + padding, 0, paperwidth, scrollView.bounds.size.height)];
        
        int cardID = [aHand.cards[i] intValue];
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        imageView.image = [self imageWithImage:[UIImage imageNamed:aCard.picName] convertToSize:firstSize];

        [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
        
        [scrollView addSubview:imageView];

    }


    CGSize contentSize = CGSizeMake((paperwidth + (2 * padding)) * numberOfPapers, scrollView.bounds.size.height);
    scrollView.contentSize = contentSize;
    
    [self.view addSubview:myView];
    [self.view addSubview:barView];

    [self.view addSubview:scrollView];
    
    return scrollView;
}

// this is to draw the scroll view for the cards on the table.
- (UIScrollView *) drawDisplayTableCardWithHand:(DQUHand *)tableHand {
    
    int numberOfPapers = [tableHand getCardCount];
    float paperWidth = [heightTableBotCards floatValue] * cardWidthHeightRatio;
    float padding = 5.0;

    [self.tableScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(((paperWidth + (2 * padding)) * i) + padding, 0, paperWidth, self.tableScroll.bounds.size.height);
        btn.bounds = CGRectMake(((paperWidth + (2 * padding)) * i) + padding, 0, paperWidth, self.tableScroll.bounds.size.height);
        
        [btn.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [btn.layer setBorderWidth: 0.5];
        
        int cardID = [tableHand.cards[i] intValue];
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        CGSize firstSize = CGSizeMake(paperWidth, [heightTableBotCards floatValue]);
        
        UIImage *image = [self imageWithImage: [UIImage imageNamed:aCard.picName] convertToSize:firstSize];
        
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(showActionSheetCards:) forControlEvents:UIControlEventTouchUpInside];
         
        [self.tableScroll addSubview:btn];
    }
    
    CGSize contentSizeTable = CGSizeMake((paperWidth + (2 * padding)) * numberOfPapers, self.tableScroll.bounds.size.height);
    self.tableScroll.contentSize = contentSizeTable;
    
    return self.tableScroll;
    
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

/* Added code for preventing autorotation */
- (NSUInteger) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    
    return UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return UIInterfaceOrientationLandscapeLeft;
    
}

@end
