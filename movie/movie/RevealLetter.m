//
//  RevealLetter.m
//  movie
//
//  Created by Raghu Venkatesh on 22/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "RevealLetter.h"

@implementation RevealLetter 

@synthesize solnLetterIndex;


-(id)initWithIndex:(NSInteger)solIndex withChar:(char)revealedLetter withJumbledIndex:(NSInteger)jumbledIndex
{
    
    self =[super initWithIndex:jumbledIndex withChar:revealedLetter];
    self.solnLetterIndex = solIndex;
    return self;
}
@end
