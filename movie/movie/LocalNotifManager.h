//
//  LocalNotifManager.h
//  movie
//
//  Created by Shankara Seethappa on 16/07/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotifManager : NSObject
+ (void) sendLocalNotif;
+(void) cancelLocalNotif;
@end
