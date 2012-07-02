//
//  ProductDetailUtil.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 3/5/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "RecipeTableEntity.h"

@interface ProductDetailUtil : NSObject <NSURLConnectionDataDelegate> {
    id delegate;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSURLConnection *conn;
}

@property (nonatomic, assign) id delegate;

- (void)getProductDetail:(NSInteger)productId;
- (void)cancelRequest;

@end

@protocol ProductDetailUtilDelegate

- (void)setProductDetail:(RecipeTableEntity *)newRecipeTableEntity;

@end