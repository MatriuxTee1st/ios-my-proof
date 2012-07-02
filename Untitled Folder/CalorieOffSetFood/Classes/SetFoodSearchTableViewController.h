//
//  SetFoodSearchTableViewController.h
//  CalorieOffSetFood
//
//  Created by  on 12/06/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "FoodSectionEntity.h"
#import "RecipeCellEntity.h"
#import "FoodModel.h"
#import "RecipeCell.h"
#import "SetFoodDetailViewController.h"
#import "DatabaseUtility.h"

@interface SetFoodSearchTableViewController : UITableViewController {
	
    NSMutableArray *recipeArray;
    UITableView *tableView_;
    UIImageView *searchTabImageView;
    NSMutableArray *cellArray;
    NSArray *setFoodArray;
    NSInteger type;
}

- (id)initWithType:(NSInteger)type_;
- (void)navigationBarSetting;
- (void)settingSearch;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;

@end
