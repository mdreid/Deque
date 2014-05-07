//
//  DQUAppDelegate.m
//  Deque
//
//  Created by Xixia Wang on 3/30/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "DQUAppDelegate.h"
#import <Parse/Parse.h>
#import <stdlib.h>

@implementation DQUAppDelegate

@synthesize currGame;
@synthesize gameID;

@synthesize allCards;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // -----------------------------------------------------------------------------------------
    // registering subclasses. must happen first thing.
    
    [DQUHand registerSubclass];
    [DQUGame registerSubclass];
    
    // -----------------------------------------------------------------------------------------
    // necessary for the Parse application.
    
    [Parse setApplicationId:@"4b8rGvOFXnu0he9tTjcFGfAI4rtj4PrApTuUflYO"
                  clientKey:@"c6R2NoRcBD62mwLacnzOYRVNsbqrtl6um0ibiFJR"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // -----------------------------------------------------------------------------------------
    // parse is set up at this point. can now handle work.
    
    // dispatch queue?
 
//    [data retrieveHandWithID:@"myhand" forGameID:@""];
    
    // -----------------------------------------------------------------------------------------
    // create the dictionary of cards.
    
    self.allCards = [[NSMutableDictionary alloc] init];
    char suits[] = {'S', 'C', 'D', 'H'};
    NSArray *ranks = [NSArray arrayWithObjects:@"A", @"2", @"3", @"4",
                      @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q",
                      @"K", nil];
    int ind = 0;
    
    for (int i = 0; i < 13; i++) {
        for (int j = 0; j < 4; j++) {
            NSString *currCard = [NSString stringWithFormat:@"%@_%c", ranks[i], suits[j]];
            NSString *currCardPic = [NSString stringWithFormat:@"%@.png", currCard];
            
            [self.allCards setObject:[[DQUCard alloc]
                                 initWithRank: ranks[i]
                                 Suit: suits[j]
                                 Name: currCard
                                 Pic: currCardPic]
                         forKey:[NSNumber numberWithInt:ind]];
            
            ind += 1;
        }
    }
    
    self.barColor = [UIColor colorWithRed:((float)40)/255
                               green:((float)64)/255
                                blue:((float)102)/255
                               alpha:1.0];
    
    // set the dictionary.
    [DQUDataServer setDictionary:self.allCards];
    
    // Dummy game
    self.gameID = @"test1";
    
    // retrieve an existing game.
    self.currGame = [DQUDataServer retrieveGameWithID:self.gameID];
    // set the current user for this instance.
    [self.currGame setUser:@"xiw"];
    
    // [DQUDataServer retrieveAllGames];
    
    
    /* this section creates a new game from scratch.
    self.currGame = [[DQUGame alloc] initWithDeckandGameName:@"test1" OwnerName: @"mdr" numPlayers:4];
    [self.currGame addPlayer:@"lw3"];
    [self.currGame addPlayer:@"xiw"];
    
    [DQUDataServer updatePlayersForGameID:self.gameID forHands:self.currGame.hands];
     */
    
    // grab all games on the server (testing)
//    NSArray *games = [DQUDataServer retrieveAllGames];
//    NSLog(@"%@ with owner %@", games[0][0], games[0][1]);
    
//    [self.currGame dealCards:3];
//    [self.currGame printGame:self.allCards];
    
    
    //NewGameViewController *viewController = [[NewGameViewController alloc]init];
    //self.window.rootViewController = viewController;
    //NSString *gn = viewController.gameName;
    //NSString *on = viewController.ownerName;
    //NSNumber *n = viewController.numPlayers;
    
    // this is specifically for turning the status bar dark
    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 568, 20)];
        // this is a dark blue. should potentially change the theme to revolve around this...
        view.backgroundColor = self.barColor;
        [self.window.rootViewController.view addSubview:view];
    }

    
    return YES;
}
    
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // We have to clear out all data associated with this game
    
    
}
@end
@implementation UIViewController (rotate)
-(BOOL)shouldAutorotate {
    return NO;
}
@end

