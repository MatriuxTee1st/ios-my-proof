//
//  RecipeImageUtil.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/23/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef enum {
    RecipeImageTypeRecipe = 0,
    RecipeImageTypeProduct,
    RecipeImageTypeThumb,
} RecipeImageType;

@interface RecipeImageUtil : NSObject <NSURLConnectionDataDelegate> {
    id delegate;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSURLConnection *conn;
    
    NSInteger imageNo;
}

@property (nonatomic, assign) id delegate;

- (void)getImageForRecipeNo:(NSInteger)recipeNo recipeImageType:(RecipeImageType)imageType;
- (void)cancelRequest;

@end

@protocol RecipeImageUtilDelegate

- (void)getImageFinishedWithImage:(UIImage *)recipeImage imageNo:(NSInteger)imageNo;
- (void)getImageFailed;

@end
