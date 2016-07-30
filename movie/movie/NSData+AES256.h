//
//  NSData+AES256.h
//  puzzle
//
//  Created by Raghu Venkatesh on 03/08/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
- (NSData *)AES256EncryptWithKey:(NSString *)key ;
- (NSData *)AES256DecryptWithKey:(NSString *)key ;

@end
