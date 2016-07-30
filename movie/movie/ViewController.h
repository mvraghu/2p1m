//
//  ViewController.h
//  movie
//
//  Created by Raghu Venkatesh on 08/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Utility.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate>
{
    MainViewController *mViewHandle;
    UINavigationController *navController;
    
}
- (IBAction)onVolumePress:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *volume;
@property (strong, nonatomic) IBOutlet UIButton *levelButton;


@end
