//
//  SFSSmokeScreen.m
//  localnotifiaion
//
//  Created by Raghu Venkatesh on 18/08/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "SFSSmokeScreen.h"
#import <QuartzCore/QuartzCore.h>

@implementation SFSSmokeScreen
{
    __weak CAEmitterLayer*smokeEmitter;
}
-(id)initWithFrame:(CGRect)frame emitterFrame:(CGRect)emitterFrame{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        smokeEmitter = (CAEmitterLayer*)self.layer;
        smokeEmitter.emitterPosition = CGPointMake(emitterFrame.origin.x + emitterFrame.size.width / 2,
                                                   emitterFrame.origin.y + emitterFrame.size.height / 2);
        smokeEmitter.emitterSize = emitterFrame.size;
        smokeEmitter.emitterShape = kCAEmitterLayerRectangle;
        
        CAEmitterCell*smokeCell = [CAEmitterCell emitterCell];
        smokeCell.contents = (__bridge id)[[UIImage imageNamed:@"SmokeParticle.png"] CGImage];
        [smokeCell setName:@"smokeCell"];
        
        smokeCell.birthRate = 150;
        smokeCell.lifetime = 10.0;
        smokeCell.lifetimeRange = 0.5;
        smokeCell.color = [[UIColor colorWithRed:1 green:0.6 blue:0.6 alpha:1.0] CGColor];
        smokeCell.redRange = 1.0;
        smokeCell.redSpeed = 0.5;
        smokeCell.blueRange = 1.0;
        smokeCell.blueSpeed = 0.5;
        smokeCell.greenRange = 1.0;
        smokeCell.greenSpeed = 0.5;
        smokeCell.alphaSpeed = -0.2;
        
        smokeCell.velocity = 50;
        smokeCell.velocityRange = 20;
        smokeCell.yAcceleration = -100;
        smokeCell.emissionLongitude = -M_PI / 2;
        smokeCell.emissionRange = M_PI / 4;
        
        smokeCell.scale = 1.0;
        smokeCell.scaleSpeed = 1.0;
        smokeCell.scaleRange = 1.0;
        
        smokeEmitter.emitterCells = [NSArray arrayWithObject:smokeCell];

    }
    return self;
}

+ (Class) layerClass {
    return [CAEmitterLayer class];
}

- (void) stopEmitting {
    smokeEmitter.birthRate = 0.0;
}
-(void)setIsEmitting
{
    [smokeEmitter setValue:[NSNumber numberWithInt:200] forKeyPath:@"emitterCells.smokeCell.birthRate"];

    
}
@end
