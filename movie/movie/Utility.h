//
//  Utility.h
//  movie
//
//  Created by Raghu Venkatesh on 19/09/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSData+AES256.h"

@interface Utility : NSObject

typedef enum {
    openImage,
    closeImage,
    keyTap,
    levelUp,
    keyDeselect,
    wrongAnswer,
} SoundEffect;

typedef enum {
    None =0 ,
    removeLetter =1,
    revealLetter=2,
    showHint=3,
} HintType;


+(NSInteger)getYSolutionLayoutPosition:(int) noofRows;
+(NSInteger)getXSolutionLayoutPosition:(NSInteger)noOfCharsInRow ;
+(NSInteger)getYJumbledLayoutPosition;
+(NSInteger)getXJumbledLayoutPosition;
+(void)playSound: (SoundEffect) soundEffect;
+(NSInteger) spaceBetweenLines:(int) noofRows;
+(NSInteger) offsetForOdd;
+(NSInteger) spaceBetweenLetters;
+(NSInteger) normalImageWidth;
+(NSInteger) fullImageWidth;
+(NSInteger) adjustedImageHeight;
+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key ;
+(NSInteger)spaceBetweenLinesfoSol;
+(void)adjustControlPosition:(NSArray *) controlsTag withView:(UIView *)view;
+(UIImage *) getBGImageForView;
+(NSInteger)getHeight;
+(NSInteger)getWidth;
+(Boolean) isDeviceIphone5;
+(void) addMask:(UIView *)superView;
+(void) removeMask:(UIView *)superView;
+(UIImage *) getScreenshot;
+(void)enableViewControls:(UIView *)superView withValue:(BOOL)enable;
+(CGFloat) getTextWidth:(NSString *) text withFontSize:(CGFloat)font withFontType:(NSString *)font;
+(void)adjustControlPositionForIOS6:(NSArray *) controlsTag withView:(UIView *)view;

@end
