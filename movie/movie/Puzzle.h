//
//  Puzzle.h
//  puzzle
//
//  Created by Raghu Venkatesh on 30/07/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Puzzle : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * puzzle_id;
@property (nonatomic, retain) NSData * hint;
@property (nonatomic, retain) NSString * credit1;
@property (nonatomic, retain) NSString * credit2;
@property (nonatomic, retain) NSData * answer;

@end
