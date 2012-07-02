//
//  ProductDetailUtil.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 3/5/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "ProductDetailUtil.h"
#import "JSON.h"
#import "NSData+Base64.h"

static NSString * productInfoKey       = @"product_info";

static NSString * productIdKey         = @"product_id";
static NSString * productNameKey       = @"product_name";
static NSString * priceKey             = @"price";
static NSString * appstoreProductIdKey = @"appstore_product_id";
static NSString * explanationTextKey   = @"explanation_text";
static NSString * thumbnailKey         = @"thumbnail";
static NSString * recipeKey            = @"recipe";
static NSString * recipeNoKey          = @"recipe_no";
static NSString * recipeSizeKey        = @"recipe_size";
static NSString * photoCountKey        = @"photo_count";

@implementation ProductDetailUtil

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
- (void)getProductDetail:(NSInteger)productId {
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerProductDetail];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSDictionary *requestDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:productId] forKey:@"product_id"];
        
        NSString *requestString = [NSString stringWithFormat:@"data=%@&%@", [requestDictionary JSONRepresentation], kRankingServerPassword];
        PrintLog(@"String: %@", requestString);
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    } else {
        if ([delegate respondsToSelector:@selector(setProductDetail:)]) {
            [delegate setProductDetail:nil];
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
    PrintLog(@"%@", [response allHeaderFields]);
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
    NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [receivedData release], receivedData = nil;
    NSDictionary *productDetailDictionary = [result JSONValue];
    [result release];
    PrintLog(@"%@", productDetailDictionary);
    
    
    NSDictionary *dictionary = [productDetailDictionary objectForKey:productInfoKey];
    if (dictionary) {
        RecipeTableEntity *recipeTableEntity = [[RecipeTableEntity alloc] init];
        
        [recipeTableEntity setProductId:[[dictionary objectForKey:productIdKey] intValue]];
        [recipeTableEntity setProductName:[dictionary objectForKey:productNameKey]];
        [recipeTableEntity setPrice:[[dictionary objectForKey:priceKey] intValue]];
        [recipeTableEntity setAppStoreProductId:[dictionary objectForKey:appstoreProductIdKey]];
        [recipeTableEntity setProductLeadDetail:[dictionary objectForKey:explanationTextKey]];
        [recipeTableEntity setProductImage:[UIImage imageWithData:[NSData dataWithBase64EncodedString:[dictionary objectForKey:thumbnailKey]]]];
        [recipeTableEntity setPreviewCount:[[dictionary objectForKey:photoCountKey] intValue]];
        
        NSMutableArray *recipeNoArray = [[NSMutableArray alloc] init];
        NSMutableArray *recipeSizeArray = [[NSMutableArray alloc] init];
        for (NSDictionary *recipeDictionary in [dictionary objectForKey:recipeKey]) {
            [recipeNoArray addObject:[recipeDictionary objectForKey:recipeNoKey]];
            [recipeSizeArray addObject:[recipeDictionary objectForKey:recipeSizeKey]];
        }
        [recipeTableEntity setRecipeNoArray:recipeNoArray];
        [recipeTableEntity setRecipeSizeArray:recipeSizeArray];
        [recipeNoArray release];
        [recipeSizeArray release];
        
        
        if ([delegate respondsToSelector:@selector(setProductDetail:)]) {
            [delegate setProductDetail:recipeTableEntity];
        }
        
        [recipeTableEntity release];
        
    } else {
        if ([delegate respondsToSelector:@selector(setProductDetail:)]) {
            [delegate setProductDetail:nil];
        }
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    [conn release], conn = nil;
    
    if ([delegate respondsToSelector:@selector(setProductDetail:)]) {
        [delegate setProductDetail:nil];
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
