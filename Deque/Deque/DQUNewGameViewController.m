//
//  DQUNewGameViewController.m
//  Deque
//
//  Created by mdreid 1 on 5/1/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUNewGameViewController.h"
#import "DQU_TableViewController.h"
#import "DQUAppDelegate.h"
#import "DQUGame.h"

@interface DQUNewGameViewController ()

@end

@implementation DQUNewGameViewController

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
    // keyboard management
    self.gn.delegate = self;
    self.on.delegate = self;
    self.n.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) StartGame_OnClick:(id)sender {
    // sanitize input
    if ([self.gn.text length] < 3)
        return;
    if ([self.on.text length] < 3)
        return;
    if ([self.n.text intValue] < 2)
        return;
    NSLog(@"I'm here yo!");
    [self performSegueWithIdentifier:@"GoNext" sender:self];
}

/*
- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
       if ([identifier isEqualToString:@"GoNext"]) {
           NSLog(@"In PerformSegueWithIdentifier:!! Woo!");
        DQUAppDelegate *appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
        self.gameName = self.gn.text;
        self.ownerName = self.on.text;
        self.numPlayers = [NSNumber numberWithInt:[self.n.text intValue]];
        appDel.currGame = [[DQUGame alloc] initWithDeckandGameName:self.gameName OwnerName: self.ownerName numPlayers:[self.numPlayers intValue]];
    }
}
*/
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoNext"]) {
        NSLog(@"In PerformSegueWithIdentifier:!! Woo!");
        DQUAppDelegate *appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
        self.gameName = self.gn.text;
        self.ownerName = self.on.text;
        self.numPlayers = [NSNumber numberWithInt:[self.n.text intValue]];
        appDel.currGame = [[DQUGame alloc] initWithDeckandGameName:self.gameName OwnerName: self.ownerName numPlayers:[self.numPlayers intValue]];
        [appDel.currGame setUser:self.ownerName];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return UIInterfaceOrientationPortrait;
    
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
