//
//  LocalNotifManager.m
//  movie
//
//  Created by Shankara Seethappa on 16/07/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "LocalNotifManager.h"

@implementation LocalNotifManager



+(void) sendLocalNotif
{
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSDate *currentDate = [NSDate date];
    NSDate *fireDate = nil;
    NSArray *lnLoot = @[ @"2p1m is fun, come back and play",
                         @"Hints help solve!, sorry for being obvious, lets play 2p1m",
                         @"Don't give up yet, hints are your best friends",
                         @"We know you are a movie lover, try your luck today, play 2p1m!",
                         @"Movie puzzle awaits you!, come back lets play!",
                         @"2 pics make a movie, thats about it, lets play!"];
    
    
    [dateComponents setHour:4];
    [dateComponents setMinute:1];
    [dateComponents setSecond:5];
    
    fireDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                             toDate:currentDate
                                                            options:0];
    localNotification.fireDate = fireDate;
    localNotification.repeatInterval= NSWeekCalendarUnit;
    NSUInteger index = rand() % lnLoot.count;
    localNotification.alertBody = [lnLoot objectAtIndex:index];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertAction =@"2P1M Alert";
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}

+(void) cancelLocalNotif
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications ];
}


@end
