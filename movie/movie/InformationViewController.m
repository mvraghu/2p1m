//
//  InformationViewController.m
//  movie
//
//  Created by Raghu Venkatesh on 05/11/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "InformationViewController.h"
#import "Utility.h"
#import <AdColony/AdColony.h>

@interface InformationViewController ()

@end


@implementation InformationViewController

@synthesize supportId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage* bgImage;
    CGFloat screenHeight = Utility.getHeight;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        bgImage = [UIImage imageNamed:@"info-568h.png"];
    } else {
        bgImage = [UIImage imageNamed:@"info.png"];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    UIImage* backImage = [UIImage imageNamed:@"Back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    // UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 0, 20);
    //[a1 setTitleEdgeInsets:UIEdgeInsetsMake(50, 0.0, 0.0, 50)];
   [backButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];

    
    if (ver < 7.0)
        backButton.frame = CGRectMake(0.0, 0
                                      , backImage.size.width + 8, backImage.size.height+2);
    else
        backButton.frame = CGRectMake(-10.0, 0
                                      , backImage.size.width + 8, backImage.size.height+2);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(-30, -30, -30, -30);
    [view addSubview:backButton];
    
    supportId.text = [AdColony getCustomID];
    supportId.textAlignment = NSTextAlignmentLeft;
    //supportId.dataDetectorTypes = UIDataDetectorTypeLink;
    // set the barbuttonitem to be the view
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(160,0, 20, 20)];
    [lbl setText:@"Information"];
    [lbl setTextColor:[UIColor whiteColor]];
    lbl.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView= lbl;


}

-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
