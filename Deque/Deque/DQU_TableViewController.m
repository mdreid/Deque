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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set up the current user information for this view.
    appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDel.currGame printGame:appDel.allCards];
    
    [self createColors];
    
    userInds = [[NSMutableArray alloc] init];
    scrollViews = [[NSMutableArray alloc] init];
    avatars = [[NSMutableArray alloc] init];
    
    cardWidthHeightRatio = 5.0 / 7;
    
    // load in the images and shuffle.
    [avatars addObject:@"Bulbasaur.png"];
    [avatars addObject:@"Gigglypuff.png"];
    [avatars addObject:@"Pikachu.png"];
    [avatars addObject:@"Squirtle.png"];
    
    // shuffle this list. ...should really put this in a function. ><
    NSUInteger count = [avatars count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((int)nElements) + i;
        [avatars exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    
    NSLog(@"at this point0");
    NSString *ID = [appDel.currGame getUser];
    NSLog(@"My Hand ID: %@", ID);
    myHandInd = [appDel.currGame findHandIndex:ID];
    NSLog(@"My Hand INDEX: %d", myHandInd);
    NSArray *otherInds = [NSArray arrayWithArray:[appDel.currGame findHandInds]];
    numHands = [appDel.currGame.numHands intValue];
    
    [userInds addObject:[NSNumber numberWithInteger:myHandInd]];
    
//    [appDel.currGame.hands[myHandInd] printCards:appDel.allCards];
//    [appDel.currGame.hands[myHandInd + 1] printCards:appDel.allCards];
    
    for (NSNumber *num in otherInds) {
        [userInds addObject:num];
    }
    NSLog(@"We still in business");
    NSLog(@"number of hands: %d", numHands);
    for (int i = 1; i <= numHands; i++) {
        int handInd = [userInds[i - 1] intValue];
        
        NSLog(@"hand index is: %d", handInd);
        
        UIScrollView *sv = [self drawDisplayCardwithHand:appDel.currGame.hands[handInd + 1] withID:i];
        [scrollViews addObject:sv];
    }
    NSLog(@"Did you make it here");
    
    tableScroll = [self drawDisplayTableCardWithHand:appDel.currGame.table];
    
    sideView = [self drawSideView];
    
    
    
    // TODO: draw side view!!!!
    
   /* UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 186.0f, 280.0f, 88.0f);
    [button setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tintColor = [UIColor darkGrayColor];*/

    /*
    self.deck.center = CGPointMake(530, 150);
    [_deck addTarget:self action:@selector(showActionSheetDeck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deck];
    
    self.trash.center = CGPointMake(530, 200);
    [_trash addTarget:self action:@selector(showActionSheetTrash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trash];
    */
    
 /*   _p1view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _p1view.layer.borderWidth = 0.5f;
    _p2view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _p2view.layer.borderWidth = 0.5f;
    _p3view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _p3view.layer.borderWidth = 0.5f;
    _p4view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _p4view.layer.borderWidth = 0.5f; */
  /*  _publicTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _publicTableView.layer.borderWidth = 0.5f; */
    
   // CGSize firstSize = CGSizeMake(150.0,150.0);

    

    // [self drawPlayerLabels];

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
    NSString *actionSheetTitle = @"DECK"; //Action Sheet Title
    NSString *destructiveTitle = @"New Deck"; //Action Sheet Button Titles
    NSString *other1 = @"Draw Card";
    NSString *other2 = @"Shuffle";
    NSString *other3 = @"Deal";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2, other3, nil];
        
    [actionSheet showInView:self.view];
    
}

- (void)actionSheetDeck:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"New Deck"]) {
        NSLog(@"Destructive pressed --> Delete Something");
    }
    if ([buttonTitle isEqualToString:@"Draw Card"]) {
        NSLog(@"Other 1 pressed");
    }
    if ([buttonTitle isEqualToString:@"Shuffle"]) {
        NSLog(@"Other 2 pressed");
    }
    if ([buttonTitle isEqualToString:@"Deal"]) {
        NSLog(@"Other 3 pressed");
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
    
}

- (void)showActionSheetTrash:(id)sender
{
    NSString *actionSheetTitle = @"TRASH"; //Action Sheet Title
    NSString *destructiveTitle = @"Empty"; //Action Sheet Button Titles
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles: nil];
    
    [actionSheet showInView:self.view];
    
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)actionSheetTrash:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Empty"]) {
        NSLog(@"Destructive pressed --> Delete Something");
    }
    if ([buttonTitle isEqualToString:@"Draw Card"]) {
        NSLog(@"Other 1 pressed");
    }
    if ([buttonTitle isEqualToString:@"Shuffle"]) {
        NSLog(@"Other 2 pressed");
    }
    if ([buttonTitle isEqualToString:@"Other Button 3"]) {
        NSLog(@"Other 3 pressed");
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
    
}

