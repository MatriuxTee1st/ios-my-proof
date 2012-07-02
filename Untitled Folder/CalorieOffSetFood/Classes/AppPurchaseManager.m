//
//  AppPurchaseManager.m
//  MedicinalCarbOff
//
//  Created by  on 11/12/24.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import "AppPurchaseManager.h"
//#import "UserDefaultKeyConst.h"

static NSString *USER_DEFAULT_KEY_RECEIPT_DATA = @"receiptData";

@implementation AppPurchaseManager

@synthesize _delegate;

/**
 購入処理が可能かどうか返します
 */
- (BOOL) canMakePayments
{
    BOOL canMakePayments;
    
    // アプリ内課金可能な場合
    if ([SKPaymentQueue canMakePayments]) 
    {
        canMakePayments = YES;
    }
    // アプリ内課金不可能な場合
    else 
    {
        canMakePayments = NO;
    }
    return canMakePayments;
}

/**
 AppStoreからプロダクトのデータを取得します
 */
- (void) requestProductData:(NSString *)identifier 
{
    theRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:identifier]];
    [theRequest setDelegate:self];
    [theRequest start];
}

/**
 プロダクト情報の取得と購入処理を開始しますsetReceiptData
 */
- (void) productsRequest:(SKProductsRequest *)request
      didReceiveResponse:(SKProductsResponse *)response 
{   
    // レスポンスがない場合
    if (response == nil) {
        [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailNotConnectItunesStore];
    }
    // レスポンスが存在する場合
    else
    {
        // プロダクトIDが確認出来なかった場合
        if ([[response invalidProductIdentifiers] count] != 0) 
        {
            [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailNotProductID];
        }
        // プロダクトIDが確認できた場合
        else 
        {
            // プロダクトの件数分購入処理します（1件のみ）
            for (SKProduct *product in response.products) 
            {
                SKPayment *payment = [SKPayment paymentWithProduct:product];
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
            }
        }
    }
}

/**
 リクエストをキャンゼルします
 */
- (void)cancelRequest {
    [theRequest cancel];
//    [theRequest release], theRequest = nil;
}

/**
 リクエスト終了時に呼ばれます
 */
- (void)requestDidFinish:(SKRequest *)request
{    
    [theRequest release], theRequest = nil;
}

/**
 リクエスト失敗時に呼ばれます
 */
- (void)request:(SKRequest *)request 
didFailWithError:(NSError *)error
{
    [theRequest cancel];
    [theRequest release], theRequest = nil;
    
    [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailNotConnectItunesStore];
}

/**
 プロダクト購入処理結果を取得します
 */
- (void) paymentQueue:(SKPaymentQueue *)queue 
  updatedTransactions:(NSArray *)transactions {
    
    BOOL purchaseing = YES;
    
    // トランザクションの件数分繰り返します
    for (SKPaymentTransaction *transaction in transactions) 
    {
        switch (transaction.transactionState) 
        {
            // 購入中の場合
            case SKPaymentTransactionStatePurchasing: 
            {
                PrintLog(@"Purchasing");
                purchaseing = YES;
                break;
            }
            // 購入に成功した場合
            case SKPaymentTransactionStatePurchased: 
            {
                PrintLog(@"Purchased");
                purchaseing = NO;
                [queue finishTransaction:transaction];
                [_delegate appPurchasePaymentTransactionFinish:[transaction transactionReceipt]];
                break;
            }
            // 購入に失敗した場合
            case SKPaymentTransactionStateFailed: 
            {
                PrintLog(@"Failed");
                purchaseing = NO;
                [queue finishTransaction:transaction];
                
                // キャンセルアクションの場合
                if ([[transaction error] code] == SKErrorPaymentCancelled) 
                {
                    PrintLog(@"--Cancelled");
                    [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailCancelAction];
                }
                // 不明なエラーの場合（接続不良）
                else if ([[transaction error] code] == SKErrorUnknown)
                {
                    PrintLog(@"--Unknown");
                    [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailNotConnectItunesStore];
                }
                // AppPurchaseが許可されていない場合
                else if ([[transaction error] code] == SKErrorPaymentNotAllowed)
                {
                    PrintLog(@"--NotAllowed");
                    [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailNotAllowed];
                }
                // 商品情報が取得出来なかった場合
                else if ([[transaction error] code] == SKErrorPaymentInvalid)
                {
                    PrintLog(@"--PaymentInvalid");
                    [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailNotProductID];
                }
                // AppleIDが使用出来ない場合
                else
                {
                    PrintLog(@"--AppleIdInvalid");
                    [_delegate appPurchasePaymentTransactionFailed:appPurchasePaymentFailInvaliedAppleID];
                }
                break;
            }
            // 購入をリストアされた場合（消費型コンテンツのため、購入履歴からの復旧は存在しないのでこのケースは発生しない）
            case SKPaymentTransactionStateRestored:
            {
                PrintLog(@"Restored");
                purchaseing = NO;
                [queue finishTransaction:transaction];
                break;
            }
        }
    }
    // 購入処理が終了した場合
    if (!purchaseing) 
    {
        PrintLog(@"RemoveObserver");
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}

/**
 レシートデータをセットします
 */
+ (void) setReceiptData:(NSData *)receipt 
         purchaseRecipeId:(int)recipeId
{
    NSUserDefaults *defaults         = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *receiptData = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:USER_DEFAULT_KEY_RECEIPT_DATA]];
    
    [receiptData setObject:receipt
                    forKey:[NSString stringWithFormat:@"%d", recipeId]];
    [defaults setObject:receiptData 
                 forKey:USER_DEFAULT_KEY_RECEIPT_DATA];
    [defaults synchronize];
}

/**
 レシートデータを削除します
 */
+ (void) removeReceiptData:(int)recipeId
{
    NSUserDefaults *defaults         = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *receiptData = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:USER_DEFAULT_KEY_RECEIPT_DATA]];
    
    [receiptData removeObjectForKey:[NSString stringWithFormat:@"%d", recipeId]];
    [defaults setObject:receiptData 
                 forKey:USER_DEFAULT_KEY_RECEIPT_DATA];
    [defaults synchronize];
}

/**
 全てのレシートデータを削除します
 */
+ (void) removeAllReceiptData
{
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSDictionary *receiptData = [NSDictionary dictionary];
    [defaults setObject:receiptData 
                 forKey:USER_DEFAULT_KEY_RECEIPT_DATA];
    [defaults synchronize];
}

/**
 レシートデータを返します
 */
+ (NSDictionary *) receiptData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults dictionaryForKey:USER_DEFAULT_KEY_RECEIPT_DATA];
}

@end
