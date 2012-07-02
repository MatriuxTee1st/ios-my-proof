//
//  MedicinalCarbOffDictionaryViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MedicinalCarbOffDictionaryDetailViewController.h"

@interface MedicinalCarbOffDictionaryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView_;
    NSArray *medicinalCarbOffDictionaryArray;
}

- (void)navigationBarSetting;

@end
