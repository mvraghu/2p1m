//
//  FacebookHelper.m
//  faceBookDemo
//
//  Created by Raghu Venkatesh on 07/11/13.
//
//

#import "FacebookHelper.h"

@implementation FacebookHelper


-(id)init
{
    
    if ( (self = [super init]) ) {

        _permissions =  [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil];
        _facebook = [[Facebook alloc] initWithAppId:kAppId];
    }
    
    return self;


}


- (void)login {
	[_facebook authorize:_permissions delegate:self];
}

- (void)logout {
	[_facebook logout:self];
}

- (void)fbDidLogin{
	[[NSUserDefaults standardUserDefaults] setObject:_facebook.accessToken forKey:KFBAccessToken];
	[[NSUserDefaults standardUserDefaults] setObject:_facebook.expirationDate forKey:KFBExpirationDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [self sharewithFacebook];
    
}

-(void)fbDidNotLogin:(BOOL)cancelled {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:KFBAccessToken];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:KFBExpirationDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fbDidLogout {
	
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
    
    UIAlertView *avx=[[UIAlertView alloc] initWithTitle:@"Share via Facebook"
                                                 message:@"Details successfully posted to your wall."
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [avx show];
    
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
};

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	
};

- (void)dialogDidComplete:(FBDialog *)dialog {
	
}

- (void)dialogCompleteWithUrl:(NSURL *)url{
	NSLog(@"%@",url);
	NSLog(@"Here in Dialog complete");
	if([[url description] hasPrefix:@"fbconnect://success?error_code="]){
		
	} else {
		UIAlertView *avx=[[UIAlertView alloc] initWithTitle:@"Share via Facebook"
													 message:@"Details successfully posted to your wall."
													delegate:self
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil];
		[avx show];
	}
}

- (void)dialogDidNotCompleteWithUrl:(NSURL *)url{
	NSLog(@"Here in Dialog did not complete with URL.");
}

- (void)dialogDidNotComplete:(FBDialog *)dialog{
	NSLog(@"Here in Dialog did not complete.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
	NSLog(@"Dilog got an error :) .");
	UIAlertView *avx=[[UIAlertView alloc] initWithTitle:@"Oh dear! We ran into a problem."
												 message:@"Sorry, there is no network connection. Please check your network and try again."
												delegate:self
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil];
	[avx show];
}

-(void)sharewithFacebook
{
	NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
    
    NSString *wallPost = @"Can you guess the movie?.";
    NSString *linkURL  = @"http://itunes.com/apps/2pic1movie";
    NSString *imgURL   = @"http://1.bp.blogspot.com/_dvR8dWAwpgs/SwK8syJh_9I/AAAAAAAAANs/_QURB8MjpNE/s1600/movie.gif";
    
    [fbArguments setObject:@"checkout the puzzle about the movie." forKey:@"name"];
    [fbArguments setObject:@"2 pic 1 movie." forKey:@"caption"];
    [fbArguments setObject:@"2 pics one movie is movie puzzle based on the pictures given." forKey:@"description"];
    [fbArguments setObject:wallPost forKey:@"message"];
    [fbArguments setObject:linkURL  forKey:@"link"];
    [fbArguments setObject:imgURL  forKey:@"picture"];
    
    [_facebook requestWithGraphPath:@"feed"
                          andParams:fbArguments
                      andHttpMethod:@"POST"
                        andDelegate:self];
	
}

-(void)share:(UIImage *)screenshot
{
    
    screenShot=screenshot;
	if ([_facebook isSessionValid]) {
		[self sharewithFacebook];
	} else {
		[self login];
        
	}
}


@end
