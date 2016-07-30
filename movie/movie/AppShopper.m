//
//  AppShopper.m
//  movie
//
//  Created by Shankara Seethappa on 27/11/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "AppShopper.h"
#import "PuzzleManager.h"
#import "MainViewController.h"
#import "Countly.h"
#import <AdColony/AdColony.h>


@implementation AppShopper

#define productId @"com.bitpanda.2p1m.POC"

@synthesize request = _request;
@synthesize product = _product;

- (void) request:(SKRequest *)request didFailWithError:(NSError *)error{
    printf("Error!\n");
    //_request = nil;
    //_product = nil;
}

- (void) requestDidFinish:(SKRequest *)request {
    printf("Finished request!\n");
}

- (void) requestProductData :(NSString *) ProductId{
    printf("requestProductData\n");
    
    NSSet *productIdentifiers = [NSSet setWithObject:ProductId];
    
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers: productIdentifiers];
    
    self.request.delegate = [MainViewController getAppShopperSharedInstance];
    self.request.delegate = self;
    [self.request start];
    
    printf("requestProductData End\n");
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    printf("productsRequest\n");
    NSArray *products = response.products;
    
    NSString *custId = [AdColony getCustomID];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:custId, @"uzid", nil];
    [[Countly sharedInstance] recordEvent:@"IAP_RESPONSE_RECVD" segmentation:dict count:1];
    
    self.product = [products count] == 1 ? [products objectAtIndex:0] : nil;
    if (self.product)
    {
        NSLog(@"Product title: %@" , self.product.localizedTitle);
        NSLog(@"Product description: %@" , self.product.localizedDescription);
        NSLog(@"Product price: %@" , self.product.price);
        NSLog(@"Product id: %@" , self.product.productIdentifier);
        
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    //_request = nil;
    //_product = nil;
    
    SKPayment *payment = [SKPayment paymentWithProduct:(SKProduct *)self.product];
    if ([SKPaymentQueue canMakePayments])
    {
        //SKPayment *payment = [SKPayment paymentWithProduct:(SKProduct *)iAP_prod];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        //AppShopper *currentInstance = [MainViewController getAppShopperSharedInstance];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Authorized"
                              message:@"Not authorized to purchase."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }

    //[[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    [MainViewController stopAnimation];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSString *messageToBeShown = [NSString
                                      stringWithFormat:@"Reason: %@, You can try: %@",
                                      [transaction.error localizedFailureReason],
                                      [transaction.error localizedRecoverySuggestion]];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Unable to complete your purchase"
                              message:messageToBeShown
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
        [alert show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = self.product.productIdentifier;
    NSInteger prodIden = [productIdentifier intValue];
    NSInteger grantCoins = 0;
    switch(prodIden)
    {
        case 100:
            grantCoins = 250;
            break;
        case 200:
            grantCoins = 750;
            break;
        case 300:
            grantCoins = 1250;
            break;
        case 400:
            grantCoins = 2500;
            break;
    }
    PuzzleManager *puzzleManager = [PuzzleManager getInstance];
    [puzzleManager incrementCoins:grantCoins];
    [MainViewController updateCoins];
    // persist coins info to the disk, IAP are critical, its consumer's $$
    [[PuzzleManager getInstance] persistToDisk];
    [MainViewController stopAnimation];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSString *custId = [AdColony getCustomID];
    NSString *inStr = [NSString stringWithFormat: @"%d", (int)grantCoins];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:custId, @"uzid",
                           inStr, @"COINS_GRANTED", nil];
    [[Countly sharedInstance] recordEvent:@"IAP_GRANT_VIRTUAL_GOOD_DONE" segmentation:dict count:1];
    
}


@end
