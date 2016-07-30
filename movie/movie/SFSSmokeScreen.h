//
//  SFSSmokeScreen.h
//  localnotifiaion
//
//  Created by Raghu Venkatesh on 18/08/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSSmokeScreen : UIView
-(id)initWithFrame:(CGRect)frame emitterFrame:(CGRect)emitterFrame;
-(void)setIsEmitting;
@end
