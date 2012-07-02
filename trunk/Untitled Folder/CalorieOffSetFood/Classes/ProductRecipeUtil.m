//
//  ProductRecipeUtil.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/24/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "ProductRecipeUtil.h"
#import "RecipeEntity.h"
#import "MainIngredientEntity.h"
#import "SauceInsertEntity.h"
#import "FoodInsertEntity.h"
#import "JSON.h"
#import "NSData+Base64.h"

static NSString * recipeKey             = @"recipe";

static NSString * recipeNoKey           = @"recipe_no";
static NSString * recipeNameKey         = @"recipe_name";
static NSString * recipeNameFuriganaKey = @"recipe_name_furigana";
static NSString * timeKey               = @"time";
static NSString * calorieKey            = @"calorie";
static NSString * personKey             = @"person";
static NSString * commentRecipeKey      = @"comment_recipe";
static NSString * registDateKey         = @"regist_date";
static NSString * carbQtyKey            = @"carb_qty";
static NSString * bodyTypeKey           = @"body_type";
static NSString * costKey               = @"cost";

static NSString * foodKey               = @"food";
static NSString * foodNameKey           = @"food_name";
static NSString * foodNameFuriganaKey   = @"food_name_furigana";
static NSString * categoryKey           = @"category";
static NSString * firstLetterKey        = @"first_letter";

static NSString * ingredientKey         = @"ingredient";
static NSString * mainIngredientNameKey = @"main_ingredient_name";
static NSString * mainIngredientQtyKey  = @"main_ingredient_qty";

static NSString * sauceKey              = @"sauce";
static NSString * sauceANameKey         = @"sauce_a_name";
static NSString * sauceAQtyKey          = @"sauce_a_qty";
static NSString * sauceBNameKey         = @"sauce_b_name";
static NSString * sauceBQtyKey          = @"sauce_b_qty";
static NSString * sauceCNameKey         = @"sauce_c_name";
static NSString * sauceCQtyKey          = @"sauce_c_qty";

static NSString * processKey            = @"process";

static NSString * relationRecipeKey     = @"relationRecipe";

static NSString * productIdKey          = @"product_id";
static NSString * resultKey             = @"result";



@implementation ProductRecipeUtil

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
 * recipeEntity作成
 ***************************************************************/
- (RecipeEntity *)makeRecipeEntity:(NSDictionary *)recipeDictionary {
    RecipeEntity *recipeEntity = [[[RecipeEntity alloc] init] autorelease];
    
    [recipeEntity setRecipeNo:[[recipeDictionary objectForKey:recipeNoKey] intValue]];
    [recipeEntity setPhotoNo:[NSString stringWithFormat:@"photoNo%@", [recipeDictionary objectForKey:recipeNoKey]]];
    [recipeEntity setRecipeName:[recipeDictionary objectForKey:recipeNameKey]];
    [recipeEntity setRecipeFurigana:[recipeDictionary objectForKey:recipeNameFuriganaKey]];
    [recipeEntity setTime:[[recipeDictionary objectForKey:timeKey] intValue]];
    [recipeEntity setCalorie:[[recipeDictionary objectForKey:calorieKey] intValue]];
    [recipeEntity setCommentRecipe:[recipeDictionary objectForKey:commentRecipeKey]];
    [recipeEntity setPerson:[[recipeDictionary objectForKey:personKey] intValue]];
    [recipeEntity setCarbQty:[[recipeDictionary objectForKey:carbQtyKey] floatValue]];
    [recipeEntity setBodyType:[[recipeDictionary objectForKey:bodyTypeKey] intValue]];
    [recipeEntity setCost:[[recipeDictionary objectForKey:costKey] intValue]];
    
    NSMutableArray *mainIngredientEntityArray = [[NSMutableArray alloc] init];
    for (NSDictionary *mainIngredientDictionary in [recipeDictionary objectForKey:ingredientKey]) {
        MainIngredientEntity *mainIngredientEntity = [[MainIngredientEntity alloc] init];
        [mainIngredientEntity setMainIngredientName:[mainIngredientDictionary objectForKey:mainIngredientNameKey]];
        [mainIngredientEntity setMainIngredientQty:[mainIngredientDictionary objectForKey:mainIngredientQtyKey]];
        [mainIngredientEntityArray addObject:mainIngredientEntity];
        [mainIngredientEntity release];
    }
    [recipeEntity setMainIngredientEntityArray:mainIngredientEntityArray];
    [mainIngredientEntityArray release];
    
    NSMutableArray *processArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 9; i++) {
        NSDictionary *processDictionary = [recipeDictionary objectForKey:processKey];
        [processArray addObject:[processDictionary objectForKey:[NSString stringWithFormat:@"%@%d", processKey, i]]];
    }
    [recipeEntity setProcessArray:processArray];
    [processArray release];
    
    NSMutableArray *foodInsertEntityArray = [[NSMutableArray alloc] init];
    for (NSDictionary *foodDictionary in [recipeDictionary objectForKey:foodKey]) {
        FoodInsertEntity *foodInsertEntity = [[FoodInsertEntity alloc] init];
        [foodInsertEntity setFoodName:[foodDictionary objectForKey:foodNameKey]];
        [foodInsertEntity setFoodNameFurigana:[foodDictionary objectForKey:foodNameFuriganaKey]];
        [foodInsertEntity setCategory:[foodDictionary objectForKey:categoryKey]];
        [foodInsertEntity setFirstLetter:[foodDictionary objectForKey:firstLetterKey]];
        [foodInsertEntityArray addObject:foodInsertEntity];
        [foodInsertEntity release];
    }
    [recipeEntity setFoodInsertArray:foodInsertEntityArray];
    [foodInsertEntityArray release];
    
    NSMutableArray *sauceInsertEntityArray = [[NSMutableArray alloc] init];
    for (NSDictionary *sauceDictionary in [recipeDictionary objectForKey:sauceKey]) {
        SauceInsertEntity *sauceInsertEntity = [[SauceInsertEntity alloc] init];
        [sauceInsertEntity setSauceAName:[sauceDictionary objectForKey:sauceANameKey]];
        [sauceInsertEntity setSauceAQty:[sauceDictionary objectForKey:sauceAQtyKey]];
        [sauceInsertEntity setSauceBName:[sauceDictionary objectForKey:sauceBNameKey]];
        [sauceInsertEntity setSauceBQty:[sauceDictionary objectForKey:sauceBQtyKey]];
        [sauceInsertEntity setSauceCName:[sauceDictionary objectForKey:sauceCNameKey]];
        [sauceInsertEntity setSauceCQty:[sauceDictionary objectForKey:sauceCQtyKey]];
        [sauceInsertEntityArray addObject:sauceInsertEntity];
        [sauceInsertEntity release];
    }
    [recipeEntity setSauceAEntityArray:sauceInsertEntityArray];
    [sauceInsertEntityArray release];
    
    NSMutableArray *relationalRecipeArray = [[NSMutableArray alloc] init];
    for (NSNumber *relationalNumber in [recipeDictionary objectForKey:relationRecipeKey]) {
        [relationalRecipeArray addObject:relationalNumber];
    }
    [recipeEntity setRelationalRecipeCellEntityArray:relationalRecipeArray];
    [relationalRecipeArray release];
    
