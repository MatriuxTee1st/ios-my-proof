//
//  RecipeImageUtil.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/23/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeImageUtil.h"
#import "JSON.h"

@implementation RecipeImageUtil

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
- (void)getImageForRecipeNo:(NSInteger)recipeNo recipeImageType:(RecipeImageType)imageType {
    imageNo = recipeNo;
    
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerImage];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
        switch (imageType) {
            case RecipeImageTypeProduct:
                [requestDictionary setObject:[NSNumber numberWithInt:recipeNo] forKey:@"product_id"];
                break;
            case RecipeImageTypeThumb:
                [requestDictionary setObject:[NSNumber numberWithInt:recipeNo] forKey:@"recipe_no"];
                [requestDictionary setObject:[NSNumber numberWithInt:1] forKey:@"thumbFlg"];
                break;
            case RecipeImageTypeRecipe:
                [requestDictionary setObject:[NSNumber numberWithInt:recipeNo] forKey:@"recipe_no"];
                break;
            default:
                break;
        }
        
        NSString *requestString = [NSString stringWithFormat:@"data=%@&%@", [requestDictionary JSONRepresentation], kRankingServerPassword];
        [requestDictionary release];
        
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    // 失敗した場合
    else {
        if ([delegate respondsToSelector:@selector(getImageFailed)]) {
            [delegate getImageFailed];
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
        if ([delegate respondsToSelector:@selector(getImageFinishedWithImage:imageNo:)]) {    
            [delegate getImageFinishedWithImage:recipeImage imageNo:imageNo];
        }
    }
    // 失敗した場合
    else {
        if ([delegate respondsToSelector:@selector(getImageFailed)]) {
            [delegate getImageFailed];
        }
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    [conn release], conn = nil;
    
    // 失敗した場合
    if ([delegate respondsToSelector:@selector(getImageFailed)]) {
        [delegate getImageFailed];
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
