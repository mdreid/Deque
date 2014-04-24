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
#import "DQUCard.h"
#import "DQUHand.h"

@implementation DQUAppDelegate

@synthesize currHand;
@synthesize currDeck;
@synthesize idHand;
@synthesize idDeck;

//// getter for currHand
//- (DQUHand *)currHand
//{
//    if (!currHand) {
//        currHand = [[DQUHand alloc] init];
//    }
//    return currHand;
//}
//
//// getter for currDeck
//- (DQUHand *)currDeck
//{
//    if (!currDeck) {
//        currDeck = [[DQUHand alloc] init];
//    }
//    return currDeck;
//}

//- (id) init
//{
//    // call the init method from the super class.
//    self = [super init];
//    
//    if (self) {
//        
//    }
//    
//    // return address of new object (which is itself)
//    return self;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // registering subclasses. must happen first thing.
    [DQUCard registerSubclass];
    [DQUHand registerSubclass];
    
    // necessary for the Parse application.
    [Parse setApplicationId:@"4b8rGvOFXnu0he9tTjcFGfAI4rtj4PrApTuUflYO"
                  clientKey:@"c6R2NoRcBD62mwLacnzOYRVNsbqrtl6um0ibiFJR"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // parse is set up at this point. can now handle work.
    
    // initialization...
    self.idHand = @"myhand";
    self.idDeck = @"deck";
    
    self.currHand = [[DQUHand alloc] initWithHandID:self.idHand];
    self.currDeck = [[DQUHand alloc] initWithHandID:self.idDeck];
    
    // create a deck
    char suits[] = {'S', 'C', 'D', 'H'};
    NSArray *ranks = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4",
                      @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q",
                      @"K", nil];
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 13; j++) {
            NSString *currCard = [NSString stringWithFormat:@"%@_%c", ranks[j], suits[i]];
            NSString *currCardPic = [NSString stringWithFormat:@"%@.png", currCard];
    
            [self.currDeck addCard:[[DQUCard alloc]
                                    initWithRank:ranks[j]
                                    Suit: suits[i]
                                    Name: currCard
                                    Pic: currCardPic]];
        }
    }
    
    for (int i = 0; i < 6; i++) {
        int r = arc4random() % [self.currDeck getCardCount];
    
        [self.currHand addCard:[self.currDeck grabAndRemoveCardAtIndex:r]];
    }
    
    [self.currDeck saveInBackground];
    [self.currHand saveInBackground];
    
    // put them into the database.
    
    
// code to store something on database, and grab it back from db
//    DQUHand *deck = [[DQUHand alloc] init];
//    [deck saveInBackground];
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"DQUHand"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
//            // Do something with the found objects
////            for (PFObject *object in objects) {
////                DQUHand *h = (DQUHand *)object;
////                [h printHand];
////                NSLog(@"%@", object.objectId);
////            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
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
}

@end
