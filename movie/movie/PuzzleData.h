//
//  PuzzleData.h
//  OddManOut
//
//  Created by Raghu Venkatesh on 23/05/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LetterHint.h"
@interface PuzzleData : NSObject
-(id)init;
-(void)incrementCoins:(NSInteger)coins;
-(void)decrementCoins:(NSInteger)coins;
-(BOOL)canPurchase:(NSInteger)coins;
-(void)incrementLevel;
-(NSInteger)getCoins;
-(NSInteger)getLevel;
-(NSInteger)getRandNumber;
-(NSString *) getShuffledString;
-(void)setRandNumber:(NSInteger)rand;
-(BOOL) isPuzzlePlayed:(NSInteger) puzzleNumber;
-(BOOL) isCurrentPuzzlePlayed;
-(void) saveCurrentPuzzleNumber;
-(void) addClue:(LetterHint *)clue;
-(void) clearClue;
-(BOOL) containsRevealedLetter:(NSInteger)solnIndex;
-(BOOL) containsRemovedLetter:(NSInteger)jumbledIndex;
-(void) setShuffledString:(NSString *)letters;
-(void) setHintUsed:(Boolean)value;
-(Boolean)getHintUsed;
-(void) setRandomString:(NSString *)letters;
-(NSString *) getRandomString;


@end