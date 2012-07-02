//
//  MedicinalCarbOffAppDelegate.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/04.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "MedicinalCarbOffAppDelegate.h"
#import "AppDriverProxy.h"
#import "Utility.h"

//#import "accountInfoForAppdriver.h"

@interface MedicinalCarbOffAppDelegate ()

- (void)updateDB;

@end

@implementation MedicinalCarbOffAppDelegate

@synthesize window;
@synthesize splashViewController;

#pragma mark -
#pragma mark Application lifecycle


/***************************************************************
 * アプリケーション開始時
 * ・ナビゲーションバーとタブバーの設定を行う
 ***************************************************************/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
    
    PrintLog(@"[%@] {", CMD_STR);
    
    //Start AppDriver
    //[AppDriverProxy setTestMode:NO];
    //[AppDriverProxy requestAppDriverWithSiteId:@"2366" siteKey:@"e937d65f783c9144849bc692f7ef0b50"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    tabBarController = [[UITabBarController alloc] init];
    
    topViewController            = [[TopViewController alloc] init];
    bookmarkViewController       = [[BookmarkViewController alloc] init];
    rankingTableViewController   = [[RankingTableViewController alloc] init];
    medicinalTipsViewController  = [[MedicinalTipsViewController alloc] init];
    recipeStoreViewController    = [[RecipeStoreViewController alloc] init];
    
    topNavigationController            = [[UINavigationController alloc] initWithRootViewController:topViewController];
    bookmarkNavigationController       = [[UINavigationController alloc] initWithRootViewController:bookmarkViewController];
    rankingNavigationController        = [[UINavigationController alloc] initWithRootViewController:rankingTableViewController];
    medicinalTipsNavigationController  = [[UINavigationController alloc] initWithRootViewController:medicinalTipsViewController];
    recipeStoreNavigationController    = [[UINavigationController alloc] initWithRootViewController:recipeStoreViewController];
    
    // タブのタイトル 
    [topNavigationController.tabBarItem setTitle:@"検索"];
    [bookmarkNavigationController.tabBarItem setTitle:@"お気に入り"];
    [rankingNavigationController.tabBarItem setTitle:@"ランキング"];
    [medicinalTipsNavigationController.tabBarItem setTitle:@"薬膳手帖"];
    [recipeStoreNavigationController.tabBarItem setTitle:@"レシピストア"];
    
    // タブのアイコン画像
    topNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0] autorelease];
    [bookmarkNavigationController.tabBarItem setImage:[UIImage imageNamed:kTabBarIconBookmarkImageName]];
    [rankingNavigationController.tabBarItem setImage:[UIImage imageNamed:kTabBarIconRankingImageName]];
    [medicinalTipsNavigationController.tabBarItem setImage:[UIImage imageNamed:kTabBarIconMedicinalTipsImageName]];
    [recipeStoreNavigationController.tabBarItem setImage:[UIImage imageNamed:kStoreTabBarIconImageName]];
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:
                                          topNavigationController,
                                          bookmarkNavigationController,
                                          rankingNavigationController,
                                          medicinalTipsNavigationController,
                                          recipeStoreNavigationController,
                                          nil]];
    
    splashViewController = [[SplashViewController alloc] init];
    [splashViewController setDelegate:self];
    [splashViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self.window insertSubview:tabBarController.view atIndex:0];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [tabBarController presentModalViewController:splashViewController animated:NO];
    
    [Utility cancelNotification];
    
    productCountUtil = [[ProductCountUtil alloc] init];
    [productCountUtil setDelegate:self];
    [productCountUtil getProductCount:[NSDate dateWithTimeIntervalSince1970:0]];
    
    [self.window makeKeyAndVisible];
    
    [topViewController release];
    [bookmarkViewController release];
    [rankingTableViewController release];
    [medicinalTipsViewController release];
    [recipeStoreViewController release];
    
    // DB初期化
    DatabaseUtility *db = [[DatabaseUtility alloc] init];
    [db initializeDatabaseIfNeeded];
    [db release];
    
    [self updateDB];
    
    PrintLog(@"[%@] }", CMD_STR);
    
    return YES;
}

/***************************************************************
 * データベースを更新する
 ***************************************************************/
