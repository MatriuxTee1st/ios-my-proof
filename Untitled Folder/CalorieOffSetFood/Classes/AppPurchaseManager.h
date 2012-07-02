//
//  AppPurchaseManager.h
//  iAnki
//
//  Created by  on 11/12/24.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef enum {
    appPurchasePaymentFailNotConnectItunesStore = 0,
    appPurchasePaymentFailNotProductID,
    appPurchasePaymentFailCancelAction,
    appPurchasePaymentFailNotAllowed,
    appPurchasePaymentFailInvaliedAppleID
}appPurchasePaymentFail;

@interface AppPurchaseManager : NSObject 
<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    id _delegate; // デリゲート
    SKProductsRequest *theRequest;
}

@property(nonatomic, assign) id _delegate;

- (BOOL) canMakePayments;
- (void) requestProductData:(NSString *)identifier;
- (void) cancelRequest;

+ (void) setReceiptData:(NSData *)receipt purchaseRecipeId:(int)recipeId;
+ (void) removeReceiptData:(int)recipeId;
+ (void) removeAllReceiptData;
+ (NSDictionary *) receiptData;

@end

@protocol AppPurchaseManagerDelegate

- (void) appPurchasePaymentTransactionFinish:(NSData *)receiptData;
- (void) appPurchasePaymentTransactionFailed:(int)failType;

@end
