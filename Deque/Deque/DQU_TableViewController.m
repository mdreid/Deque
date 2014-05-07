//
//  DQU_TableViewController.m
//  Deque
//
//  Created by Linda Wang on 4/23/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_TableViewController.h"
#import "DQUAppDelegate.h"
#import "DQUHand.h"
#import <QuartzCore/QuartzCore.h>

@interface DQU_TableViewController () {
     DQUAppDelegate *appDel;
}

@end

@implementation DQU_TableViewController

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
    
    appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;


    
    
    DQUHand *aHand = [[DQUHand alloc] initWithHandID:@"hi"];
    [aHand addCard:1];
    [aHand addCard:3];
    [aHand addCard:5];
    [aHand addCard:7];
    [aHand addCard:1];
    [aHand addCard:3];
    [aHand addCard:5];
    [aHand addCard:7];
    [aHand addCard:1];
    [aHand addCard:3];
    [aHand addCard:5];
    [aHand addCard:7];
    [aHand addCard:1];
    [aHand addCard:3];
    [aHand addCard:5];
    [aHand addCard:7];
    
     /*
    [self drawDisplayCard:_p1Scrollview withHand:aHand withID:1];
    [self drawDisplayCard:_p2Scrollview withHand:aHand withID:2];
    [self drawDisplayCard:_p3Scrollview withHand:aHand withID:3];
    [self drawDisplayCard:_p4Scrollview withHand:aHand withID:4];
    [self drawDisplayTableCard:_tableScrollview withHand:aHand];
     */

    UIScrollView *p1Scroll;
    UIScrollView *p2Scroll;
    UIScrollView *p3Scroll;
    UIScrollView *p4Scroll;
    
    [self drawDisplayCard:p1Scroll withHand:aHand withID:1];
    [self drawDisplayCard:p2Scroll withHand:aHand withID:2];
    [self drawDisplayCard:p3Scroll withHand:aHand withID:3];
    [self drawDisplayCard:p4Scroll withHand:aHand withID:4];
    
    UIScrollView *tableScroll;
    
    [self drawDisplayTableCard:tableScroll withHand:aHand];
    [self drawIcons];
    
   /* UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 186.0f, 280.0f, 88.0f);
    [button setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tintColor = [UIColor darkGrayColor];*/

    self.deck.center = CGPointMake(530, 150);
    [_deck addTarget:self action:@selector(showActionSheetDeck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deck];
    
    self.trash.center = CGPointMake(530, 200);
    [_trash addTarget:self action:@selector(showActionSheetTrash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trash];
    
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

    

    [self drawPlayerLabels];


}

- (void)drawPlayerLabels {
    
    UILabel *p1Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, 123, 23)];
    [p1Label  setBackgroundColor:[UIColor clearColor]];
    p1Label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
    p1Label.textAlignment = NSTextAlignmentCenter;
    [p1Label  setText:@"P1"];
    [[self view] addSubview:p1Label];
    
    UILabel *p2Label = [[UILabel alloc]initWithFrame:CGRectMake(123, 190, 123, 23)];
    [p2Label  setBackgroundColor:[UIColor clearColor]];
    p2Label.font = [UIFont fontWithName:@"Helvetica" size:(12.0)];
    p2Label.textAlignment = NSTextAlignmentCenter;
    [p2Label  setText:@"LOL"];
    [[self view] addSubview:p2Label];

}

