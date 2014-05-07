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
    
    NSArray *tmp = [DQUDataServer retrieveAllGames];
    _gameArr = [[NSMutableArray alloc] init];
    _nameArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tmp count]; i++) {
        // it's not full!
        if (![tmp[i][2] boolValue]) {
            [_gameArr addObject: tmp[i][0]];
            [_nameArr addObject: tmp[i][1]];
        }
    }
    NSLog(@"DQUExistingGameTableViewController.m: Array size: %d", [_gameArr count]);
    
    [self.tableView setContentInset:UIEdgeInsetsMake(75,0,0,0)];
    
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
    return [[self gameArr] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *gn = [NSString stringWithFormat:@"%@",_gameArr[indexPath.row]];
    NSString *on = [NSString stringWithFormat:@"%@:",_nameArr[indexPath.row]];
    NSString *combo = [NSString stringWithFormat:@"%@ %@", on, gn];
    cell.textLabel.text = combo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _chosenGameID = _gameArr[indexPath.row];
    NSLog(@"Game ID: %@", _chosenGameID);
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
        [DQUDataServer updatePlayersForGameID:[self chosenGameID] forHands:game.hands];
        
        NSLog(@"In PerformSegueWithIdentifier:!! Woo!");
        DQUAppDelegate *appDel = (DQUAppDelegate *)[UIApplication sharedApplication].delegate;
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