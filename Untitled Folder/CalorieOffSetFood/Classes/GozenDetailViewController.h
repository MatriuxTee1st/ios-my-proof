//
//  GozenDetailViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "RecipeCell.h"
#import "RecipeEntity.h"
#import "RecipeViewController.h"

@interface GozenDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView_;
    NSInteger gozenRecipeCount;
}

- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;
- (void)navigationBarSetting;

@end
