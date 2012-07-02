//
//  FoodSearchTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "Utility.h"
#import "DatabaseUtility.h"
#import "FoodSectionEntity.h"
#import "RecipeCellEntity.h"
#import "FoodModel.h"
#import "RecipeCell.h"

@interface FoodSearchTableViewController : UITableViewController {

    UITableView *tableView_;
    UIImageView *searchTabImageView;
    NSMutableArray *sectionArray;
}

- (void)navigationBarSetting;
- (void)settingSearchAll;
- (void)settingSearchWithCategory:(NSString *)category;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;

@end
