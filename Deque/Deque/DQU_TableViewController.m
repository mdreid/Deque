//
//  DQU_TableViewController.m
//  Deque
//
//  Created by Linda Wang on 4/23/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQU_TableViewController.h"

@interface DQU_TableViewController ()

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

    _p1Scrollview =  [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 114, 80)];
    
    _p1Scrollview.showsHorizontalScrollIndicator = NO;
    
    CGFloat paperwidth = 80 * 5 / 7;
    NSUInteger numberOfPapers = 15;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paperwidth * i, 0, paperwidth, _p1Scrollview.bounds.size.height)];
        
        imageView.image = [UIImage imageNamed:@"1_spades.png"];
        [_p1Scrollview addSubview:imageView];
        
    }
    
    CGSize contentSize = CGSizeMake(paperwidth * numberOfPapers, _p1Scrollview.bounds.size.height);
    _p1Scrollview.contentSize = contentSize;
    
    [self.view addSubview:_p1Scrollview];
    
    _p2Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(115, 100, 114, 80)];
    
    _p2Scrollview.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paperwidth * i, 0, paperwidth, _p2Scrollview.bounds.size.height)];
        
        imageView.image = [UIImage imageNamed:@"2_spades.png"];
        [_p2Scrollview addSubview:imageView];
        
    }
    
    CGSize contentSize2 = CGSizeMake(paperwidth * numberOfPapers, _p2Scrollview.bounds.size.height);
    _p2Scrollview.contentSize = contentSize2;
    
    [self.view addSubview:_p2Scrollview];
    
    _p3Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(229, 100, 114, 80)];
    
    _p3Scrollview.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paperwidth * i, 0, paperwidth, _p3Scrollview.bounds.size.height)];
        
        imageView.image = [UIImage imageNamed:@"3_spades.png"];
        [_p3Scrollview addSubview:imageView];
        
    }
    
    CGSize contentSize3 = CGSizeMake(paperwidth * numberOfPapers, _p3Scrollview.bounds.size.height);
    _p3Scrollview.contentSize = contentSize3;
    
    [self.view addSubview:_p3Scrollview];

    
    _p4Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(344, 100, 114, 80)];
    
    _p4Scrollview.showsHorizontalScrollIndicator = NO;
    
    for (NSUInteger i = 0; i < numberOfPapers; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(paperwidth * i, 0, paperwidth, _p4Scrollview.bounds.size.height)];
        
        imageView.image = [UIImage imageNamed:@"1_spades.png"];
        [_p4Scrollview addSubview:imageView];
        
    }
    
    CGSize contentSize4 = CGSizeMake(paperwidth * numberOfPapers, _p4Scrollview.bounds.size.height);
    _p4Scrollview.contentSize = contentSize4;
    
    [self.view addSubview:_p4Scrollview];
    
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
