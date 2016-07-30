//
//  Utility.m
//  movie
//
//  Created by Raghu Venkatesh on 19/09/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "Utility.h"
#define BUTTONPOS 493;
#define IMAGEPOS 74;

@implementation Utility

+(NSInteger) getYJumbledLayoutPosition
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        float ver = [[[UIDevice currentDevice] systemVersion] floatValue];

        if (self.isDeviceIphone5)
        {
            if(ver < 7)
                return 360-16;
            else
                return 389;
        }
        else
        {
            if (ver < 7)
                return 295-16;
            else
                return 324;
        }
    }
    else
    {
        return 750;
    }
    
    return 0;
}

+(NSInteger) getXJumbledLayoutPosition
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        return 35;
        
        return 120;
}


+(NSInteger) getYSolutionLayoutPosition:(int)noofRows
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        
        float ver = [[[UIDevice currentDevice] systemVersion] floatValue];

        if (self.isDeviceIphone5)
        {
            if(ver < 7)
                return 230-10;
            else
                return 259-16;
        }
        else
        {
            

            if (noofRows==3)
            {
                if (ver < 7)
                    return 185-10;
                else
                    return 230-16;
            }
            else if (noofRows==2)
            {
                if (ver < 7)
                    return 195-16;
                else
                    return 240-16;
            }
            else
            {
                if (ver < 7)
                    return 225-16;
                else
                    return 270-16;
            }
        }
    }
    else
    {
        return 500;
    }
    
    return 0;
}

+(NSInteger) offsetForOdd
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        return 20;
        
        return 50;

}



+(NSInteger) getXSolutionLayoutPosition:(NSInteger)noOfCharsInRow 
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if(noOfCharsInRow< 9)
            return 35;
            
        return 30;

    }
    else
    {
        
        return 100;
    }
    
    return 0;
}

+(NSInteger) spaceBetweenLetters
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)            
        return 5;
            
    return 5;

}


+(NSInteger)spaceBetweenLines:(int) noofRows
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (self.isDeviceIphone5)
        {
            
            if(noofRows > 2)
                return 40;
            
            return 45;
        }
        else
        {
            if(noofRows > 2)
            return 35;
            
            return 40;
            
        }
    }
    else
    {
        if(noofRows > 2)
        return 90;
        
        return 100;
    }
    
    return 0;

}

+(NSInteger)spaceBetweenLinesfoSol
{
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (self.isDeviceIphone5)
        {
            return 45;
        }
        else
        {
            return 35;
            
        }
    }
    else
    {
        return 100;
    }
    
    return 0;
    
}


+(NSInteger) normalImageWidth
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)            
        return 150;
    return 300;    
    

}
+(NSInteger) fullImageWidth
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        return 290;
    
    return 650;
    
}

+(NSInteger) adjustedImageHeight
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        return 290;
    
    return 650;
}



+(void) playSound : (SoundEffect) soundEffect
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if([[prefs stringForKey:@"vol"] isEqual:@"1"] )
        return;
    
    
        NSString *sound = nil;
        
        switch (soundEffect) {
            case openImage:
                sound = @"scale-out";
                break;
            case closeImage:
                sound = @"scale-in";
                break;
            case keyTap:
                sound = @"selecting_letters";
                break;
            case keyDeselect:
                sound = @"deselecting_letters";
                break;
            case levelUp:
                sound = @"level-up-v1";
                break;
            case wrongAnswer:
                sound = @"wrong_answer";
                break;
            default:
                break;
        }
        
        if (sound != nil) {
            CFBundleRef mainBundle = CFBundleGetMainBundle();
            CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)sound, CFSTR("mp3"), NULL);
            SystemSoundID soundId;
            AudioServicesCreateSystemSoundID(soundFileURLRef, &soundId);
            AudioServicesPlaySystemSound(soundId);
            if(soundFileURLRef != nil)
            {
                CFRelease(soundFileURLRef);
            }
        }
    

}

+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key {
	return [[NSString alloc] initWithData:[ciphertext AES256DecryptWithKey:key] 	                              encoding:NSUTF8StringEncoding];
}

