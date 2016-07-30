    //
//  MainViewController.m
//  movie
//
//  Created by Raghu Venkatesh on 08/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "PuzzleManager.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "LetterHint.h"
#import "Puzzle.h"
#import "Utility.h"
#import "SFSSmokeScreen.h"
#import "SFSConfettiScreen.h"
#import "FacebookHelper.h"
#import "PRTweenViewController.h"
#import "AppShopper.h"
#import "PuzzleCompleteViewController.h"
#import "Countly.h"
#import <AdColony/AdColony.h>
#import <zlib.h>


@interface MainViewController ()
{
    NSMutableArray* solutions;
    NSMutableArray* jumbledButtons;
    NSString * randomString;
    NSString *answer;
    NSString *answerWithSapce;
    NSString *hint;
    NSMutableString *givenAnswer;
    NSString *shuffledChars;
    PuzzleManager *puzzleManager;
    Puzzle *puzzleData;
    UIButton *levelButton,*scoreButton,*backButton,*coinsButton;
    Boolean isCoinsViewOpen;
    NSMutableDictionary *remainingRandomString;
    NSString *image1;
    NSString *image2 ;
    UIView * scaledImageUIView;
    NSString *custId;
    GADBannerView *adView;
    GADInterstitial *interstitial;
    FacebookHelper *fbHelper;
    
}
@property (strong) AppShopper *aSP;
@property (strong) UIActivityIndicatorView *spinner;

@end

@implementation MainViewController
static MainViewController *sharedInstance;
static AppShopper *asSharedInstance;
@synthesize firstPic,secondPic;
@synthesize hint_button, remove_button, reveal_button;


#define REVEAL_LETTER_COIN_NEEDED 40
#define REMOVE_LETTERR_COIN_NEEDED 15
#define SHOW_HINT_COIN_NEEDED 60
#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // Custom initialization
    if (self && !sharedInstance) {
        sharedInstance = self;
    }
    return self;
}


+ (MainViewController *)sharedInstance
{
    if(sharedInstance)
    {
        return sharedInstance;
    }
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    puzzleManager = [PuzzleManager getInstance];
    custId = [AdColony getCustomID];
    
    NSString *levelStr = [NSString stringWithFormat: @"%d", (int)[puzzleManager getLevel]];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: levelStr, @"level",custId, @"uzid", nil];
    [[Countly sharedInstance] recordEvent:@"PUZZLE_LOADED" segmentation:dict count:1];

     //if([self checkForP;uzzlesComplete])return;
    
    //self.canDisplayBannerAds = YES;
    
    
    //show banner ads
    //[super viewDidLoad];
    //if ([self respondsToSelector:@selector(setCanDisplayBannerAds:)]) {
    //    self.canDisplayBannerAds = YES;
    //}

    /*if([ADBannerView respondsToSelector:@selector(class)]) {
        adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,440,320,40)];
        //adView.autoresizesSubviews = TRUE;
        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
        adView.delegate = self;
        [self.view addSubview:adView];
    }*/
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];

    
    if (ver < 7.0)
    {
        adView = [[GADBannerView alloc]
                  initWithFrame:CGRectMake(0.0,
                                           [Utility getHeight] - 40 - 44,
                                           GAD_SIZE_320x50.width,
                                           GAD_SIZE_320x50.height)];

    }
    else
    {
        adView = [[GADBannerView alloc]
                  initWithFrame:CGRectMake(0.0,
                                           [Utility getHeight] - 44,
                                           GAD_SIZE_320x50.width,
                                           GAD_SIZE_320x50.height)];

    }
    
    //NSLog(@ "height = %f",[[UIScreen mainScreen] applicationFrame].size.height);
    adView.adUnitID = @"a152f0cdfdb44a1";
    //adView.adUnitID = @"a14dccd0fb24d45";
    [adView setDelegate:self];
    adView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    //request.testDevices = [NSArray arrayWithObjects:@"acd243a2fe6c31e77549ff5cbfec2891", nil];
    [adView loadRequest: request];
    
    
    
    // google fullscreen interstitial
    interstitial = [[GADInterstitial alloc] init];
    [interstitial setDelegate:self];
    //interstitial.rootViewController = self;
    interstitial.adUnitID = @"a152f0cdfdb44a1";
    GADRequest *requestFSI = [GADRequest request];
    //request.testing = YES;
    [interstitial loadRequest:requestFSI];
    
    
    PRTweenOperation *activeTweenOperation;
    sharedInstance = self;

    //self.view.backgroundColor = [Utility getBGImageForView:self.view];
    
    CGRect frame ;
    if (ver < 7.0)
        frame =CGRectMake(0, -44, 320, [Utility getHeight]);
    else
        frame =CGRectMake(0, 0, 320, [Utility getHeight]);

    
    if([Utility isDeviceIphone5] && ver >= 7.0)
    {
        NSArray  *controsWithTagId = [NSArray arrayWithObjects:@"1",@"2",@"4",@"5",@"6",nil];
        [Utility adjustControlPosition:controsWithTagId withView:[self view]];
    }
    else if (ver < 7.0)
    {
        NSArray  *controsWithTagId = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil];
        [Utility adjustControlPositionForIOS6:controsWithTagId withView:[self view]];

    }

    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:frame];
    [bgImageView setImage:[Utility getBGImageForView]];
    [self.view insertSubview:bgImageView atIndex:0];
    
    [self setGameData];
    
    puzzleData = (Puzzle*)[puzzleManager getPuzzleData];
    //[self decryptData:puzzleData.hint withKey:@"test"]
    answer = [Utility decryptData:puzzleData.answer withKey:@"test"];// [puzzleData objectForKey:@"Answer"];
    hint = [Utility decryptData:puzzleData.hint withKey:@"test"];//[puzzleData objectForKey:@"Hint"];
    //NSLog(@"Answer is %@",answer);
    
    image1 = [puzzleManager constructPuzzleImagePath:1];
    image2 = [puzzleManager constructPuzzleImagePath:2];
    
    NSInteger HintY;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    firstPic.image = [UIImage imageNamed: image1];
    //firstPic.image = [self addOverlayToBaseImage:[UIImage imageNamed:@"lay01_imagebase.png"]:firstPic.image];
    //firstPic.image = [self makeRoundedImage:firstPic.image:20.0];
    

    [self makeRoundedImage:firstPic];

    [firstPic setTag:1];
    [firstPic addGestureRecognizer:singleTap];
    //activeTweenOperation = [PRTweenCGRectLerp lerp:firstPic property:@"frame" from:CGRectMake(60, 120, 150, 130) to:CGRectMake(15, 91, 140, 110) duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
    
    CGRect toFrame =  firstPic.frame;
    CGRect fromFrame = CGRectMake(firstPic.frame.origin.x-1, firstPic.frame.origin.y-2, firstPic.frame.size.width -10, firstPic.frame.size.height -10) ;

     activeTweenOperation = [PRTweenCGRectLerp lerp:firstPic property:@"frame" from:fromFrame to:toFrame duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
    
    //[firstPic.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    //[firstPic.layer setBorderWidth: 3.0];
    //[firstPic setBackgroundColor:ImgBackground];
    
    UITapGestureRecognizer *single1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTapped:)];
    single1Tap.numberOfTapsRequired = 1;
    single1Tap.numberOfTouchesRequired = 1;
    secondPic.image = [UIImage imageNamed: image2];
    [self makeRoundedImage:secondPic];
    [secondPic setTag:2];
    
    [secondPic addGestureRecognizer:single1Tap];
    //activeTweenOperation = [PRTweenCGRectLerp lerp:secondPic property:@"frame" from:CGRectMake(165, 120, 150, 130) to:CGRectMake(165, 91, 140, 110) duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL]
    
     toFrame =  secondPic.frame;
     fromFrame = CGRectMake(secondPic.frame.origin.x-1, secondPic.frame.origin.y-2, secondPic.frame.size.width -10, secondPic.frame.size.height -10) ;

    activeTweenOperation = [PRTweenCGRectLerp lerp:secondPic property:@"frame" from:fromFrame to:toFrame duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
    //[secondPic.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    //[secondPic.layer setBorderWidth: 3.0];
    //    [secondPic setBackgroundColor:ImgBackground];
    
    answer= [answer uppercaseString];
    answerWithSapce = answer;
    [self createSolutionLayout:answer];
    answer = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
    remainingRandomString= [[NSMutableDictionary alloc] initWithCapacity:[answer length]];
    
    for (int i=0;i<[answer length]; i++) {
        if([puzzleManager containsRevealedLetter:i])continue;
        NSNumber *key = [NSNumber numberWithInt:i];
        NSString *character = [NSString stringWithFormat:@"%C",[answer characterAtIndex:i]];
        [remainingRandomString setObject:character  forKey:key];
    }
    HintY = [self generateJumbledChars:answer];
    
    givenAnswer= [[NSMutableString alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIImage* backImage = [UIImage imageNamed:@"Back.png"];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    // UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 0, 20);
    //[a1 setTitleEdgeInsets:UIEdgeInsetsMake(50, 0.0, 0.0, 50)];
    [backButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];

    CGRect levelButtonPos = CGRectMake(0,0
                                       , 32, 32);
    UIImage* levelImage = [UIImage imageNamed:@"Level_star.png"];
    levelButton = [[UIButton alloc] initWithFrame:levelButtonPos];
    [levelButton setBackgroundImage:levelImage forState:UIControlStateNormal];
    [levelButton setUserInteractionEnabled:NO];
   [levelButton setTitle:[NSString stringWithFormat:@"%d",[puzzleManager getLevel]] forState:UIControlStateNormal];
    
   // [levelButton setTitle:@"100" forState:UIControlStateNormal];
    levelButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);

    if (ver < 7.0)
        backButton.frame = CGRectMake(0.0, 0
                                      , backImage.size.width + 7, backImage.size.height+2);
    else
        backButton.frame = CGRectMake(-10.0, 0
                                      , backImage.size.width + 7, backImage.size.height+2);

    
    backButton.imageEdgeInsets = UIEdgeInsetsMake(-15, -15, -30, -30);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width + 20, backImage.size.height)];
    [view addSubview:backButton];
    
    // set the barbuttonitem to be the view
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    if (ver < 7.0)
        levelButton.frame = CGRectMake(0, 0
                            , levelImage.size.width, levelImage.size.height);
    else
        levelButton.frame = CGRectMake(10.0, 0
                                       , levelImage.size.width, levelImage.size.height);


    UIView * levelview = [[UIView alloc] initWithFrame:CGRectMake(00, 0, levelImage.size.width, levelImage.size.height)];
    [levelview addSubview:levelButton];


    UIBarButtonItem *levelButtonItem =[[UIBarButtonItem alloc] initWithCustomView:levelview];
    levelButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    CGRect homeButtonPos = CGRectMake(0,0, 70, 30);

    if (ver < 7.0)
         homeButtonPos = CGRectMake(60,5, 100, 30);
    else
         homeButtonPos = CGRectMake(55,5, 100, 30);

    
    scoreButton = [[UIButton alloc] initWithFrame:homeButtonPos];
    UIImage *scoreImage = [UIImage imageNamed:@"score_iap.png"];
    [scoreButton setUserInteractionEnabled:YES];
    [scoreButton setBackgroundImage:scoreImage forState:UIControlStateNormal];
    scoreButton.titleLabel.font = [UIFont systemFontOfSize:12];
    //scoreButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [scoreButton setTitle:[NSString stringWithFormat:@" %d",[puzzleManager getCoins]] forState:UIControlStateNormal];
    [scoreButton addTarget:self action:@selector(showCoins:) forControlEvents:UIControlEventTouchUpInside];
    scoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    scoreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    
