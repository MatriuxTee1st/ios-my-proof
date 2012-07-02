//
//  ProductRecipeUtil.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/24/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ProductRecipeUtil : NSObject <NSURLConnectionDataDelegate> {
    id delegate;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSURLConnection *conn;
    
    NSArray *recipeNoArray;
}

@property (nonatomic, assign) id delegate;

- (void)getRecipeForProductId:(NSInteger)productId appStoreId:(NSString *)appStoreId appStoreReceipt:(NSData *)appStoreReceipt recipeNoArray:(NSArray *)productRecipeNoArray;
- (void)cancelRequest;

@end

@protocol ProductRecipeUtilDelegate

- (void)setProductRecipe:(NSArray *)recipeArray;
- (void)productRecipeRequestCancelled;

@end