+(void)adjustControlPosition:(NSArray *) controlsTag withView:(UIView *)view
{
    
    for ( id i  in controlsTag) {
      UIView * control =   [view viewWithTag:[i integerValue]];
        CGRect rec= control.frame;
        if ([control class] == [UIButton class])
        {
            if (control.tag==99 ){
                rec.origin.y = 504;
            }
            else if(control.tag==100)
            {
                rec.origin.y = 497;

            }
            else
                rec.origin.y = BUTTONPOS;
        }
        else if([control class] == [UIImageView class])
        {
            rec.origin.y = IMAGEPOS;

        }
        
        control.frame = rec;
    }
    
}
+(UIImage *) getBGImageForView
{
    
    UIImage* bgImage;
    CGFloat screenHeight = self.getHeight;
    
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        bgImage = [UIImage imageNamed:@"HomePage_BG-568h"];
    } else {
        bgImage = [UIImage imageNamed:@"HomePage_BG"];
    }
    
    return bgImage;
    
    
}

+(NSInteger)getHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}
+(NSInteger)getWidth
{
    return [UIScreen mainScreen].bounds.size.width;

}

+(Boolean) isDeviceIphone5
{
    return 568.0f  == self.getHeight;
}

+(void)addMask:(UIView *)superView
{
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.getWidth, self.getHeight)];
    [mask setTag:100];
    mask.userInteractionEnabled=NO;
    mask.alpha =.3;
    //mask.backgroundColor=[UIColor redColor];

    [superView addSubview:mask];

}

+(void)enableViewControls:(UIView *)superView withValue:(BOOL)enable
{
  NSArray * controls = superView.subviews;
    for (UIView *child in controls) {
        if ([child class] != [UIButton class])continue;
        [child setUserInteractionEnabled:enable];
    }
    
    UIButton * btn = (UIButton *)[superView viewWithTag:4];
    [btn setUserInteractionEnabled:enable];

    btn = (UIButton *)[superView viewWithTag:5];
    [btn setUserInteractionEnabled:enable];

    btn = (UIButton *)[superView viewWithTag:6];
    [btn setUserInteractionEnabled:enable];
    
    UIImageView * imageView = (UIImageView *)[superView viewWithTag:1];
    [imageView setUserInteractionEnabled:enable];
    
    imageView = (UIImageView *)[superView viewWithTag:2];
    [imageView setUserInteractionEnabled:enable];



}

+(void)removeMask:(UIView *)superView
{
    [[superView viewWithTag:100] removeFromSuperview];

}


+(UIImage *) getScreenshot
{
    UIWindow * screen = [[[UIApplication sharedApplication] delegate] window];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(screen.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(screen.bounds.size);
    [screen.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //NSData * data = UIImagePNGRepresentation(image);
    //    [data writeToFile:@"foo.png" atomically:YES];
    return image;
}


+(CGFloat) getTextWidth:(NSString *) text withFontSize:(CGFloat)font withFontType:(NSString *)fontType
{
    return [text sizeWithFont:[UIFont fontWithName:fontType size:font]].width;

}

+(void)adjustControlPositionForIOS6:(NSArray *) controlsTag withView:(UIView *)view
{
    
    CGFloat screenHeight = self.getHeight;
    CGRect rec;
    if (screenHeight == 568.0f) {
        
        for ( id i  in controlsTag) {
            UIView * control =   [view viewWithTag:[i integerValue]];
            if([control class] != [UIImageView class])continue;
            rec= control.frame;
            if([i integerValue] == 3)
                rec.origin.y = 40;
            else
                rec.origin.y = 65;
            
            control.frame = rec;
        }
        
        UIButton * btn = (UIButton *)[view viewWithTag:4];
        rec = btn.frame;
        if(view.frame.size.height==568)
            rec.origin.y = 492;
        else
            rec.origin.y = 448;

        btn.frame = rec;
        
         btn = (UIButton *)[view viewWithTag:5];
        rec = btn.frame;
        if(view.frame.size.height==568)
            rec.origin.y = 492;
        else
            rec.origin.y = 448;
        btn.frame = rec;
        
        btn = (UIButton *)[view viewWithTag:6];
        rec = btn.frame;
        if(view.frame.size.height==568)
            rec.origin.y = 492;
        else
            rec.origin.y = 448;
        btn.frame = rec;



        
    }
    else{
        
        for ( id i  in controlsTag) {
            UIView * control =   [view viewWithTag:[i integerValue]];
            CGRect rec= control.frame;

            if([control class] == [UIImageView class])
            {
            if([i integerValue] == 3)
                rec.origin.y = 14;
            else
                rec.origin.y = 38.66;
            }
            control.frame = rec;
        }

        
    }
    
}


@end
