//
//  LetterHint.m
//  movie
//
//  Created by Raghu Venkatesh on 24/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "LetterHint.h"

@implementation LetterHint 
@synthesize solnIndex,jumbledIndex;
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSString stringWithFormat:@"%d",solnIndex] forKey:@"solnIndex"];
    [encoder encodeObject:[NSString stringWithFormat:@"%d",jumbledIndex] forKey:@"jumbledIndex"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        solnIndex = [[decoder decodeObjectForKey:@"solnIndex"]intValue];
        jumbledIndex = [[decoder decodeObjectForKey:@"jumbledIndex"] intValue];
        
    }
    return self;
}

-(id) initWithSolnIndex :(NSInteger) solnPadIndex withJumbledIndex :(NSInteger) keyPadIndex;
{
    
    if ( (self = [super init]) )
    {
        solnIndex=solnPadIndex;
        jumbledIndex=keyPadIndex;
    }
    return self;

}

@end
