//
//  MovieApplication.m
//  movie
//
//  Created by Raghu Venkatesh on 09/11/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "MovieApplication.h"
#import "LocalNotifManager.h"
#import "MainViewController.h"

@implementation MovieApplication

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    // Fire up the timer upon first event
    // Check to see if there was a touch event
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan) {
            [self resetAnimateHintButtonsTimer];
        }
    }
}

- (void)resetIdleTimer
{
    if (_idleTimer) {
        [_idleTimer invalidate];
    }
    
    // Schedule a timer to fire in kApplicationTimeoutInMinutes * 60
    int timeout = 10;
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                   target:self
                                                 selector:@selector(idleTimerExceeded)
                                                 userInfo:nil
                                                  repeats:NO];
    
}

- (void)resetAnimateHintButtonsTimer
{
    if (_animateHintButtonsTimer) {
        [_animateHintButtonsTimer invalidate];
    }
    
    // Schedule a timer to fire in kApplicationTimeoutInMinutes * 60
    int timeout = 8;
    _animateHintButtonsTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(HintAnimationsIdleTimerExceeded)
                                                userInfo:nil
                                                 repeats:YES];
    
}

- (void)idleTimerExceeded {
    /* Post a notification so anyone who subscribes to it can be notified when
     * the application times out */
    
    [LocalNotifManager sendLocalNotif];
}

- (void) HintAnimationsIdleTimerExceeded {
    [MainViewController animateHints];
}

@end
