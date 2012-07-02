//
//  RelationalRecipeUtil.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/28/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface RelationalRecipeUtil : NSObject <NSURLConnectionDataDelegate> {
    id delegate;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSURLConnection *conn;
    
    NSArray *recipeNoArray;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSArray *recipeNoArray;

- (void)getRelationalRecipe;
- (void)cancelRequest;

@end

@protocol RelationalRecipeUtilDelegate

- (void)setRelationalRecipe:(NSMutableArray *)cellEntityArray;

@end