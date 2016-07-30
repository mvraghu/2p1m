//
//  AppShopper.h
//  movie
//
//  Created by Shankara Seethappa on 27/11/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface AppShopper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, strong) SKProductsRequest *request;


- (void) requestProductData:(NSString *) ProductId;

@end
