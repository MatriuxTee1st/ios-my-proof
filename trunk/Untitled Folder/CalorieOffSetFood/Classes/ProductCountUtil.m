//
//  ProductCountUtil.m
//  MedicinalCooking
//
//  Created by Nolan Warner on 3/12/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "ProductCountUtil.h"
#import "JSON.h"
#import "Utility.h"

@implementation ProductCountUtil

@synthesize delegate;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    self = [super init];
    if (self) {
        conn = nil;
    }
    return self;
}

/***************************************************************
 * レシピ画像取得
 ***************************************************************/
- (void)getProductCount:(NSDate *)updateDate {
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerNewProductID];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:updateDate];
        [dateFormatter release];
        
        NSDictionary *requestDictionary = [NSDictionary dictionaryWithObject:dateString forKey:@"lastUpdateDate"];
        NSString *requestString = [NSString stringWithFormat:@"data=%@&%@", [requestDictionary JSONRepresentation], kRankingServerPassword];
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    } else {
        if ([delegate respondsToSelector:@selector(productCountRequestFailed)]) {
            [delegate productCountRequestFailed];
        }
    }
}

#pragma mark - Network methods

/***************************************************************
 * 通信開始時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    receivedData = [[NSMutableData alloc] init];
    
    PrintLog(@"通信開始");
}


/***************************************************************
 * データ受信時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
//    PrintLog(@"データ受信中");
}


/***************************************************************
 * 通信完了
 ***************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [conn release], conn = nil;
    
    PrintLog(@"通信完了");
    NSString *result = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    [receivedData release], receivedData = nil;
    
    NSDictionary *dictionary = [result JSONValue];
    NSArray *productIdArray = [dictionary objectForKey:@"product_id"];
    
    if (productIdArray) {
        if ([delegate respondsToSelector:@selector(productCountRequestFinishedWithIDs:)]) {
            [delegate productCountRequestFinishedWithIDs:productIdArray];
        }
        
        return;
    }
    
    if ([delegate respondsToSelector:@selector(productCountRequestFailed)]) {
        [delegate productCountRequestFailed];
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    [conn release], conn = nil;
    
    if ([delegate respondsToSelector:@selector(productCountRequestFailed)]) {
        [delegate productCountRequestFailed];
    }
    
    [receivedData release], receivedData = nil;
}

/***************************************************************
 * 通信中止
 ***************************************************************/
- (void)cancelRequest {
    if (conn) {
        PrintLog(@"通信キャンセル");
        [conn cancel];
        [conn release], conn = nil;
        [receivedData release], receivedData = nil;
    }
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [self cancelRequest];
    [super dealloc];
}

@end
