//
//  NewGameViewController.m
//  Deque
//
//  Created by mdreid 1 on 4/28/14.
//  Copyright (c) 2014 Xixia Wang. All rights reserved.
//

#import "NewGameViewController.h"

@interface NewGameViewController ()

@end

@implementation NewGameViewController
@synthesize gn;
@synthesize on;
@synthesize n;
@synthesize gameName;
@synthesize ownerName;
@synthesize numPlayers;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) StartGame_OnClick: (id) sender {
    // be sure to do a sanitation check of the inputs
    if (self) {
        self.gameName = gn.text;
        self.ownerName = on.text;
        int players = [n.text intValue];
        self.numPlayers = [NSNumber numberWithInteger:players];
    }
}



@end
