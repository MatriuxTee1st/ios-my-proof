//
//  RecipeViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseUtility.h"
#import "Utility.h"
#import "RecipeEntity.h"
#import "HowToCookTableViewController.h"
#import "TimerViewController.h"
#import "MainIngredientEntity.h"
#import "SauceEntity.h"
#import "RankingRequestEntity.h"
#import "Reachability.h"
#import "JSON.h"
#import "SNSService.h"
#import "RelationalRecipeUtil.h"

@interface RecipeViewController : UIViewController<NSURLConnectionDataDelegate> {
    SNSService *newService;
    Reachability *internetConnectionStatus;
    id delegate;
    RecipeEntity *recipeEntity;
    UIImageView *headerTabImageView;
    HowToCookTableViewController *howToCookTableViewController;
    UIButton *bookmarkButton;
    UIButton *timerButton;
    UIButton *photoButton;
    UIButton *expandButton;
    UIImageView *photoShadowImageView;
    NSMutableArray *rankingRequestEntityArray;

    UIView *backView;
    CGPoint photoCenter;
    NSMutableData *receivedData;
    BOOL isTopView;
    
    RelationalRecipeUtil* relationalRecipeUtil;
}

@property(nonatomic, retain) id delegate;

- (id)initWithRecipeNo:(int)recipeNo;
- (void)tabImageViewSetting;
- (void)navigationBarSetting;
- (void)startTransitionAnimation;
- (void)sendRankingDataPostRequest;
- (void)setAutoSleepMode;
- (void)enableTimerButton;
- (void)setRelationalRecipe:(NSMutableArray *)cellEntityArray;

@end

@protocol RecipeViewControllerDelegate

- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;

@end