//    [recipeEntity setProductId:[[recipeDictionary objectForKey:productIdKey] intValue]];
    
    return recipeEntity;
}

#pragma mark - Network methods

/***************************************************************
 * レシピ画像取得
 ***************************************************************/
- (void)getRecipeForProductId:(NSInteger)productId appStoreId:(NSString *)appStoreId appStoreReceipt:(NSData *)appStoreReceipt recipeNoArray:(NSArray *)productRecipeNoArray {
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerProductRecipe];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
        [requestDictionary setObject:[NSNumber numberWithInt:productId] forKey:@"product_id"];
        [requestDictionary setObject:appStoreId forKey:@"appstore_product_id"];
        [requestDictionary setObject:[appStoreReceipt base64EncodingWithLineLength:80] forKey:@"appstore_receipt"];
        NSString *requestString = [NSString stringWithFormat:@"data=%@&%@", [requestDictionary JSONRepresentation], kRankingServerPassword];
        [requestDictionary release];
        
        NSData *requestData = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        recipeNoArray = [productRecipeNoArray retain];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    } else {
        if ([delegate respondsToSelector:@selector(setProductRecipe:)]) {
            [delegate setProductRecipe:nil];
        }
    }
}

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
    NSString *result = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    [receivedData release], receivedData = nil;
    NSDictionary *productDictionary = [result JSONValue];
    
    NSMutableArray *productRecipeArray = nil;
    if ([[productDictionary objectForKey:resultKey] isEqualToString:@"success"]) {
        productRecipeArray = [[NSMutableArray alloc] init];
        NSDictionary *recipeListDictionary = [productDictionary objectForKey:recipeKey];
        for (NSNumber *recipeNo in recipeNoArray) {
            NSDictionary *recipeDictionary = [recipeListDictionary objectForKey:[NSString stringWithFormat:@"%@", recipeNo]];
            RecipeEntity *recipeEntity = [self makeRecipeEntity:recipeDictionary];
            [recipeEntity setProductId:[[productDictionary objectForKey:productIdKey] intValue]];
            [productRecipeArray addObject:recipeEntity];
        }
    }
    
    if ([delegate respondsToSelector:@selector(setProductRecipe:)]) {
        [delegate setProductRecipe:productRecipeArray];
    }
    
    if (productRecipeArray) {
        [productRecipeArray release];
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    [conn release], conn = nil;
    
    if ([delegate respondsToSelector:@selector(setProductRecipe:)]) {
        [delegate setProductRecipe:nil];
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
        
        if ([delegate respondsToSelector:@selector(productRecipeRequestCancelled)]) {
            [delegate productRecipeRequestCancelled];
        }
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