- (void)drawIcons {
    CGSize firstSize = CGSizeMake(110.0,110.0);
    UIImageView *p1Avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 123,123)];
    p1Avatar.contentMode = UIViewContentModeCenter;
  //  p1Avatar.image = [UIImage imageNamed:@"Pikachu.png"];
    UIImageView *p2Avatar = [[UIImageView alloc] initWithFrame:CGRectMake(123, 15, 123,123)];
    p2Avatar.contentMode = UIViewContentModeCenter;
    //p2Avatar.image = [UIImage imageNamed:@"Squirtle.png"];
    UIImageView *p3Avatar = [[UIImageView alloc] initWithFrame:CGRectMake(2*123, 15, 123,123)];
    p3Avatar.contentMode = UIViewContentModeCenter;
   // p3Avatar.image = [UIImage imageNamed:@"Gigglypuff.png"];
    UIImageView *p4Avatar = [[UIImageView alloc] initWithFrame:CGRectMake(3*123, 15 , 123,123)];
    p4Avatar.contentMode = UIViewContentModeCenter;
    //p4Avatar.image = [UIImage imageNamed:@"Bulbasaur.png"];
    p1Avatar.image = [self imageWithImage: [UIImage imageNamed:@"Pikachu.png"] convertToSize:firstSize];
    p2Avatar.image = [self imageWithImage: [UIImage imageNamed:@"Squirtle.png"] convertToSize:firstSize];
    p3Avatar.image = [self imageWithImage: [UIImage imageNamed:@"Gigglypuff.png"] convertToSize:firstSize];
    p4Avatar.image = [self imageWithImage: [UIImage imageNamed:@"Bulbasaur.png"] convertToSize:firstSize];
    [self.view addSubview: p1Avatar];
    [self.view addSubview: p2Avatar];
    [self.view addSubview: p3Avatar];
    [self.view addSubview: p4Avatar];
    
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





- (void) drawDisplayCard: (UIScrollView *)scrollView withHand:(DQUHand *)aHand withID:(int)playerID {
    
    int numberOfPapers = [aHand getCardCount];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(2 + 123 * (playerID - 1), 135, 123 - 4, 53)];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat paperwidth = 53 * 6 / 7;
    

    for (int i = 0; i < numberOfPapers; i++) {
        // NSLog(@"hi");
        CGSize firstSize = CGSizeMake(53 * 6 / 7,53.0);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((paperwidth + 5) * i, 0, paperwidth, scrollView.bounds.size.height)];
        
        int cardID = [aHand.cards[i] intValue];
        NSLog(@"%d is cardid", cardID);
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
       // imageView.image = [UIImage imageNamed:aCard.picName];
        imageView.image = [self imageWithImage: [UIImage imageNamed:aCard.picName] convertToSize:firstSize];

        [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
        
        [scrollView addSubview:imageView];
        
        /*    CGSize firstSize = CGSizeMake(50.0,50.0);
         _p1Avatar = [[UIImageView alloc] initWithFrame:CGRectMake(30, 32.5, 50, 50)];
         _p1Avatar.image = [self imageWithImage: [UIImage imageNamed:@"Pikachu.png"] convertToSize:firstSize];
         [self.view addSubview: _p1Avatar]; */
        
    }
    
    CGSize contentSize = CGSizeMake(paperwidth * numberOfPapers, scrollView.bounds.size.height);
    scrollView.contentSize = contentSize;
    
    [self.view addSubview:scrollView];
    
    
}

- (void) drawDisplayTableCard: (UIScrollView *)scrollView withHand:(DQUHand *)tableHand {
    
    CGFloat paperwidth = 97 * 6 / 7;
    NSUInteger numberOfPapers = [tableHand getCardCount];
    
    CGFloat tablePaperWidth = 97 * 6 / 7;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 218, 492, 97)];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        CGSize firstSize = CGSizeMake(97 * 6 / 7,97.0);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((tablePaperWidth + 5) * i, 0, paperwidth, scrollView.bounds.size.height)];
        
        int cardID = [tableHand.cards[i] intValue];

        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
         imageView.image = [self imageWithImage: [UIImage imageNamed:aCard.picName] convertToSize:firstSize];
        [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [imageView.layer setBorderWidth: 0.5];
         
        [scrollView addSubview:imageView];
        
    }
    
    CGSize contentSizeTable = CGSizeMake(tablePaperWidth * numberOfPapers, scrollView.bounds.size.height);
    scrollView.contentSize = contentSizeTable;
    
    [self.view addSubview:scrollView];
    
    
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