//    if (ver < 7.0)
//        homeButtonPos = CGRectMake(160,5, 32, 32);
//    else
//        homeButtonPos = CGRectMake(140,5, 32, 32);
//
//    coinsButton = [[UIButton alloc] initWithFrame:homeButtonPos];
//    UIImage *coins = [UIImage imageNamed:@"CoinsPlus.png"];
//    [coinsButton setUserInteractionEnabled:YES];
//    [coinsButton setBackgroundImage:coins forState:UIControlStateNormal];
//    [coinsButton addTarget:self action:@selector(onCoinsClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 100000, 44)];
    //[myView addSubview:coinsButton];
   // [myView setBackgroundColor:[UIColor redColor]];
    [myView addSubview:scoreButton];
    [myView setUserInteractionEnabled:YES];
    //[myView bringSubviewToFront:coinsButton];


    self.navigationItem.titleView = myView;
    self.navigationItem.leftBarButtonItem = barButtonItem;
    //self.navigationItem.titleView.frame=homeButtonPos;
    self.navigationItem.rightBarButtonItem=levelButtonItem;
}



- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    [self.view addSubview:adView];
}

+ (void) animateHints
{
    MainViewController *currentInstance = [MainViewController sharedInstance];
    PRTweenOperation *activeTweenOperation;
    
    CGRect toFrame =  currentInstance.remove_button.frame;
    CGRect fromFrame = CGRectMake(currentInstance.remove_button.frame.origin.x, currentInstance.remove_button.frame.origin.y-20, currentInstance.remove_button.frame.size.width , currentInstance.remove_button.frame.size.height ) ;

    
    activeTweenOperation = [PRTweenCGRectLerp lerp:currentInstance.remove_button property:@"frame" from:fromFrame to:toFrame duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
    
     toFrame =  currentInstance.hint_button.frame;
     fromFrame = CGRectMake(currentInstance.hint_button.frame.origin.x, currentInstance.hint_button.frame.origin.y-20, currentInstance.hint_button.frame.size.width , currentInstance.hint_button.frame.size.height ) ;

    activeTweenOperation = [PRTweenCGRectLerp lerp:currentInstance.hint_button property:@"frame" from:fromFrame to:toFrame duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
    
    toFrame =  currentInstance.reveal_button.frame;
    fromFrame = CGRectMake(currentInstance.reveal_button.frame.origin.x, currentInstance.reveal_button.frame.origin.y-20, currentInstance.reveal_button.frame.size.width , currentInstance.reveal_button.frame.size.height ) ;
    
    
    activeTweenOperation = [PRTweenCGRectLerp lerp:currentInstance.reveal_button property:@"frame" from:fromFrame to:toFrame duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
}

+ (void) updateCoins
{
    MainViewController *currentInstance = [MainViewController sharedInstance];
    [currentInstance setGameData];
}

+ (AppShopper *) getAppShopperSharedInstance
{
    return asSharedInstance;
}
+ (void) stopAnimation
{
    MainViewController *currentInstance = [MainViewController sharedInstance];
    UIActivityIndicatorView *spinner = currentInstance.spinner;
    [spinner stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)onBack:(id)sender
{
    
    //[self.parentViewController.navigationController popViewControllerAnimated:YES];
    [[self.navigationController.viewControllers objectAtIndex:1] viewWillAppear:YES];
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)showCoins:(id)sender
{
    [self showIAPDialog];
}



-(void) showIAPDialog
{
    NSString *levelStr = [NSString stringWithFormat: @"%d", (int)[puzzleManager getLevel]];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: levelStr, @"level",custId, @"uzid", nil];
    [[Countly sharedInstance] recordEvent:@"IAP_DIALOG_LOADED" segmentation:dict count:1];
    if(isCoinsViewOpen)return;
    [Utility addMask:[self view]];
    UIView *coinUIView = [[UIView alloc] initWithFrame:CGRectMake(15, -240, 290, 240)];
    [coinUIView setTag:99];
    coinUIView.layer.cornerRadius = 10; // this value vary as per your desire
    coinUIView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"buycoins_background.png"]];
    UIImage *navImage = [UIImage imageNamed:@"buycoins_header.png"];
    
    UIImageView *uiv = [[UIImageView alloc] initWithImage:navImage];
    uiv.frame = CGRectMake(0, 0, 290, 40);
    [coinUIView addSubview:uiv];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:uiv.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    uiv.layer.mask = maskLayer;
    
    UILabel * lbl  = [[UILabel alloc] initWithFrame:CGRectMake(110, 8, 100, 32)];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setText:@"Buy Coins"];
    [lbl setFont:[UIFont fontWithName:@"Cochin" size:18]];
    lbl.backgroundColor = [UIColor clearColor];
    [coinUIView addSubview:lbl];
    
    //coinUIView.userInteractionEnabled = NO;
    
    NSArray *coinArray = [NSArray arrayWithObjects:@"250 Coins \n$0.99",@"750 Coins \n$1.99",@"1250 Coins\n$2.99",@"2500 Coins\n$4.99", nil];
    //NSArray *coinValueArray = [NSArray arrayWithObjects:@"0.99",@"1.99",@"4.99",@"9.99", nil];
    NSInteger arrIndex=0;
    NSInteger rowIndex=0;
    for(int i = 0; i < 2 ; i++) {
        int y = (i ==0 )?60 :50;
        for(int j = 0; j < 2 ; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *coinImage = [UIImage imageNamed:@"coins_bg.png"];
            [button setBackgroundImage:coinImage forState:UIControlStateNormal];
            [button setFrame:CGRectMake(32 * (j *4 +1) , y * (rowIndex*2 +1) , 100, 70)];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
            [button setAlpha:1];
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:[coinArray objectAtIndex:arrIndex] forState:UIControlStateNormal];
            [button setTag: 2*i + j];
            [button addTarget:self action:@selector(onBuyClick:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 10; // this value vary as per your desire
            button.clipsToBounds = YES;
            button.titleLabel.font = [UIFont fontWithName:@"Cochin" size:18];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [coinUIView addSubview:button];
            arrIndex++;
        }
        rowIndex++;
    }
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 3, 30, 30)];
    UIImage *scoreImage = [UIImage imageNamed:@"close_dialog.png"];
    [cancelButton setBackgroundImage:scoreImage forState:UIControlStateNormal];
    [cancelButton setTag:700];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [coinUIView addSubview:cancelButton];
    
    [Utility enableViewControls:self.view withValue:NO];
    
    
    [UIView transitionWithView:coinUIView
                      duration:.3
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        coinUIView.frame=CGRectMake(15, 90, 290, 240);
                    } completion:^(BOOL finished){
                        
                    }];
    
    [[self view] addSubview:coinUIView];
    
    [backButton setEnabled:NO];
    [coinsButton setEnabled:NO];
    isCoinsViewOpen= YES;

    
}

