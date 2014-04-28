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
#import <QuartzCore/QuartzCore.h>;

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
    [self drawDisplayCard:_p1Scrollview withHand:aHand withID:1];
    
    CGFloat paperwidth = 80 * 5 / 7;
    NSUInteger numberOfPapers = 15;
    
    CGFloat tablePaperWidth = 80 * 5 / 7;
    
    _tableScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 220, 458, 80)];
    
    _tableScrollview.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tablePaperWidth * i, 0, paperwidth, _tableScrollview.bounds.size.height)];
        
        imageView.image = [UIImage imageNamed:@"2_spades.png"];
        [_tableScrollview addSubview:imageView];
        
    }
    
    CGSize contentSizeTable = CGSizeMake(tablePaperWidth * numberOfPapers, _tableScrollview.bounds.size.height);
    _tableScrollview.contentSize = contentSizeTable;
    
    [self.view addSubview:_tableScrollview];
    
   /* UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20.0f, 186.0f, 280.0f, 88.0f);
    [button setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tintColor = [UIColor darkGrayColor];*/

    self.deck.center = CGPointMake(513, 150);
    [_deck addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deck];
    
    
    
}

- (void)showActionSheet:(id)sender
{
    NSString *actionSheetTitle = @"Action Sheet Demo"; //Action Sheet Title
    NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    NSString *other1 = @"Draw Card";
    NSString *other2 = @"Shuffle";
    NSString *other3 = @"Other Button 3";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2, other3, nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Destructive Button"]) {
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
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 + 115 * (playerID - 1), 100, 114, 80)];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat paperwidth = 80 * 5 / 7;
    int numberOfPapers = [aHand getCardCount];
    NSLog(@"%d", numberOfPapers);
    NSLog(@"hi come herE?");
    for (int i = 0; i < numberOfPapers; i++) {
        NSLog(@"hi");
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paperwidth * i, 0, paperwidth, scrollView.bounds.size.height)];
        
        int cardID = [aHand.cards[i] intValue];
        NSLog(@"%d is cardid", cardID);
        DQUCard *aCard = [appDel.allCards objectForKey: [NSNumber numberWithInt:cardID]];
        imageView.image = [UIImage imageNamed:aCard.picName];
        [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [imageView.layer setBorderWidth: 1.0];
        
        [scrollView addSubview:imageView];
        
    }
    
    NSLog(@"poop");
    CGSize contentSize = CGSizeMake(paperwidth * numberOfPapers, scrollView.bounds.size.height);
    scrollView.contentSize = contentSize;
    
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
