//
//  LetterHint.h
//  movie
//
//  Created by Raghu Venkatesh on 24/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LetterHint : NSObject
@property (nonatomic) NSInteger jumbledIndex;
//incase of remove letter solnIndex will be -1
@property (nonatomic) NSInteger solnIndex;
-(id) initWithSolnIndex :(NSInteger) solnPadIndex withJumbledIndex :(NSInteger) keyPadIndex;
@end
