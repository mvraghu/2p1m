//
//  ViewController.m
//  movie
//
//  Created by Raghu Venkatesh on 08/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "ViewController.h"
#import "PuzzleManager.h"
#import "PRTweenViewController.h"
#import "PuzzleCompleteViewController.h"

@interface ViewController ()
{
    PuzzleManager *puzzleManager;
    NSUserDefaults  *prefs;
}
@end

@implementation ViewController

@synthesize volume,levelButton;

-(void) viewWillAppear:(BOOL)animated
{
    puzzleManager = [PuzzleManager getInstance];
    
    
    [self setLevel];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //[window set]
    //self.view.backgroundColor = [Utility getBGImageForView:self.view];
    

    
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGRect frame ;
    if (ver < 7.0) {
        
        frame =CGRectMake(0, -44, 320, [Utility getHeight]);

    }
    else
    {
        frame =CGRectMake(0, 0, 320, [Utility getHeight]);

    }

    
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:frame];
    [bgImageView setImage:[Utility getBGImageForView]];
    [self.view insertSubview:bgImageView atIndex:0];
    
    if([Utility isDeviceIphone5])
    {
     NSArray  *controsWithTagId = [NSArray arrayWithObjects:@"100",@"99",nil];
     [Utility adjustControlPosition:controsWithTagId withView:[self view]];
    }
    
//    [levelButton setTitle:[NSString stringWithFormat:@"%d",[puzzleManager getLevel]] forState:UIControlStateNormal];

    prefs = [NSUserDefaults standardUserDefaults];

    //[self setVolumeImage:volume];
    UIImage *img;

    if([prefs stringForKey:@"vol"] ==nil )
    {
        img = [UIImage imageNamed:@"Volume_off.png"];
        
    }
    else if([[prefs stringForKey:@"vol"] isEqual:@"0"])
    {
        img = [UIImage imageNamed:@"Volume_on.png"];
    }
    else
    {
        img=[UIImage imageNamed:@"Volume_off.png"];
    }
    
    [volume setBackgroundImage:img forState:UIControlStateNormal];

    [self setLevel];


}

-(void)setLevel
{
    
    [levelButton setTitle:[NSString stringWithFormat:@"%d",[puzzleManager getLevel]] forState:UIControlStateNormal];
    levelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    levelButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setVolumeImage:(UIButton*)sender
{
 
    PRTweenOperation *activeTweenOperation;
    UIImageView *imgView;
    UIImage *img;
    
    if([prefs stringForKey:@"vol"] ==nil )
    {
        img = [UIImage imageNamed:@"Volume_off.png"];
        [prefs setObject:@"1" forKey:@"vol"];

    }
    else if([[prefs stringForKey:@"vol"] isEqual:@"1"])
    {
        [prefs setObject:@"0" forKey:@"vol"];
        img = [UIImage imageNamed:@"Volume_on.png"];
    }
    else
    {
        [prefs setObject:@"1" forKey:@"vol"];
        img=[UIImage imageNamed:@"Volume_off.png"];
    }
    [prefs synchronize];
    [volume setBackgroundImage:img forState:UIControlStateNormal];

    imgView.image = img;
    
    activeTweenOperation = [PRTweenCGRectLerp lerp:imgView property:@"frame" from:CGRectMake(20, 20, 50, 28) to:CGRectMake(20, 421, 45, 21) duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];

}
- (IBAction)onVolumePress:(id)sender {
    
    //NSUserDefaults  * prefs = [NSUserDefaults ]
    [self setVolumeImage:sender];

}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}
@end