-(void)close:(id)sender
{
    [Utility removeMask:[self view]];
    
    [UIView transitionWithView:[sender superview]
                      duration:.2
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        [sender superview].frame=CGRectMake(15,[Utility getHeight], 290, 240);
                    } completion:^(BOOL finished){
                        [[sender superview]removeFromSuperview];
                    }];

    isCoinsViewOpen= NO;
    [Utility enableViewControls:self.view withValue:YES];
    [backButton setEnabled:YES];
    [coinsButton setEnabled:YES];


}

-(void)onBuyClick:(UIButton *) sender
{
    // Initialize an activity indicator
    UIButton *resultButton = (UIButton *)sender;
    NSInteger tag = (long)resultButton.tag ;
    NSString *tagStr = [NSString stringWithFormat: @"%d", (int)tag];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: tagStr, @"product_id",custId,@"uzid", nil];
    [[Countly sharedInstance] recordEvent:@"IAP_PACKAGE_TAPPED" segmentation:dict count:1];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.color = [UIColor blackColor];
    UIView *getIapView = (UIView*)[self.view viewWithTag:99];
    NSInteger w = getIapView.frame.size.width;
    NSInteger h = getIapView.frame.size.height;
    _spinner.center = getIapView.center;
    _spinner.frame = CGRectMake(w/2, h/2, 10, 10);
    [getIapView  addSubview:_spinner];
    
    // ignore interactions
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    // Start the spinner
    [_spinner startAnimating];
    
    
    _aSP = [[AppShopper alloc] init];
    asSharedInstance = _aSP;
    switch(tag) {
        case 0:
            [_aSP requestProductData: @"100"];
            break;
        case 1:
            [_aSP requestProductData: @"200"];
            break;
        case 2:
            [_aSP requestProductData: @"300"];
            break;
        case 3:
            [_aSP requestProductData: @"400"];
            break;
    }

}

-(void )makeRoundedImage:(UIView *) view
{
//    CALayer *imageLayer = [CALayer layer];
//    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    imageLayer.contents = (id) image.CGImage;
//    
//    imageLayer.masksToBounds = YES;
//    imageLayer.cornerRadius = radius;
//    
//    UIGraphicsBeginImageContext(image.size);
//    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    view.layer.cornerRadius = 10.0f;
    view.clipsToBounds = YES;

    
    //return roundedImage;
}


-(void)setGameData
{
//    [level_text setText:[NSString stringWithFormat:@"%d",[puzzleManager getLevel]]];
//    [level_text setFont:[UIFont fontWithName:@"AngryBirds-Regular" size:18]];
//    [score_text setText:[NSString stringWithFormat:@"%d",[puzzleManager getCoins]]];
//    [score_text setFont:[UIFont fontWithName:@"AngryBirds-Regular" size:18]];
    
    [levelButton setTitle:[NSString stringWithFormat:@"%d",[puzzleManager getLevel]] forState:UIControlStateNormal];
    
    int coins = [puzzleManager getCoins];
    
    for(int i=coins -5 ; i<= coins ; i++)
    {
        [scoreButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];

    }
}

