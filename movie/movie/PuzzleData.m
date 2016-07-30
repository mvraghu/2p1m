    //
//  PuzzleData.m
//  OddManOut
//
//  Created by Raghu Venkatesh on 23/05/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "PuzzleData.h"

@implementation PuzzleData
{
    NSInteger coins;
    NSInteger levels;
    NSMutableArray * solvedPuzzles;
    NSMutableArray * clues;
    NSInteger randNumber;
    NSString *randomLetters;
    Boolean hintUsed;
    NSString *randomString;

}
-(id)init
{
    if ( (self = [super init]) )
    {
        levels=1;
        coins=350;
        randNumber=0;
        solvedPuzzles = [[NSMutableArray alloc] init];
        clues=[[NSMutableArray alloc] init];
        hintUsed = NO;
        
    }
    
    return self;
}

-(void)incrementCoins:(NSInteger)coin
{
    coins+=coin;
}

-(void)decrementCoins:(NSInteger)coin
{
    coins=coins-coin;
    
}

-(BOOL)canPurchase:(NSInteger)coin
{
    if(coin > coins || coins < 0)
    {
        return FALSE;
    }
    return TRUE;
}

-(NSInteger) getCoins
{
    return coins;
}

-(void)incrementLevel
{
    levels+=1;
}

-(NSInteger)getLevel
{
    return levels;
}

-(NSInteger)getRandNumber
{
    //NSLog(@"%i" , randNumber);
    return randNumber;
}

-(void)setRandNumber:(NSInteger)rand
{
    randNumber=rand;
    //randNumber = 92;
    //NSLog(@"%i" , randNumber);
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:clues];
    [encoder encodeObject:serialized forKey:@"clues"];
    [encoder encodeObject:[NSString stringWithFormat:@"%d",coins] forKey:@"coins"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@",randomLetters] forKey:@"randomstring"];
    [encoder encodeObject:[NSString stringWithFormat:@"%d",levels] forKey:@"levels"];
    [encoder encodeObject:[NSString stringWithFormat:@"%d",randNumber] forKey:@"rand"];
    [encoder encodeObject:[NSString stringWithFormat:@"%hhu",hintUsed] forKey:@"hintUsed"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@",[solvedPuzzles componentsJoinedByString:@","]] forKey:@"solvedpuzzle"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@",randomString] forKey:@"randomLetter"];

    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        NSData *dataRepresentingSavedArray = [decoder decodeObjectForKey:@"clues"];
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            clues = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            clues = [[NSMutableArray alloc] init];
        coins = [[decoder decodeObjectForKey:@"coins"]intValue];
        levels = [[decoder decodeObjectForKey:@"levels"] intValue];
        randNumber = [[decoder decodeObjectForKey:@"rand"] intValue];
        hintUsed = [[decoder decodeObjectForKey:@"hintUsed"] boolValue];

        randomLetters = [decoder decodeObjectForKey:@"randomstring"];
        
        //[createMutableArray:
        NSArray * puzzles = [[decoder decodeObjectForKey:@"solvedpuzzle"] componentsSeparatedByString:@","];
        solvedPuzzles =  [NSMutableArray arrayWithArray:puzzles];
        if(levels==0)
            levels=1;
        if(solvedPuzzles==nil)
            solvedPuzzles = [[NSMutableArray alloc] init];
        
        //NSLog(@"%@", solvedPuzzles);
        
        randomString = [decoder decodeObjectForKey:@"randomLetter"];

        
    }
    return self;
}

-(BOOL) isCurrentPuzzlePlayed
{
    return ![self isPuzzlePlayed:randNumber] &&  randNumber!=0;
}

-(BOOL) isPuzzlePlayed:(NSInteger)puzzleNumber
{
    //NSLog(@" %s", [solvedPuzzles containsObject:[NSNumber numberWithInteger:puzzleNumber]]  ? "true" : "false");
    for (id  num in solvedPuzzles) {
        if([num integerValue] !=puzzleNumber)continue;
            return true;
    }
    return false;
}

-(void) saveCurrentPuzzleNumber
{
    [solvedPuzzles addObject:[NSNumber numberWithInteger:randNumber]];
    //NSLog(@"array: %@", solvedPuzzles);
}

-(void) addClue:(LetterHint *)clue
{
    [clues addObject:clue];
}

-(void) clearClue
{
    [clues removeAllObjects];
    [self setShuffledString:@""];
    [self setRandomString:@""];

    hintUsed = NO;
}

-(BOOL) containsRevealedLetter:(NSInteger)solnIndex
{
    for (LetterHint* hint in clues) {
        if(hint.solnIndex!=solnIndex || hint.solnIndex==-1)continue;
        return YES;
    }
    return NO;
}

-(BOOL) containsRemovedLetter:(NSInteger)jumbledIndex
{
    for (LetterHint* hint in clues) {
        if(hint.jumbledIndex!=jumbledIndex)continue;
        return YES;
    }
    return NO;
}

-(void) setShuffledString:(NSString *)letters
{
    randomLetters=letters;
}
-(NSString *) getShuffledString
{
    return randomLetters;
}

-(void) setHintUsed:(Boolean)value
{
    hintUsed =value;
}


-(Boolean) getHintUsed
{
    return hintUsed;
}

-(void) setRandomString:(NSString *)letters
{
    randomString = letters;
}
-(NSString *) getRandomString
{
    return randomString;
}

@end
