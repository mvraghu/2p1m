//
//  RemoveLetter.h
//  movie
//
//  Created by Raghu Venkatesh on 22/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoveLetter : NSObject
{
    
}
@property (nonatomic) char letter;
@property (nonatomic) NSInteger jumbledIndex;
-(id )initWithIndex:(NSInteger) index withChar:(char) removedLetter;
@end
