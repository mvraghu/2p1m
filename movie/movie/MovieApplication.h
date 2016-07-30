//
//  MovieApplication.h
//  movie
//
//  Created by Raghu Venkatesh on 09/11/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieApplication : UIApplication
{
    NSTimer *_idleTimer;
    NSTimer *_animateHintButtonsTimer;
}

- (void) resetIdleTimer;
- (void) resetAnimateHintButtonsTimer;
@end
