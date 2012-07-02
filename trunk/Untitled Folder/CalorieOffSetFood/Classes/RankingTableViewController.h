//
//  RankingTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "RecipeCell.h"
#import "RecipeCellEntity.h"
#import "RecipeViewController.h"
#import "Reachability.h"
#import "JSON.h"
#import "RelationalRecipeUtil.h"
#import "DatabaseUtility.h"

@interface RankingTableViewController : UITableViewController<NSURLConnectionDataDelegate> {
    UITableView *tableView_;
    Reachability *internetConnectionStatus;
    BOOL isBack;
    NSMutableData *receivedData;
    NSMutableArray *rankingArray;
    NSMutableArray *recipeCellEntityArray;
    RelationalRecipeUtil *relationalRecipeUtil;
    NSInteger productId;
    
    UIView *indicatorBackView;
    UIActivityIndicatorView *indicatorView;
}
- (void)navigationBarSetting;
- (void)getRankingData;
- (void)indicatorDisappearAnimation;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;
- (void)setRelationalRecipe:(NSMutableArray *)cellEntityArray;
@end