- (void)updateDB {
    PrintLog(@"Start DB Update");
    BOOL success;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // ダウンロード日付コラムをデータベースに追加
    if (![[defaults objectForKey:kDBDownloadDateKey] boolValue]) {
        success = [DatabaseUtility insertDownloadDateColumn];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBDownloadDateKey];
            [defaults synchronize];
            PrintLog(@"Update Download Date DB");
        }
    }
    
    // プロダクトIDコラムをデータベースに追加
    if (![[defaults objectForKey:kDBProductIdKey] boolValue]) {
        success = [DatabaseUtility insertProductIdColumn];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBProductIdKey];
            [defaults synchronize];
            PrintLog(@"Update Product Id DB");
        }
    }
    
    // 食材よみがなコラムをデータベースに追加
    if (![[defaults objectForKey:kDBIngredientFoodNameFuriganaKey] boolValue]) {
        success = [DatabaseUtility insertFoodNameFuriganaColumn];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBIngredientFoodNameFuriganaKey];
            [defaults synchronize];
            PrintLog(@"Update Ingredient FoodNameFurigana DB");
        }
    }
    
    // レシピコストコラムをデータベースに追加
    if (![[defaults objectForKey:kDBRecipeCostKey] boolValue]) {
        success = [DatabaseUtility insertCostColumn];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBRecipeCostKey];
            [defaults synchronize];
            PrintLog(@"Update Recipe Cost DB");
        }
    }
    
    // レシピコストデータをデータベースに入れる
    if (![[defaults objectForKey:kDBRecipeCostDataKey] boolValue]) {
        success = [DatabaseUtility addCostData];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBRecipeCostDataKey];
            [defaults synchronize];
            PrintLog(@"Update Recipe Cost Values DB");
        }
    }
    
    // 食材一覧から空の列を削除
    if (![[defaults objectForKey:kDBFoodCategoryAddKey] boolValue]) {
        success = [DatabaseUtility addCategoryFoodRows];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBFoodCategoryAddKey];
            [defaults synchronize];
            PrintLog(@"Add food rows from DB");
        }
    }
    
    // 食材一覧から空の列を削除
    if (![[defaults objectForKey:kDBFoodMushroomUpdateKey] boolValue]) {
        success = [DatabaseUtility updateFoodMushroomRows];
        if (success) {
            [defaults setObject:[NSNumber numberWithBool:YES] forKey:kDBFoodMushroomUpdateKey];
            [defaults synchronize];
            PrintLog(@"Update food mushroom rows from DB");
        }
    }
    PrintLog(@"End DB Update");
}

/***************************************************************
 * Get badge results finished
 ***************************************************************/
- (void)productCountRequestFinishedWithIDs:(NSArray *)productIdArray {
    
    NSInteger productCount = 0;
    for (NSNumber *productId in productIdArray) {
        if ([DatabaseUtility checkProductExists:[productId intValue]]) {
            productCount++;
        }
    }
    
    NSInteger remainingProductCount = [productIdArray count] - productCount;
    
    if (remainingProductCount > 0) {
        [recipeStoreNavigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", remainingProductCount]];
    } else {
        [recipeStoreNavigationController.tabBarItem setBadgeValue:nil];
    }
    
    [Utility scheduleNotificationWithCount:remainingProductCount];
    
    [topViewController getBannerData];
    [productCountUtil release], productCountUtil = nil;
}

/***************************************************************
 * Get badge results failed
 ***************************************************************/
- (void)productCountRequestFailed {
    [topViewController getBannerData];
    [productCountUtil release], productCountUtil = nil;
}

/***************************************************************
 * レシピストア詳細画面へ繊維
 ***************************************************************/
- (void)goToProduct:(NSInteger)productId {
    [tabBarController setSelectedIndex:4];
    NSArray *controllers = [[recipeStoreViewController navigationController] viewControllers];
    for (UIViewController *controller in controllers) {
        [controller.navigationController popViewControllerAnimated:NO];
    }
    
    [recipeStoreViewController goToProduct:productId];
}

/***************************************************************
 * スプラッシュ画像非表示後
 ***************************************************************/
- (void)splashScreenDidDisappear:(SplashViewController *)splashViewController {
    PrintLog(@"");
    self.splashViewController = nil;
}

/***************************************************************
 *
 ***************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application {
    PrintLog(@"~~~");
    if ([tabBarController selectedIndex] == 4) {
        [recipeStoreViewController pauseRequest];
    }
}

/***************************************************************
 *
 ***************************************************************/
- (void)applicationDidEnterBackground:(UIApplication *)application {
    PrintLog(@"~~~");
    if ([tabBarController selectedIndex] == 4) {
        [recipeStoreViewController cancelInAppPurchase];
    }
    
    [topViewController removeBanner];
    // Stop AppDriver
    [AppDriverProxy stopSession];
}

/***************************************************************
 *
 ***************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application {
    PrintLog(@"~~~");
    [topViewController insertBanner:YES];
    //Start AppDriver
    [AppDriverProxy startSession];
}

/***************************************************************
 *
 ***************************************************************/
- (void)applicationDidBecomeActive:(UIApplication *)application {
    PrintLog(@"~~~");
    if ([tabBarController selectedIndex] == 4) {
        [recipeStoreViewController resumeRequest];
    }
}

/***************************************************************
 *
 ***************************************************************/
- (void)applicationWillTerminate:(UIApplication *)application {
    // Stop AppDriver
    [AppDriverProxy stopSession];
}


#pragma mark -
#pragma mark Memory management

/***************************************************************
 * メモリ警告後
 ***************************************************************/
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    
    [window release];
    [super dealloc];
}


@end
