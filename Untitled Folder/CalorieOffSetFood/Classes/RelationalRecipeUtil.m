//
//  RelationalRecipeUtil.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/28/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "RelationalRecipeUtil.h"
#import "RecipeCellEntity.h"
#import "Utility.h"
#import "DatabaseUtility.h"
#import "JSON.h"

@implementation RelationalRecipeUtil

@synthesize delegate;
@synthesize recipeNoArray;

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
- (void)getRelationalRecipe {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF > %d", kRecipeCount];
    NSArray *filteredArray = [recipeNoArray filteredArrayUsingPredicate:predicate];
    
    if ([filteredArray count] > 0) {
        // インターネット接続確認
        internetConnectionStatus = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
        if (networkStatus != NotReachable) {
            NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerProductRelation];
            NSURL *url = [NSURL URLWithString:urlString];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF > %d", kRecipeCount];
            NSArray *filteredArray = [recipeNoArray filteredArrayUsingPredicate:predicate];
            NSDictionary *requestDictionary = [NSDictionary dictionaryWithObject:filteredArray forKey:@"recipe_no"];
            
            NSString *requestString = [NSString stringWithFormat:@"data=%@&%@", [requestDictionary JSONRepresentation], kRankingServerPassword];
            PrintLog(@"String: %@", requestString);
            NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            [request setHTTPBody:requestData];
            
            conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        } else {
            [delegate setRelationalRecipe:nil];
        }
    } else {
        [delegate setRelationalRecipe:nil];
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
    NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [receivedData release], receivedData = nil;
    NSDictionary *relationRecipeDictionary = [result JSONValue];
    [result release];
    PrintLog(@"%@", relationRecipeDictionary);

    if ([[relationRecipeDictionary objectForKey:@"result"] isEqualToString:@"success"]) {
        NSMutableArray *recipeCellEntityArray = [[NSMutableArray alloc] init];
        NSArray *recipeArray = [NSArray arrayWithArray:[relationRecipeDictionary objectForKey:@"relation_recipe"]];
        for (NSDictionary *recipeDictionary in recipeArray) {
            RecipeCellEntity *recipeCellEntity = [[RecipeCellEntity alloc] init];
            [recipeCellEntity setRecipeNo:[[recipeDictionary objectForKey:@"recipe_no"] intValue]];
            [recipeCellEntity setRecipeName:[recipeDictionary objectForKey:@"recipe_name"]];
            [recipeCellEntity setTime:[[recipeDictionary objectForKey:@"time"] intValue]];
            [recipeCellEntity setCalorie:[[recipeDictionary objectForKey:@"calorie"] intValue]];
            [recipeCellEntity setThumbnailPhotoNo:[recipeDictionary objectForKey:@"thumbnail"]];
            [recipeCellEntity setProductId:[[recipeDictionary objectForKey:@"product_id"] intValue]];
            [recipeCellEntity setCost:[[recipeDictionary objectForKey:@"cost"] intValue]];
            [recipeCellEntity setBodyType:[[recipeDictionary objectForKey:@"body_type"] intValue]];
            [recipeCellEntity setCarbQty:[[recipeDictionary objectForKey:@"carb_qty"] floatValue]];
            [recipeCellEntityArray addObject:recipeCellEntity];
            [recipeCellEntity release];
        }
        
        if ([delegate respondsToSelector:@selector(setRelationalRecipe:)]) {
            if ([recipeCellEntityArray count] > 0) {
                [delegate setRelationalRecipe:recipeCellEntityArray];
            } else {
                [delegate setRelationalRecipe:nil];
            }
        }
        
        if (recipeCellEntityArray) {
            [recipeCellEntityArray release];
        }
    } else {
        if ([delegate respondsToSelector:@selector(setRelationalRecipe:)]) {
            [delegate setRelationalRecipe:nil];
        }
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    [conn release], conn = nil;
    
    if ([delegate respondsToSelector:@selector(setRelationalRecipe:)]) {
        [delegate setRelationalRecipe:nil];
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
    [recipeNoArray release], recipeNoArray = nil;
    [self cancelRequest];
    [super dealloc];
}

@end