- (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer {
    NSString *levelStr = [NSString stringWithFormat: @"%d", (int)[puzzleManager getLevel]];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: levelStr, @"level",custId, @"uzid", nil];

    [[Countly sharedInstance] recordEvent:@"IMAGE_TAPPED" segmentation:dict count:1];

    PRTweenOperation *activeTweenOperation;
    UIImageView * imageView = (UIImageView*)[gestureRecognizer view];
    imageView.userInteractionEnabled = YES;
    CGPoint convertedPoint = [imageView  convertPoint:imageView.bounds.origin toView:self.view];
    CGRect frame;//= CGRectMake(convertedPoint.x, convertedPoint.y,Utility.fullImageWidth ,110);
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:imageView.image];
    [overlayImageView setTag:1000];
    overlayImageView.userInteractionEnabled = YES;
    [overlayImageView setFrame:CGRectMake(0,0,Utility.fullImageWidth , Utility.adjustedImageHeight-100)];
    
    [self makeRoundedImage:overlayImageView];

    if([imageView tag]==2)
    {
        frame= CGRectMake(firstPic.frame.origin.x,firstPic.frame.origin.y,Utility.fullImageWidth ,Utility.adjustedImageHeight-100);
    }
    else{
        
        frame= CGRectMake(convertedPoint.x, convertedPoint.y,Utility.fullImageWidth ,Utility.adjustedImageHeight-100);
    }
    
    frame = CGRectIntegral(frame);
    
    scaledImageUIView = [[UIView alloc] initWithFrame: frame];
    [scaledImageUIView setTag:[imageView tag]];
    scaledImageUIView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [mSwipeUpRecognizer setNumberOfTouchesRequired:1];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [scaledImageUIView addGestureRecognizer:mSwipeUpRecognizer];
    mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    [mSwipeUpRecognizer setNumberOfTouchesRequired:1];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [scaledImageUIView addGestureRecognizer:mSwipeUpRecognizer];
    
    
    UILabel * credits= [[UILabel alloc] init];
    //[credits setText:[[puzzleData objectForKey:@"Credits"] objectAtIndex:[imageView tag]-1]];
    if([imageView tag]==1) //
        [credits setText:[@"\u00A9 flickr " stringByAppendingString:puzzleData.credit1]];
    else
        [credits setText:[@"\u00A9 flickr " stringByAppendingString:puzzleData.credit2]];

    [credits setTag:1001];
    credits.textAlignment = NSTextAlignmentCenter;
    credits.backgroundColor = [UIColor grayColor];
    [[credits layer] setCornerRadius:3];
    [credits setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [self customizeLabel:credits];
    
    UITapGestureRecognizer *onViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseView:)];
    onViewTap.numberOfTapsRequired = 1;
    onViewTap.numberOfTouchesRequired = 1;
    
//    UITapGestureRecognizer *onViewTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseView:)];
//    onViewTap1.numberOfTapsRequired = 1;
//    onViewTap1.numberOfTouchesRequired = 1;
//
//    
//    [overlayImageView addGestureRecognizer:onViewTap1];
    [scaledImageUIView addGestureRecognizer:onViewTap];
    [scaledImageUIView addSubview:overlayImageView];
    [scaledImageUIView addSubview:credits];
    //scaledImageUIView.alpha = 0.0;
    [self.view bringSubviewToFront:scaledImageUIView];
    [self.view addSubview:scaledImageUIView];

    /*[UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //scaledImageUIView.alpha = 1.0;
                     }completion:^(BOOL finished){
                     }];*/
    activeTweenOperation = [PRTweenCGRectLerp lerp:overlayImageView property:@"frame" from:CGRectMake(0,0, Utility.fullImageWidth-10, Utility.adjustedImageHeight-90) to:CGRectMake(0, 0, Utility.fullImageWidth ,Utility.adjustedImageHeight-100) duration:1 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
    
    [ Utility playSound:(SoundEffect)openImage];
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)customizeLabel:(UILabel *) lbl
{
    NSString *author = lbl.text;
    
    CGFloat width =  [author sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:11]].width;
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setFrame:CGRectIntegral(CGRectMake(Utility.fullImageWidth-width-10,180, width+4,10))];

}

- (void)onSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    UIView * uiView = (UIView*)[gestureRecognizer view];
    UIImageView *imageView = (UIImageView*)[uiView viewWithTag:1000];
    UILabel *credit = (UILabel*)[uiView viewWithTag:1001];

    
    UISwipeGestureRecognizerDirection dir=  [gestureRecognizer direction];
    UIViewAnimationOptions trans=UIViewAnimationOptionTransitionFlipFromRight;
    if (dir==UISwipeGestureRecognizerDirectionRight) {
        trans= UIViewAnimationOptionTransitionFlipFromLeft;
    }
    
    //NSArray *credits = [puzzleData objectForKey:@"Credits"];
    
    [UIView animateWithDuration:.5
                          delay:0
                        options:trans
                     animations:^{
                         if([uiView tag]==1)
                         {
                             imageView.image = [UIImage imageNamed: image2];
                             [credit setText:[@"\u00A9 flickr " stringByAppendingString:puzzleData.credit2]];
                             [self customizeLabel:credit];

                             [uiView setTag:2];
                         }
                         else
                         {
                             imageView.image = [UIImage imageNamed: image1];
                             [credit setText:[@"\u00A9 flickr " stringByAppendingString:puzzleData.credit1]];
                             [self customizeLabel:credit];
                             [uiView setTag:1];
                             
                         }
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)onCloseView:(UIGestureRecognizer *)gestureRecognizer {
    
    UIView * uiView = (UIView*)[gestureRecognizer view];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
//                         uiView.frame = CGRectMake(uiView.frame.origin.x, uiView.frame.origin.y, Utility.normalImageWidth, uiView.frame.size.height);   // fade out
                         uiView.alpha = 0;
                         [uiView removeFromSuperview];

                     }completion:^(BOOL finished){
                         
                     }];
    
    [ Utility playSound:(SoundEffect)closeImage];
    
}

