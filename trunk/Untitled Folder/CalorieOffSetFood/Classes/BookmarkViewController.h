//
//  BookmarkViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DatabaseUtility.h"
#import "RecipeCell.h"
#import "RecipeCellEntity.h"
#import "RecipeViewController.h"

@interface BookmarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView_;
    
    NSArray *favoritesList_;
}

- (void)navigationBarSetting;
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;
@end

