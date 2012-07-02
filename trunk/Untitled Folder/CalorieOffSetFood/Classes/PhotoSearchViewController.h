//
//  PhotoSearchViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DatabaseUtility.h"
#import "PhotoGridViewController.h"
#import "PhotoListTableViewController.h"

@interface PhotoSearchViewController : UIViewController {
    PhotoGridViewController *photoGridViewController;
    PhotoListTableViewController *photoListTableViewController;
    NSMutableArray *recipeDataArray;
    UIButton *changeButton;
    BOOL isGridAnimated;
}

- (void)navigationBarSetting;
- (void)transitionToRecipeViewWithRecipeNo:(int)recipeNo;

@end