-(void) createSolutionLayout:(NSString *) solution
{
    UILabel *solChar=nil;
    NSInteger x  = 0;
    NSInteger offset = 0;
    NSInteger MAXCHARS = 9;
    NSMutableArray *array = (NSMutableArray *)[solution componentsSeparatedByString:@" "];
    NSInteger noOfLines = [array count];
    NSInteger y = [Utility getYSolutionLayoutPosition:noOfLines];

    NSString *trimmedSoln = [solution stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIColor *bgImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Label_Button.png"]];
    solutions = [[NSMutableArray alloc] initWithCapacity:[trimmedSoln length]];
    NSInteger revealedLetterIndex=0;
    NSString *word = nil;
    NSInteger spaceBetweenLines =  [Utility spaceBetweenLines:noOfLines];


    for (int j=0; j< noOfLines; j++) {
        x =0;
        word = [array objectAtIndex:j];
        NSInteger characterCount = [word length];
        NSInteger noOfSpaceInRow =  characterCount>=MAXCHARS ?0:((MAXCHARS-1) - characterCount)/2;
    
        //rows
        //y=Utility.getSolutionLayoutPosition;
        y = [Utility getYSolutionLayoutPosition:noOfLines] + spaceBetweenLines * j;
        bool isOdd =  characterCount>=MAXCHARS ?0:(characterCount%2==1);
        
        offset = [Utility getXSolutionLayoutPosition:characterCount];
        
        for (int i=noOfSpaceInRow; i< characterCount + noOfSpaceInRow; i++) {
            x =   5 + (offset *i) + Utility.spaceBetweenLetters * i + (isOdd?Utility.offsetForOdd:0);
            solChar = [[UILabel alloc] initWithFrame:CGRectMake(x , y, 30,30)];
            [solChar setFont:[UIFont fontWithName:@"AngryBirds-Regular" size:18]];
            if(![puzzleManager containsRevealedLetter:revealedLetterIndex])
            {
                [solChar setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
                [solChar addGestureRecognizer:tapGesture];
            }
            else
            {
                [solChar setText:[NSString stringWithFormat:@"%c", [trimmedSoln characterAtIndex:revealedLetterIndex]]];
                solChar.textAlignment=NSTextAlignmentCenter;
                [solChar setTextColor:[UIColor brownColor]];
            }
            solChar.backgroundColor = bgImage;
            [solutions addObject:solChar];
            [[self view] addSubview:solChar];
            revealedLetterIndex++;
            
        }
    }
}


-(void) labelTap :(id)sender
{
    
    UILabel *tappedLbl = (UILabel *)[sender view];
    if([[tappedLbl text]length] ==0)return;
    [ Utility playSound:(SoundEffect)keyDeselect];
    [self removeCharFromSolutionField:tappedLbl];
}

-(void) removeCharFromSolutionField :(UILabel *) tappedLbl
{
    
    if ([tappedLbl textColor]==[UIColor redColor])
    {
        NSInteger revealedLetterIndex=0;
        for (UILabel *letter in solutions) {
            
            if(![puzzleManager containsRevealedLetter:revealedLetterIndex])
                [letter setTextColor:[UIColor blackColor]];
            else
                [letter setTextColor:[UIColor greenColor]];
            revealedLetterIndex++;
        }
        
    }
    for (UIButton *object in jumbledButtons) {
        
        
        if([tappedLbl tag]!=[object tag])continue;
        
        [object setHidden:NO];
        //UIImage *img = [UIImage imageNamed:@"Key_Button.png"];
        //[object setBackgroundImage:img forState:UIControlStateNormal];
        [object setTitle:[tappedLbl text] forState:UIControlStateNormal];
        
        [object setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:0.12 delay:0.0  options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             object.transform = CGAffineTransformMakeScale(1.8f, 1.8f); // scale to double.
                         } completion:^(BOOL finished){
                             object.transform = CGAffineTransformMakeScale(1.0f, 1.0f); // shrink to half.
                         }];
        
        [tappedLbl setText:@""];
        [tappedLbl setTag:-1];
        
        
    }

    
}

-(NSInteger)generateJumbledChars: (NSString *) solution
{
    shuffledChars = [puzzleManager getShuffledString];
    if ([shuffledChars length]==0){
        NSInteger NO_CHARS_SOLN= 16;
        randomString = [self genRandStringLength:NO_CHARS_SOLN-[solution length]];
        shuffledChars = [self shuffle:solution];
        shuffledChars = [self shuffle:[randomString stringByAppendingString:shuffledChars]];
        [puzzleManager setShuffledString:shuffledChars];
        [puzzleManager setRandomString:randomString];

        
    }else
    {
        randomString= [puzzleManager getRandomString];
    }
    //NSLog(@ "%@", shuffledChars);
    return [self createJumbledCharLayout:shuffledChars];
}

-(NSInteger)createJumbledCharLayout:(NSString *) jumbledChars
{
    
    UIButton *solChar=nil;
    NSInteger x  = 0;
    NSInteger y = Utility.getYJumbledLayoutPosition;
    //NSInteger charCount= 0;
    NSInteger noOfLines = 2;
    // const char *c = [jumbledChars UTF8String];
    //UIImage *img = [UIImage imageNamed:@"buttonfortext.png"];
    UIImage *img = [UIImage imageNamed:@"Key_Button.png"];
    jumbledButtons = [[NSMutableArray alloc] initWithCapacity:16];
    NSInteger removedLetterIndex=0;
    UIColor *color = [UIColor whiteColor];
    
    // NSInteger sequenceNum=0;
    for (int j=0; j< noOfLines; j++) {
        x = 0;
        y = y + [Utility spaceBetweenLinesfoSol] * j;
        for (int i=0; i< 8; i++) {
            x =   4 + (Utility.getXJumbledLayoutPosition *i) + Utility.spaceBetweenLetters * i ;
            solChar = [[UIButton alloc] initWithFrame:CGRectMake(x , y, 32,32)];
            
            if([puzzleManager containsRemovedLetter:removedLetterIndex])
            {
                [solChar setBackgroundImage:img forState:UIControlStateNormal];
                [solChar setUserInteractionEnabled:NO];
                solChar.enabled = NO;
            }
            else{
                
                [solChar setBackgroundImage:img forState:UIControlStateNormal];
                solChar.titleLabel.font  = [UIFont fontWithName:@"AngryBirds-Regular" size:20];
                [solChar addTarget:self action:@selector(myEventHandler:) forControlEvents: UIControlEventTouchUpInside];
            }
            [solChar setTitleColor:color forState:UIControlStateNormal];
            [jumbledButtons addObject:solChar];
            [[self view] addSubview:solChar];
            removedLetterIndex++;
        }
    }
    
    //while (self.isViewLoaded && self.view.window) {
    self.view.userInteractionEnabled=NO;
    [self animateButtons:0];
    //}
    return y;
}
-(void) showLevelUpView
{
    [Utility playSound:(SoundEffect)levelUp];
    
    NSString *levelStr = [NSString stringWithFormat: @"%d", (int)[puzzleManager getLevel]];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys: levelStr, @"level",custId, @"uzid", nil];

    [[Countly sharedInstance] recordEvent:@"PUZZLE_SOLVED" segmentation:dict count:1];

    
    //self.navigationController.navigationBar.userInteractionEnabled=NO;
    //CGRect screen = [[UIScreen mainScreen] bounds];
    
        // here you go with iOS 7
        // [self viewDidUnload];
    
    
    
    SFSSmokeScreen * sss1 = [[SFSSmokeScreen alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)
                                                     emitterFrame:CGRectMake(0, 0, 400, 500)];
    
    [sss1 setIsEmitting];
    [sss1 setTag:2000];
    [[self view ] addSubview:sss1];
    
    SFSConfettiScreen * sss = [[SFSConfettiScreen alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000) ];
    [sss setTag:3000];
    [[self view ] addSubview:sss];

    [NSTimer scheduledTimerWithTimeInterval:0.9
                                     target:self
                                   selector:@selector(stopAnimation)
                                   userInfo:nil
                                    repeats:NO];
    
}


