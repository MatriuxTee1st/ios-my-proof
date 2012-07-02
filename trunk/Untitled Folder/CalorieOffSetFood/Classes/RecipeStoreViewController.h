//
//  RecipeStoreViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "RecipeImageUtil.h"

@interface RecipeStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate> {
    UITableView *tableView_;
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    NSMutableArray *recipeTableEntityArray;
    RecipeImageUtil *recipeImageUtil;
    NSInteger productCounter;
    NSURLConnection *conn;
    
    UIView *indicatorBackView;
    UIActivityIndicatorView *indicatorView;
    
    BOOL cellWasSelected;
    NSMutableString* noRecipesString;
}

- (void)navigationBarSetting;
- (void)goToProduct:(NSInteger)productId;
- (void)getImageFinishedWithImage:(UIImage *)recipeImage imageNo:(NSInteger)imageNo;
- (void)resumeRequest;
- (void)pauseRequest;
- (void)cancelRequest;
- (void)cancelInAppPurchase;

@end
