
#import <UIKit/UIKit.h>
#import "PRTween.h"

@interface PRTweenViewController : UIViewController {
    
    UIView *testView;
    PRTweenOperation *activeTweenOperation;
    
}

- (IBAction)defaultTapped;
- (IBAction)bounceOutTapped;
- (IBAction)quintOutTapped;
- (IBAction)pointLerpTapped;
- (IBAction)rectLerpTapped;
- (IBAction)verboseTapped;
- (IBAction)blockTapped;
- (IBAction)shorthandTapped;

@end