-(void) stopAnimation
{
    [[[self view] viewWithTag:2000] removeFromSuperview];
    [[[self view] viewWithTag:3000] removeFromSuperview];
    
    //UIView *imgView = [[self view]viewWithTag:1]==nil?[[self view]viewWithTag:2] : [[self view]viewWithTag:1];
    //[imgView removeFromSuperview];

    CGFloat screenWidth = Utility.getWidth;
    CGFloat screenHeight = Utility.getHeight;
    
    CGRect frame= CGRectMake(0,0,screenWidth,screenHeight );
    UIView* levelUpView = [[UIView alloc] initWithFrame: frame];
 levelUpView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    
    NSArray *greetingsLoot = @[ @"AHHSUM",
                         @"GUDJAAB",
                         @"NAISE..!",
                         @"SOOPER!!",
                         @"GR8..!"];
    
    //levelUpView.userInteractionEnabled =YES;
    //levelUpView.backgroundColor = [UIColor yellowColor];
    //levelUpView.opaque = NO;
    [scoreButton setEnabled:NO];
    [backButton setEnabled:NO];
    [coinsButton setEnabled:NO];

    //levelUpView.backgroundColor = [UIColor clearColor];
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    [Utility addMask:[self view]];
    
    NSInteger indx = rand() % greetingsLoot.count;
    NSString *greeting = [greetingsLoot objectAtIndex:indx];
    float width = [Utility getTextWidth:greeting withFontSize:40 withFontType:@"AngryBirds-Regular"];
    UILabel *labelCaption = [[UILabel alloc] initWithFrame:CGRectMake(80,100,width, 40)];
    labelCaption.backgroundColor = [UIColor clearColor];
    
    [labelCaption setText:greeting];
    labelCaption.center = levelUpView.center;
    frame = labelCaption.frame;
    frame.origin.y =100;
    labelCaption.frame=frame;

    [labelCaption setTextColor:[UIColor whiteColor]];
    [labelCaption setFont:[UIFont fontWithName:@"AngryBirds-Regular" size:40]];
    [levelUpView addSubview:labelCaption];
    
    
    width = [Utility getTextWidth:@"you got it right !!" withFontSize:20 withFontType:@"AngryBirds-Regular"];
    UILabel *labelSec = [[UILabel alloc] initWithFrame:CGRectMake(80,140,width, 40)];
    labelSec.backgroundColor = [UIColor clearColor];

    [labelSec setText:@"you got it right !!"];
    labelSec.center = levelUpView.center;
    frame = labelSec.frame;
    frame.origin.y =140;
    labelSec.frame=frame;


    [labelSec setTextColor:[UIColor whiteColor]];
    [labelSec setFont:[UIFont fontWithName:@"AngryBirds-Regular" size:20]];
    [levelUpView addSubview:labelSec];
    
    
    width = [Utility getTextWidth:answerWithSapce withFontSize:20 withFontType:@"AngryBirds-Regular"];
    int x = 85;


    UILabel *labelAns = [[UILabel alloc] initWithFrame:CGRectMake(x,180,width, 40)];
    //UILabel *labelAns = [[UILabel alloc] init];
    //[labelAns sizeToFit];
    [labelAns setTextColor:[UIColor whiteColor]];
    [labelAns setFont:[UIFont fontWithName:@"AngryBirds-Regular" size:20]];
    [labelAns setTag:42];
    labelAns.backgroundColor = [UIColor clearColor];

    labelAns.center = levelUpView.center;
    
    frame = labelAns.frame;
    frame.origin.y =180;
    labelAns.frame=frame;


    [levelUpView addSubview:labelAns];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
//    ^{
//        
//        [self animateLabelShowText:answerWithSapce characterDelay:0.5 withlabel:labelAns ];
//
//                
//    });
    
        // Do some computation here.
        
        // Update UI after computation.

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:answerWithSapce forKey:@"string"];
    [dict setObject:@0 forKey:@"currentCount"];
    [dict setObject:labelAns forKey:@"label"];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(typingLabel:) userInfo:dict repeats:YES ];
    [timer fire];


    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver <7)
        [button setFrame:CGRectMake(85 ,350, 150, 44)];
    else
        [button setFrame:CGRectMake(85 ,400, 150, 44)];

    [button setAlpha:1];

    UIImage *img = [UIImage imageNamed:@"continue.png"];
    [button setTitle:@"CONTINUE" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onContinue:) forControlEvents:UIControlEventTouchUpInside];
    levelUpView.alpha = .8;
    [[self view] addSubview:levelUpView];
    [levelUpView setTag:101];
    [[self view] addSubview:button];
    
    UIImage *coin = [UIImage imageNamed:@"coin.png"];
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:coin];
    overlayImageView.center = levelUpView.center;
    [levelUpView addSubview:overlayImageView];
    
    [self verticalFlip:overlayImageView ];

    

}


-(void)typingLabel:(NSTimer*)theTimer
{
    NSString *theString = [theTimer.userInfo objectForKey:@"string"];
    UILabel * lbl  =(UILabel*)[theTimer.userInfo objectForKey:@"label"];

    int currentCount = [[theTimer.userInfo objectForKey:@"currentCount"] intValue];
    currentCount ++;
    //NSLog(@"%@", [theString substringToIndex:currentCount]);
    
    [theTimer.userInfo setObject:[NSNumber numberWithInt:currentCount] forKey:@"currentCount"];
    
    if (currentCount > theString.length-1) {
        [theTimer invalidate];
    }
    
    [lbl setText:[theString substringToIndex:currentCount]];
}

- (void)animateLabelShowText:(NSString*)newText characterDelay:(NSTimeInterval)delay withlabel:(UILabel *)lbl
{
    [lbl setText:@""];
    
    for (int i=0; i<newText.length; i++)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [lbl setText:[NSString stringWithFormat:@"%@%C", lbl.text, [newText characterAtIndex:i]]];
                       });
        
        }
            [NSThread sleepForTimeInterval:delay];
}

- (void)verticalFlip:(UIView *) coin{
    
    
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         coin.center = CGPointMake(160, 160);
                         coin.layer.transform = CATransform3DMakeRotation(M_PI_2,1.0,0.0,0.0); //flip halfway
    } completion:^(BOOL finished){
        
        //coin.center = CGPointMake(160, 80);

        // Add your new views here
        [UIView animateWithDuration:.5
                delay:0
                options:UIViewAnimationOptionTransitionNone

                animations:^{
                    [UIView setAnimationRepeatCount:3];

                    coin.layer.transform = CATransform3DMakeRotation(M_PI,1.0,0.0,0.0); //finish the flip
                    coin.center = CGPointMake(160, 00);

        } completion:^(BOOL finished){
            // Flip completion code here
            
            coin.center = CGPointMake(160, 00);
            [coin removeFromSuperview];
            [self setGameData];
            


        }];
    }];
}

-(void) onContinue:(UIButton *)sender
{
    [self checkForPuzzlesComplete];
    
    [sender  removeFromSuperview];
    [[self.view viewWithTag:99] removeFromSuperview ];
    [[self.view viewWithTag:101] removeFromSuperview ];
    if(scaledImageUIView!=nil)
        [scaledImageUIView removeFromSuperview];
    
    [Utility removeMask:[self view]];
    for (UILabel *object in solutions) {
        [object removeFromSuperview];
    }
    for (UIButton *object in jumbledButtons) {
        [object removeFromSuperview];
    }
    
    [solutions removeAllObjects];
    [jumbledButtons removeAllObjects];
    
    NSUInteger level = [puzzleManager getLevel] ;
    
    if( level % 6 == 0)
    {
        //Show AdColony video ad begin
        NSArray *zoneIds = @[@"vzac26d06223aa4f26a5",
                         @"vzb10c21c4d6874a9982",
                         @"vza00b0503812d423b8a",
                         @"vzfe3ea51386ba404492",
                         @"vz87753e9e98c74f0aa9"];
        NSInteger zoneCount = [zoneIds count];
        for (NSInteger i = 0; i < zoneCount; i++)
        {
            if([self AdColonyShouldProceedVideoPlay:zoneIds[i]])
            {
                [AdColony playVideoAdForZone:zoneIds[i] withDelegate:nil];
                break;
            }
        }
    }
    else if (level % 2 == 0 )
    {
        if(interstitial.isReady)
        {
            [interstitial presentFromRootViewController:self];
        }
    }
    
    //NSLog(@"OpenUDID is %@", [AdColony getOpenUDID]);
    //Adcolony end
    
    // Persist to disk its important
    [[PuzzleManager getInstance] persistToDisk];
    [self showRateUsDialog];
    [self viewDidLoad];
}


- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
}


-(BOOL) AdColonyShouldProceedVideoPlay:(NSString *) ZoneId
{
    //NSLog(@"Adcolony Zone Status %u",[AdColony zoneStatusForZone:ZoneId]);
    if([AdColony zoneStatusForZone:ZoneId] == ADCOLONY_ZONE_STATUS_ACTIVE)
    {
        return TRUE;
    }
    return FALSE;
}

-(void) myEventHandler:(UIButton *)sender
{
    for (UILabel *object in solutions) {
        if([[object text] length] == 0)
        {
            [object setText:[sender currentTitle]];
            [object setTag:[sender tag]];
            [object setTextAlignment: NSTextAlignmentCenter];
            [sender setTitle:@"" forState:UIControlStateNormal];
            //UIImage *img = [UIImage imageNamed:@"Key_Button.png"];
            //[sender setBackgroundImage:img forState:UIControlStateNormal];
            [sender setUserInteractionEnabled:NO];
            [Utility playSound:(SoundEffect)keyTap];
            break;
        }
    }
    [self didUserLevelUp];
}

- (void) didUserLevelUp
{
    [givenAnswer setString: @""];
    
    for (UILabel *letter in solutions) {
        if([[letter text] length] == 0)
        {
            return;
        }
        [givenAnswer appendString:[letter text]];
    }
    
    if( ![answer isEqualToString:givenAnswer])
    {
        if([answer length] == [givenAnswer length])
        {
            [Utility playSound:(SoundEffect)wrongAnswer];
            
            
            [self animateWrongAnswer];


        }
        return;
    }
    [puzzleManager saveUserData];
    [self showLevelUpView];
}



- (void)animateWrongAnswer{
    [self performSelector:@selector(animateDiffColor:) withObject:[UIColor redColor] afterDelay:0.1];
    [self performSelector:@selector(animateDiffColor:) withObject:[UIColor whiteColor] afterDelay:0.3];
    [self performSelector:@selector(animateDiffColor:) withObject:[UIColor redColor] afterDelay:0.5];
    [self performSelector:@selector(animateDiffColor:) withObject:[UIColor whiteColor] afterDelay:0.7];
    [self performSelector:@selector(animateDiffColor:) withObject:[UIColor redColor] afterDelay:0.9];

}


-(void)animateDiffColor:(UIColor *) clr
{
    for (UILabel *letter in solutions) {
        [letter setTextColor:clr];
    }
}


- (void) showRateUsDialog
{
    // check if the user level % 5 is true
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *isUserRated =  [prefs stringForKey:@"isUserRated"];
    
    if([puzzleManager getLevel] % 10 == 0 && (isUserRated== nil || [isUserRated  isEqual: @""]))
    {
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"2 Pics 1 Movie" message:@"Hi There, Do you want to take a minute and Rate Us!, we would love to hear what you have to say!" delegate:self cancelButtonTitle:@"Rate" otherButtonTitles:@"Cancel", nil];
        [alert setTag:5];
        [alert show];
    }
}

- (IBAction) HintEventHandler:(UIButton *)HelpButton
{
    //[self viewDidUnload];
    NSInteger selectedHelp = [HelpButton tag];
    NSString *viewMessage ;
    HintType hintType = None;
    
    if(selectedHelp == 4)
    {
        viewMessage = @"Remove a letter for 15 coins";
        hintType = removeLetter;
        //removeButton = HelpButton;
        //remove_button.titleLabel.hidden = YES;
    }
    else if(selectedHelp==6)
    {
        viewMessage = @"Reveal a letter for 40 coins";
        hintType = revealLetter;
        //revealButton = HelpButton;
        //reveal_button.titleLabel.hidden = YES;

    }
    else if(selectedHelp==5)
    {
        viewMessage = @"Know the director/lead actor's name for 60 coins";
        hintType = showHint;
        //hintButton = HelpButton;
        //hint_button.titleLabel.hidden = YES;
        if([puzzleManager isHintUsed])
        {
             [self HintProcessor:hintType];
             return;
        }
    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"2 Pics 1 Movie" message:viewMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    
    [alert setTag:hintType];
    [alert show];
    
}

- (void) HintProcessor : (HintType) hintType
{
    BOOL wasCurrencySufficient = NO;
    switch(hintType)
    {
        case removeLetter:
            if([puzzleManager canPurchase:REMOVE_LETTERR_COIN_NEEDED ])
            {
                [self removeLetter];
                [puzzleManager decrementCoins:REMOVE_LETTERR_COIN_NEEDED];
                wasCurrencySufficient = YES;
            }
            break;
        case revealLetter:
            if([puzzleManager canPurchase:REVEAL_LETTER_COIN_NEEDED ])
            {
                [self revealLetter];
                [puzzleManager decrementCoins:REVEAL_LETTER_COIN_NEEDED];
                wasCurrencySufficient = YES;				
            }
            break;
        case showHint:
            if([puzzleManager canPurchase:SHOW_HINT_COIN_NEEDED ])
            {
                
                
                // set the hint into hint button before deducing the coins
                //hintButton.hidden = YES;
                //hint_text.hidden = NO
                wasCurrencySufficient = YES;
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"2 Pics 1 Movie" message:hint delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil, nil];
                
                [alert setTag:-1];
                [alert show];
                if([puzzleManager isHintUsed])
                    return;
                [puzzleManager decrementCoins:SHOW_HINT_COIN_NEEDED];
                [puzzleManager setIsHintUsed:YES];
            }
            break;
        default:
            break;
    }
    if( wasCurrencySufficient == YES )
    {
        [self setGameData];
    }
    else
    {
        [self showNotEnoughCurrency];
        //[self showCoins:nil];
    }
}


-(void) showNotEnoughCurrency
{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"2 Pics 1 Movie" message:@"Hi There, you dont have enough coins to use this hint, do you want to purchase a few coins" delegate:self cancelButtonTitle:@"Purchase" otherButtonTitles:@"Not Now", nil];
    [alert setTag:99];
    [alert show];

}


- (void)animateButtons:(NSInteger ) index
{
    UIButton *btn = [jumbledButtons objectAtIndex:index];
    __block NSInteger num = index;
    
    
    [UIView transitionWithView:btn
                      duration:0.08
                      // options:UIViewAnimationOptionTransitionFlipFromTop
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        if(![puzzleManager containsRemovedLetter:num])
                        {
                            [btn setTitle:[NSString stringWithFormat:@"%c", [shuffledChars characterAtIndex:num]] forState:UIControlStateNormal];
                            
                        }
                        [btn setTag:num];
                        
                        
                    } completion:^(BOOL finished){
                        
                        
                        if (num < jumbledButtons.count - 1) {
                            num= num + 1;
                            [self animateButtons:num];
                        }
                        else
                        {
                            self.view.userInteractionEnabled=YES;
                        }
                    }];
    
}


-(NSString *) shuffle :(NSString *) string
{
    
    NSMutableString *randomizedText = [NSMutableString stringWithString:string];
    NSString *buffer;
    for (NSInteger i = randomizedText.length - 1, j; i >= 0; i--)
    {
        j = arc4random() % (i + 1);
        buffer = [randomizedText substringWithRange:NSMakeRange(i, 1)];
        [randomizedText replaceCharactersInRange:NSMakeRange(i, 1) withString:[randomizedText substringWithRange:NSMakeRange(j, 1)]];
        [randomizedText replaceCharactersInRange:NSMakeRange(j, 1) withString:buffer];
    }
    
    return randomizedText;
}