// --------------------------------------------------------------------
// button actions here.

- (void)handBtnPressed:(id)sender
{
    // DQU_MainHandViewController *handVC = [[DQU_MainHandViewController alloc] init];
    // [self presentViewController:handVC animated:YES completion:nil];
    
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
    float sidePadding = (sideWidth - iconSize) / 2.0;
    float heightPadding = 10.0;
    
    // draw the hand button.
    UIButton *handBtn = [[UIButton alloc] init];
    handBtn.frame = CGRectMake(sidePadding, heightPadding, (float)iconSize, (float)iconSize);
    handBtn.bounds = CGRectMake(sidePadding, heightPadding, (float)iconSize, (float)iconSize);
    
    CGSize resizeIcon = CGSizeMake((float)iconSize, (float)iconSize);
    UIImage *handImg = [self imageWithImage: [UIImage imageNamed:@"hand_icon.png"] convertToSize: resizeIcon];
    
    [handBtn setImage:handImg forState:UIControlStateNormal];
    [handBtn setImage:handImg forState:UIControlStateHighlighted];
    [handBtn addTarget:self action:@selector(handBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [side addSubview:handBtn];

    
    
    
    [self.view addSubview:side];
    
    return side;
}

- (UIScrollView *) drawDisplayCardwithHand:(DQUHand *)aHand withID:(int)playerID
{
    int numberOfPapers = [aHand getCardCount];
    float padding = 4.0;
    
    NSLog(@"DISPLAYING CARD WITH INDEX: %d", playerID);
    
    // the max width each view can be.
    // TODO: think about padding?
    NSInteger widthFactor = [widthTableMain intValue] / numHands;
    primaryWidth = widthFactor * numHands;
    sideWidth = [widthTotal floatValue] - primaryWidth;
    
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
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(widthStart, [yAvatarStartRelative floatValue], avatarDim, avatarDim)];
    av.contentMode = UIViewContentModeCenter;
    av.image = [self imageWithImage: [UIImage imageNamed:avatars[playerID - 1]] convertToSize:avResize];
    
    [myView addSubview: av];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(widthFactor * (playerID - 1), [heightTableScrollStart floatValue], widthFactor, [heightTableScroll floatValue])];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    float cardHeight = [heightTableScroll floatValue];
    CGFloat paperwidth = cardHeight * cardWidthHeightRatio;
    
    // create the cards.
    for (int i = 0; i < numberOfPapers; i++) {
        CGSize firstSize = CGSizeMake(cardHeight * cardWidthHeightRatio, cardHeight);
        
        // TODO: come back to this.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperwidth + padding) * i, 0, paperwidth, scrollView.bounds.size.height)];
        
        int cardID = [aHand.cards[i] intValue];
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        imageView.image = [self imageWithImage:[UIImage imageNamed:aCard.picName] convertToSize:firstSize];

        [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
        
        [scrollView addSubview:imageView];

    }


    CGSize contentSize = CGSizeMake((paperwidth + padding) * numberOfPapers, scrollView.bounds.size.height);
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
    
    // create the background for this.
    // create the overall frame of one player.
    CGRect viewRect = CGRectMake(0, [yTableBotStart floatValue], primaryWidth, [heightTableBot floatValue]);
    UIView* myView = [[UIView alloc] initWithFrame:viewRect];
    myView.backgroundColor = [UIColor colorWithRed:((float)255)/255
                                             green:((float)240)/255
                                              blue:((float)235)/255
                                             alpha:1.0];

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [yTableCardsStart floatValue], primaryWidth, [heightTableBot floatValue])];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        CGSize firstSize = CGSizeMake(paperWidth, [heightTableBotCards floatValue]);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperWidth + padding) * i, 0, paperWidth, scrollView.bounds.size.height)];
        
        int cardID = [tableHand.cards[i] intValue];

        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
         imageView.image = [self imageWithImage: [UIImage imageNamed:aCard.picName] convertToSize:firstSize];
        [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
         
        [scrollView addSubview:imageView];
    }
    
    CGSize contentSizeTable = CGSizeMake(paperWidth * numberOfPapers + (padding * numberOfPapers), scrollView.bounds.size.height);
    scrollView.contentSize = contentSizeTable;
    
    [self.view addSubview:myView];
    [self.view addSubview:scrollView];
    
    return scrollView;
    
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
