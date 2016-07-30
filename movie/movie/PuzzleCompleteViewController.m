//
//  PuzzleCompleteViewController.m
//  movie
//
//  Created by Raghu Venkatesh on 28/12/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "PuzzleCompleteViewController.h"
#import "Countly.h"
#import <AdColony/AdColony.h>

@interface PuzzleCompleteViewController ()
{
    ADBannerView *adView;
}
@end

@implementation PuzzleCompleteViewController


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
    [self.navigationItem setLeftBarButtonItem:nil];    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(160,0, 20, 20)];
    [lbl setText:@"Game Over!!"];
    [lbl setTextColor:[UIColor whiteColor]];
    lbl.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView= lbl;
    
    //[bgView removeFromSuperview];
    
    UIImage* bgImage;
    CGFloat screenHeight = Utility.getHeight;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        bgImage = [UIImage imageNamed:@"info-568h.png"];
    } else {
        bgImage = [UIImage imageNamed:@"info.png"];
    }
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];

     NSString *userKey = [AdColony getCustomID];
     //userKey = [userKey stringByAppendingString:@"::PUZZLE_END"];
     NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: userKey, @"uzid", nil];

    [[Countly sharedInstance] recordEvent:@"GAME_OVER" segmentation:dict count:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