-(NSString *) genRandStringLength: (int) len {
    
    
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randString;
}

-(void) revealLetter
{
    //TODO :Check for coins
    // clear solution knocks of characters and doesnt set back to jumbled layout, commenting it for now
    [self clearSolutionsField];
    int index = [self getRevealedCharIndex];
    if(index==-1) return;
    NSString * letter = [NSString stringWithFormat:@"%c", [answer characterAtIndex:index]];
    UILabel* lbl = [solutions objectAtIndex:index];
    if(lbl==nil) return;
    [lbl setUserInteractionEnabled:NO];
    [lbl setText:letter];
    [lbl setTextColor:[UIColor brownColor]];
    //UIColor *bgImage = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Label_Button.png"]];
    //lbl.backgroundColor= bgImage;
    [lbl setTextAlignment: NSTextAlignmentCenter];
    NSRange searchResult=[shuffledChars rangeOfString:letter];
    NSInteger jumbledIndex =searchResult.location;
    UIButton* btn = [jumbledButtons objectAtIndex:jumbledIndex];
    if(btn==nil)return;
    //UIImage *img = [UIImage imageNamed:@"Key_Button.png.png"];
    //[btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:NO];
    
    LetterHint * clue = [[LetterHint alloc] initWithSolnIndex:index withJumbledIndex:jumbledIndex];
    [puzzleManager addClue:clue];
    // revealing the letter, could have led to solution. check,if yes celebrate!
    [self didUserLevelUp];
}

-(void) clearSolutionsField
{
    for (UILabel *object in solutions) {
        if([object isUserInteractionEnabled] == NO || [[object text] length] ==0)
            continue;
        
        [self removeCharFromSolutionField:object];

    }
    
}

-(int ) getRevealedCharIndex
{
    if([remainingRandomString count]==0)return -1;
    NSArray * numbers = [remainingRandomString allKeys];
    NSMutableArray* keys= [NSMutableArray arrayWithArray:numbers];
    NSUInteger count = [keys count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n =(arc4random() % nElements) + i;
        [keys exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    int index = [[keys objectAtIndex:0] integerValue];
    [remainingRandomString removeObjectForKey:[keys objectAtIndex:0]];
    return index;
    
}

-(void) removeLetter
{
    /*
     * algorithm/pseudo code/procedure
     *
     * S1 : compute the current jumbled list, assuming this got impacted while the user used the reveal letter help
     * S2 : answer for the current puzzle is stored in a member variable within mainview controller
     * S3 : apply/use "Levenshtein Distance Algorithm" or in other words O(m*n) algorithm to compute the list of the characters that are in jumbled list, but not in answer
     * S4 : once you have list of indices that we can nuke, select the first chap and ensure its gone from the button object too
     * repeat above said steps again to remove on more letter
     */
    NSInteger i = 0;
    NSString *letterInJumbledLayout = nil;
    NSInteger removableIndex = 0;
    BOOL cantRemoveLetter = YES;
    
    //NSLog(@ "%@",shuffledChars);
    for (UIButton *letter in jumbledButtons)
    {
        letterInJumbledLayout = [letter currentTitle];
        if([[letter currentTitle] isEqual:@""] || letter.userInteractionEnabled == NO)
        {
            removableIndex ++;
            continue;
        }
        
        for(i=[randomString length]-1; i>=0; i--)
        {
            NSString *ansIter = [NSString stringWithFormat:@"%C",[randomString characterAtIndex:i]];
            if([letterInJumbledLayout isEqual:ansIter])
            {
                [letter setTitle:@"" forState:UIControlStateNormal];
                [letter setEnabled:NO];
                LetterHint * clue = [[LetterHint alloc] initWithSolnIndex:-1 withJumbledIndex:removableIndex];
                [puzzleManager addClue:clue];
                cantRemoveLetter = NO;
                randomString = [randomString stringByReplacingOccurrencesOfString:letterInJumbledLayout withString:@""];
                
                randomString = [randomString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [puzzleManager setRandomString:randomString];
                break;

            }
        }
        
        if(!cantRemoveLetter)
            break;
            
//        if(i == [answer length])
//        {
//            // if you did not find the character within the answer that's the char to be removed, do whats needed, break from the loop
//            [letter setTitle:@"" forState:UIControlStateNormal];
//            [letter setEnabled:NO];
//            LetterHint * clue = [[LetterHint alloc] initWithSolnIndex:-1 withJumbledIndex:removableIndex];
//            [puzzleManager addClue:clue];
//            cantRemoveLetter = NO;
//            break;
//        }
        removableIndex ++;
    }
    
    if(cantRemoveLetter == YES)
    {
        // after all the processing , if we cant remove the letter it means the jumbled char layout matches solution layout, throw a alert view with proper message
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"2 Pics 1 Movie" message:@"Cant remove any more letters, jumbled layout characters makes the movie name!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert setTag:-1];
        [alert show];

        
//        alertviewRemoveError = [BlockAlertView alertWithTitle:@"2 Pics 1 Movie" message:@"Cant remove any more letters, jumbled layout characters makes the movie name!"];
//        [alertviewRemoveError setDestructiveButtonWithTitle:@"Back to game!" block:^{
//            
//        }];
//        [alertviewRemoveError show];
    }
}

-(NSString *) getRandomChars
{
    NSString *firstString = shuffledChars;
    NSString *secondString = answer;
    
    NSMutableString *outputString = [NSMutableString stringWithString:firstString];
    
    [outputString enumerateSubstringsInRange:NSMakeRange(0, firstString.length) options:NSStringEnumerationByComposedCharacterSequences
                                  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                      if ([secondString rangeOfString:substring options:NSCaseInsensitiveSearch].location != NSNotFound) {
                                          [outputString deleteCharactersInRange:substringRange];
                                      }
                                  }];
    
    return outputString;
}

-(void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{
    // Handle the notificaton when the app is running
    //NSLog(@"Recieved Notification %@",notif);
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    HintType hintType = (HintType)alertView.tag;
    if(alertView.tag==-1)return;
    if(buttonIndex==0 && (hintType == 1 || hintType == 2  || hintType == 3))
    {
        [self HintProcessor:[alertView tag]];
    }
    else if(buttonIndex==0 && alertView.tag==99)
        [self showCoins:alertView];
    else if(buttonIndex==0 && alertView.tag==5)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/2-pics-1-movie/id766598120?ls=1&mt=8"]];
        
        [prefs setObject:@"yes" forKey:@"isUserRated"];
        [prefs synchronize];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onCoinsClick:(id)sender {
    
//    if(fbHelper==nil)
//        fbHelper = [[FacebookHelper alloc] init];
//    [fbHelper share:[Utility getScreenshot]];
    
    [self showIAPDialog];

}

-(BOOL) checkForPuzzlesComplete
{
    BOOL result = NO;
    if([puzzleManager getLevel]  > [puzzleManager getPuzzleCount])
    {
        PuzzleCompleteViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"complete"];
        [self.navigationController pushViewController:controller animated:YES];
        result = YES;
    }
    return result;
}

@end
