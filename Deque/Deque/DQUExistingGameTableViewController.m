//
//  DQUExistingGameTableViewController.m
//  Deque
//
//  Created by mdreid 1 on 5/2/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUExistingGameTableViewController.h"
#import "DQUDataServer.h"
#import "DQUAppDelegate.h"

@interface DQUExistingGameTableViewController ()

@end

@implementation DQUExistingGameTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
    
    [self setArr:[DQUDataServer retrieveAllGames]];
    NSLog(@"DQUExistingGameTableViewController.m: Array size: %d", [_arr count]);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Return the number of rows in the section.
    return [[self arr] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *gn = [NSString stringWithFormat:@"%@",_arr[indexPath.row][0]];
    NSString *on = [NSString stringWithFormat:@"%@:",_arr[indexPath.row][1]];
    NSString *combo = [NSString stringWithFormat:@"%@ %@", on, gn];
    cell.textLabel.text = combo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _chosenGameID = _arr[indexPath.row][0];

    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter your username";
    [alert show];
    _userName = alertTextField.text;
    */
    //_userName = @"iamtheman";
    [self performSegueWithIdentifier:@"Existing" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Existing"]) {
        DQUGame *game = [DQUDataServer retrieveGameWithID:[self chosenGameID]];
        [game addPlayer:_userName];
        NSLog(@"In PerformSegueWithIdentifier:!! Woo!");
        DQUAppDelegate *appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
        //self.gameName = self.gn.text;
        //self.ownerName = self.on.text;
        //self.numPlayers = [NSNumber numberWithInt:[self.n.text intValue]];
        appDel.currGame = game;
        [appDel.currGame setUser:self.userName];
    }
    
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