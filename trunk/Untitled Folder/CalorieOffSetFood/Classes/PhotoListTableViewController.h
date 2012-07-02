//
//  PhotoListTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/19.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeEntity.h"
#import "RecipeCell.h"

@interface PhotoListTableViewController : UITableViewController {
    id delegate;
    UITableView *tableView_;
    NSMutableArray *recipeArray;
}
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) NSMutableArray *recipeArray;

//- (id)initWithRecipeArray:(NSMutableArray *)array;

@end



@protocol PhotoListTableViewControllerDelegate

- (void)transitionToRecipeViewWithRecipeNo:(int)recipeNo;

@end

