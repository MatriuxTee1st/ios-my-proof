//
//  HowToCookTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/20.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeEntity.h"
#import "MainIngredientEntity.h"
#import "SauceEntity.h"
#import "RecipeCell.h"
#import "RecipeCellEntity.h"

@interface HowToCookTableViewController : UITableViewController <UIAlertViewDelegate> {
    id delegate;
    RecipeEntity *recipeEntity;
    UITableView *tableView_;
    UIScrollView *scrollView;
    NSInteger newProductId;
    float y;
    
}
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) RecipeEntity *recipeEntity;

- (void)setupSauceWithSauceArray:(NSArray *)array title:(NSString *)title;
- (void)setupRelationalRecipeTable;
@end


@protocol HowToCookTableViewDelegate

- (void)selectedRelativeRecipeCellWithRecipeNo:(int)recipeNo;

@end