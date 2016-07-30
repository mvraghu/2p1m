//
//  PuzzleManager.h
//  tets
//
//  Created by Raghu Venkatesh on 19/04/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LetterHint.h"

@interface PuzzleManager : NSObject
{
    
}
+ (PuzzleManager *) getInstance ;
-(NSDictionary *)getPuzzleData;
-(void) saveUserData;
-(void) persistToDisk;
-(void) incrementLevel;
-(void) incrementCoins:(NSInteger) coins;
-(void) decrementCoins:(NSInteger) coins;
-(BOOL) canPurchase:(NSInteger) coins;
-(NSInteger) getLevel;
-(NSInteger) getCoins;
-(NSString *) constructPuzzleImagePath:(NSInteger) picNumber;
-(NSInteger) getPuzzleCount;
-(void) addClue:(LetterHint *)clue;
-(BOOL) containsRevealedLetter:(NSInteger)solnIndex;
-(BOOL) containsRemovedLetter:(NSInteger)jumbledIndex;
-(void) setShuffledString:(NSString *)letters;
-(NSString *) getShuffledString;
-(Boolean) isHintUsed;
-(void) setIsHintUsed:(Boolean) val;
-(void) setRandomString:(NSString *)letters;
-(NSString *) getRandomString;

@end
