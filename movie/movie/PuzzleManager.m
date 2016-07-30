    //
//  PuzzleManager.m
//  tets
//
//  Created by Raghu Venkatesh on 19/04/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "PuzzleManager.h"
#import "PuzzleData.h"
#import "Puzzle.h"
#import "AppDelegate.h"

NSString  * const PUZZLE_DATA = @"userdata.bin";
NSString  * const IMG_EXT = @".jpg";
NSInteger const PUZZLE_COIN_VALUE =5;
@interface PuzzleManager ()
@end

@implementation PuzzleManager

static PuzzleManager  *instance=nil;
NSMutableDictionary *puzzlesData=nil;
PuzzleData *userData = nil;
NSInteger puzzleCount=0;
NSArray *results;
NSInteger puzzleIndex=0;

+(PuzzleManager *) getInstance{
    
    if(instance == nil)
    {
        instance = [[super allocWithZone:NULL]init];
    }
    
    return instance;
}

- (id)init {
    if ( (self = [super init]) ) {
        //[self copyPlistFileToDocument];
        NSString *path=[[self getDocDirectoryPath] stringByAppendingPathComponent:PUZZLE_DATA];
        userData =  (PuzzleData *)[NSKeyedUnarchiver unarchiveObjectWithFile:path];;
        if(userData== nil)
            userData = [[PuzzleData alloc] init];
        
    }
    return self;
}

- (NSMutableDictionary *)loadPuzzleData {
    // implement your custom code here
    if(puzzlesData != nil) return puzzlesData;
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    puzzlesData = [NSMutableDictionary dictionaryWithContentsOfFile:pListPath];
    //NSLog(@"%@", [puzzlesData objectForKey:@"Puzzle"]);
    return puzzlesData;
    
}

- (Puzzle *)getPuzzleData {
    
    //NSArray  *puzzleArray= [[self loadPuzzleData] objectForKey:@"Puzzle"];
    //NSDictionary *puzzleDic = [puzzleArray objectAtIndex:0];
    
    //NSArray *puzzleDataArray =[puzzleDic objectForKey:[self getPuzzleId]];
    //NSDictionary *puzzleDataDic = [puzzleDataArray objectAtIndex:0];
    
    if(results==Nil)
    {
        NSManagedObjectContext *moc =   [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"puzzle_id" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Puzzle" inManagedObjectContext:moc];
        [fetchRequest setEntity:entity];
        NSError *err = nil;
        
        NSArray * temp = [moc executeFetchRequest:fetchRequest error:&err];
        results = [moc executeFetchRequest:fetchRequest error:&err];
        
        results = [temp sortedArrayUsingComparator: ^(Puzzle *a1, Puzzle *a2) {
            if ([[a1 puzzle_id] intValue]  > [[a2 puzzle_id] intValue]  ) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[a1 puzzle_id] intValue] < [[a2 puzzle_id] intValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];



        //results = [self shuffle:[NSMutableArray arrayWithArray:results]];

    }
    Puzzle * puzzleObj;
    if(![userData isCurrentPuzzlePlayed])
    {
        [userData clearClue];
        puzzleObj = (Puzzle *)[results objectAtIndex:puzzleIndex];
        NSInteger pId = [[puzzleObj puzzle_id] intValue];
        while ([userData isPuzzlePlayed:pId]) {
            puzzleIndex++;
            puzzleObj = (Puzzle *)[results objectAtIndex:puzzleIndex];
            pId = [[puzzleObj puzzle_id] intValue];
            
        }

        [userData setRandNumber:pId];

    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"puzzle_id == %@",[NSString stringWithFormat:@"%d", [userData getRandNumber]] ];
        NSArray *filtered  = [results filteredArrayUsingPredicate:predicate];

        if(filtered!=nil && [filtered count] > 0 )
            puzzleObj = [filtered objectAtIndex:0];
    }

    
    return puzzleObj;
    
}


// singleton methods
+ (id)allocWithZone:(NSZone *)zone {
    return [self getInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


-(NSString *) getDocDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
    
}


-(void) saveUserData
{
    [userData saveCurrentPuzzleNumber];
    [self incrementLevel];
    [self incrementCoins:5];
    
}

-(void) persistToDisk
{
    
    NSString *path=[[self getDocDirectoryPath] stringByAppendingPathComponent:PUZZLE_DATA];
    [NSKeyedArchiver archiveRootObject:userData toFile:path];
    
}

-(void) incrementLevel
{
    [userData incrementLevel];
    
}

-(void) incrementCoins : (NSInteger) Coins
{
    
    [userData incrementCoins: Coins ];
    
}

-(void) decrementCoins:(NSInteger) coins
{
    [userData decrementCoins: coins];
    
}

-(BOOL) canPurchase:(NSInteger) coins
{
    return [userData canPurchase: coins];
}

-(NSInteger) getLevel
{
    return userData.getLevel;
}

-(NSInteger) getCoins
{
    return userData.getCoins;
}

-(NSString *) getPuzzleId
{
    //NSLog(@"%@", [NSString stringWithFormat:@"_%i", [userData getRandNumber]]);
    
    return  [NSString stringWithFormat:@"_%i", [userData getRandNumber]]   ;
}


-(NSString *) constructPuzzleImagePath:(NSInteger) picNumber
{
    NSString * imagePth= [self.getPuzzleId stringByAppendingFormat:[NSString stringWithFormat:@"_%i", picNumber]];
    //NSLog(@"%@", [imagePth stringByAppendingFormat:IMG_EXT]);
    
    return [imagePth stringByAppendingFormat:IMG_EXT];
}


-(NSInteger) getPuzzleCount
{
//    NSArray  *puzzleArray= [puzzlesData objectForKey:@"Puzzle"];
//    NSDictionary *puzzleDic = [puzzleArray objectAtIndex:0];
//    return [puzzleDic count];
    
    if(puzzleCount!=0)return puzzleCount;
    
    NSManagedObjectContext *moc =   [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Puzzle" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];    
    NSError *err = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&err];
    
    puzzleCount=results.count;
    return results.count;

}

-(NSArray *) shuffle:(NSMutableArray *) puzzles
{
    
    NSUInteger count = [puzzles count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [puzzles exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return puzzles;
}


-(void) addClue:(LetterHint *)clue;
{
    [userData addClue:clue];
}

-(BOOL) containsRevealedLetter:(NSInteger)solnIndex
{
    return  [userData containsRevealedLetter:solnIndex];
}
-(BOOL) containsRemovedLetter:(NSInteger)jumbledIndex
{
    return  [userData containsRemovedLetter:jumbledIndex];
    
}

-(void) setShuffledString:(NSString *)letters
{
    [userData setShuffledString:letters];
}
-(NSString *) getShuffledString
{
    return [userData getShuffledString];
}

-(Boolean) isHintUsed
{
    return [userData getHintUsed];
}

-(void) setIsHintUsed:(Boolean) val
{
    [userData setHintUsed:val];

}

-(void) setRandomString:(NSString *)letters
{
    [userData setRandomString:letters];

    
}
-(NSString *) getRandomString
{
    return [userData getRandomString];
}


@end
