//
//  FoodDictionaryViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "FoodDictionaryDetailViewController.h"


@interface FoodDictionaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView_;
    NSArray *foodDictionaryArray;
}

- (void)navigationBarSetting;

@end
