//
//  RecipePreviewUtil.m
//  MedicinalCooking
//
//  Created by Nolan Warner on 3/16/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "RecipePreviewUtil.h"
#import "JSON.h"

@implementation RecipePreviewUtil

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

#pragma mark - Network methods

/***************************************************************
 * レシピ画像取得
 ***************************************************************/
- (void)getImage:(NSInteger)productId photoNo:(NSInteger)photoNo {
    
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerImage];
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        NSDictionary *requestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInt:productId], @"product_id",
                                           [NSNumber numberWithInt:photoNo], @"photo_no",
                                           nil];
        NSString *requestString = [NSString stringWithFormat:@"data=%@&%@", [requestDictionary JSONRepresentation], kRankingServerPassword];
        
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    // 失敗した場合
    else {
        if ([delegate respondsToSelector:@selector(getPreviewImageFailed)]) {
            [delegate getPreviewImageFailed];
        }
    }
}

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
    PrintLog(@"通信完了");
    [conn release], conn = nil;
    
    UIImage *recipeImage = [UIImage imageWithData:receivedData];
    [receivedData release], receivedData = nil;
    
    if (recipeImage) {
        if ([delegate respondsToSelector:@selector(getPreviewImageFinished:)]) {
            [delegate getPreviewImageFinished:recipeImage];
        }
    }
    // 失敗した場合
    else {
        if ([delegate respondsToSelector:@selector(getPreviewImageFailed)]) {
            [delegate getPreviewImageFailed];
        }
        
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    if ([delegate respondsToSelector:@selector(getPreviewImageFailed)]) {
        [delegate getPreviewImageFailed];
    }
    
    [conn release], conn = nil;
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
