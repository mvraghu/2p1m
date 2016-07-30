//
//  BlockUI.h
//
//  Created by Gustavo Ambrozio on 14/2/12.
//

#ifndef BlockUI_h
#define BlockUI_h

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
#define NSTextAlignmentCenter       UITextAlignmentCenter
#define NSLineBreakByWordWrapping   UILineBreakModeWordWrap
#define NSLineBreakByClipping       UILineBreakModeClip

#endif

#ifndef IOS_LESS_THAN_6
#define IOS_LESS_THAN_6 !([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)

#endif

#define NeedsLandscapePhoneTweaks (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)


// Action Sheet constants

#define kActionSheetBounce         10
#define kActionSheetBorder         20
#define kActionSheetButtonHeight   30
#define kActionSheetTopMargin      15

#define kActionSheetTitleFont           [UIFont fontWithName:@"AngryBirds-Regular" size:20]
#define kActionSheetTitleTextColor      [UIColor whiteColor]
#define kActionSheetTitleShadowColor    [UIColor blackColor]
#define kActionSheetTitleShadowOffset   CGSizeMake(0, -1)

#define kActionSheetButtonFont          [UIFont fontWithName:@"AngryBirds-Regular" size:20]
#define kActionSheetButtonTextColor     [UIColor whiteColor]
#define kActionSheetButtonShadowColor   [UIColor blackColor]
#define kActionSheetButtonShadowOffset  CGSizeMake(0, -1)

#define kActionSheetBackground              @"rainbow2_scaled2.jpg"
#define kActionSheetBackgroundCapHeight     20


// Alert View constants

#define kAlertViewBounce         40
#define kAlertViewBorder         (NeedsLandscapePhoneTweaks ? 5 : 10)
#define kAlertButtonHeight       (NeedsLandscapePhoneTweaks ? 35 : 44)


#define kAlertViewTitleFont             [UIFont fontWithName:@"AngryBirds-Regular" size:20]
#define kAlertViewTitleTextColor        [UIColor blackColor]
#define kAlertViewTitleShadowColor      [UIColor blackColor]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, -1)

#define kAlertViewMessageFont           [UIFont fontWithName:@"AngryBirds-Regular" size:20]
#define kAlertViewMessageTextColor      [UIColor blackColor]
#define kAlertViewMessageShadowColor    [UIColor blackColor]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, -1)

#define kAlertViewButtonFont            [UIFont fontWithName:@"AngryBirds-Regular" size:20]
#define kAlertViewButtonTextColor       [UIColor blackColor]
#define kAlertViewButtonShadowColor     [UIColor blackColor]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, -1)

#define kAlertViewBackground            @"rainbow2_scaled2.jpg"
#define kAlertViewBackgroundLandscape   @"alert-window-landscape.png"
#define kAlertViewBackgroundCapHeight   20

#endif
