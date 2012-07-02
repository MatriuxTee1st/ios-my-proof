//
//  BodyTypeSearchTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "FoodSectionEntity.h"
#import "RecipeCellEntity.h"
#import "FoodModel.h"
#import "RecipeCell.h"

@interface BodyTypeSearchTableViewController : UITableViewController {

    UITableView *tableView_;
    UIImageView *searchTabImageView;
    NSMutableArray *cellArray;
    NSInteger type;
}

- (id)initWithType:(NSInteger)type_;
- (void)navigationBarSetting;
- (void)settingSearch;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;

@end
