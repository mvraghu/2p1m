//
//  MainViewController.h
//  movie
//
//  Created by Raghu Venkatesh on 08/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import <StoreKit/StoreKit.h>
#import <iAd/iAd.h>
#import "AppShopper.h"
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface MainViewController : UIViewController <UIAlertViewDelegate,GADBannerViewDelegate,GADInterstitialDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *firstPic;
@property (strong, nonatomic) IBOutlet UIImageView *secondPic;
@property (strong, nonatomic) IBOutlet UIButton *hint_button;
@property (strong, nonatomic) IBOutlet UIButton *remove_button;
@property (strong, nonatomic) IBOutlet UIButton *reveal_button;


+(void) animateHints;
+(void) updateCoins;
+(void) stopAnimation;
+(AppShopper *) getAppShopperSharedInstance;

@end
 