//
//  MedicinalCarbOffAppDelegate.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/04.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewController.h"
#import "BookmarkViewController.h"
#import "RankingTableViewController.h"
#import "MedicinalTipsViewController.h"
#import "RecipeStoreViewController.h"
#import "SplashViewController.h"
#import "DatabaseUtility.h"
#import "ProductCountUtil.h"

@interface MedicinalCarbOffAppDelegate : NSObject <UIApplicationDelegate, SplashScreenDelegate> {
    UIWindow *window;
    
    UITabBarController *tabBarController;
    
    UINavigationController *topNavigationController;
    UINavigationController *rankingNavigationController;
    UINavigationController *bookmarkNavigationController;
    UINavigationController *medicinalTipsNavigationController;
    UINavigationController *recipeStoreNavigationController;
    
    SplashViewController         *splashViewController;
    TopViewController            *topViewController;
    RankingTableViewController   *rankingTableViewController;
    BookmarkViewController       *bookmarkViewController;
    MedicinalTipsViewController  *medicinalTipsViewController;
    RecipeStoreViewController    *recipeStoreViewController;
    
    ProductCountUtil *productCountUtil;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) SplashViewController *splashViewController;

- (void)splashScreenDidDisappear:(SplashViewController *)splashViewController;
- (void)productCountRequestFinishedWithIDs:(NSArray *)productIdArray;
- (void)productCountRequestFailed;
- (void)goToProduct:(NSInteger)productId;

@end

