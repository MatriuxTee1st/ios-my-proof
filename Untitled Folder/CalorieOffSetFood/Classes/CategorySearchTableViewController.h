//
//  CategorySearchTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/25.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseUtility.h"
#import "Utility.h"
#import "CategorySearchRecipeTableViewController.h"

@interface CategorySearchTableViewController : UITableViewController {
    UITableView *tableView_;
    NSMutableArray *categoryArray;
}

- (void)navigationBarSetting;

@end
