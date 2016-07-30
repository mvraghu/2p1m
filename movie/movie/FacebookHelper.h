//
//  FacebookHelper.h
//  faceBookDemo
//
//  Created by Raghu Venkatesh on 07/11/13.
//
//
#import "FBConnect.h"
#import <Foundation/Foundation.h>


static NSString* kAppId = @"320714844736165";
#define KFBAccessToken		@"320714844736165"
#define KFBExpirationDate	@"KFBExpirationDate"

@interface FacebookHelper : NSObject <UIApplicationDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate> {
	Facebook* _facebook;
	NSArray* _permissions;
    UIImage * screenShot;
}

-(void)share:(UIImage *)screenshot;

@end
