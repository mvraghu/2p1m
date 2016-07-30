//
//  RevealLetter.h
//  movie
//
//  Created by Raghu Venkatesh on 22/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoveLetter.h"

@interface RevealLetter : RemoveLetter
@property (nonatomic) NSInteger solnLetterIndex;
-(id) initWithIndex:(NSInteger)solIndex withChar:(char)revealedLetter withJumbledIndex:(NSInteger)jumbledIndex;
@end
