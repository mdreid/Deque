//
//  DQUGetUsernameViewController.m
//  Deque
//
//  Created by mdreid 1 on 5/7/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUGetUsernameViewController.h"
#import "DQUExistingGameTableViewController.h"

@interface DQUGetUsernameViewController ()

@end

@implementation DQUGetUsernameViewController

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
    self.un.delegate = self;
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

- (IBAction) GoNext_OnClick:(id)sender {
    // sanitize input
    if ([self.un.text length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Username must be at least 4 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else {
        [self performSegueWithIdentifier:@"GoToNext" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToNext"]) {
        DQUExistingGameTableViewController *controller = (DQUExistingGameTableViewController *)segue.destinationViewController;
        controller.userName = self.un.text;
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

@end
