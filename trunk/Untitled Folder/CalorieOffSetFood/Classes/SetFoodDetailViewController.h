//
//  SetFoodDetailViewController.h
//  CalorieOffSetFood
//
//  Created by  on 12/06/29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeCell.h"
#import "RecipeEntity.h"
#import "DatabaseUtility.h"
#import "RecipeViewController.h"
#import "RelationalRecipeUtil.h"

#import <QuartzCore/QuartzCore.h>

@interface SetFoodDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView *backgroundView_;
    UITableView *tableView_;
    UIScrollView *scrollView_;
    NSArray *setFoodArray;
    NSInteger currentRow;
    NSInteger currentSection;
    NSInteger maxRow;
    NSInteger maxSection;
    NSInteger setRecipeCount;
    CGSize titleLabelSize;
    CGSize descriptionLabelSize;
    NSMutableArray *scrollViewArray;
    NSMutableArray *cellArray;
	RecipeEntity *recipeEntity;
	
    UIButton *nextIngredientButton;
    UIButton *previousIngredientButton;
    
    UILabel *navigationBarTitleLabel;
    RelationalRecipeUtil* relationalRecipeUtil;
}

@property (nonatomic, retain) NSArray *setFoodArray;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSInteger currentSection;

- (id)initWithRecipeNo:(int)recipeNo;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;
- (void)navigationBarSetting;
- (UIScrollView *)setScrollViewContents;

@end
