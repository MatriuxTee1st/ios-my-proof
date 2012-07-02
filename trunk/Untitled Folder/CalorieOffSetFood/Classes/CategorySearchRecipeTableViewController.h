//
//  CategorySearchRecipeTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/25.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "Utility.h"
#import "DatabaseUtility.h"
#import "RecipeCellEntity.h"
#import "RecipeCell.h"

@interface CategorySearchRecipeTableViewController : UITableViewController {
    UITableView *tableView_;
    NSMutableArray *recipeArray;
    int categoryNo;
}
- (id)initWithCategoryNo:(int)categoryNo;
- (void)navigationBarSetting;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;

@end
