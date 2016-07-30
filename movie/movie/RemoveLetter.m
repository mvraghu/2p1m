//
//  RemoveLetter.m
//  movie
//
//  Created by Raghu Venkatesh on 22/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "RemoveLetter.h"

@implementation RemoveLetter
@synthesize letter , jumbledIndex;


-(id) initWithIndex:(NSInteger)index withChar:(char)removedLetter
{
    self = [super init];    
    self.letter= letter;
    self.jumbledIndex =index;
    return self;
}

@end
