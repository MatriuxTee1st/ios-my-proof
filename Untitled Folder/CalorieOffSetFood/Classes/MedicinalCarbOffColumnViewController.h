//
//  MedicinalCarbOffColumnViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MedicinalCarbOffColumnDetailViewController.h"

@interface MedicinalCarbOffColumnViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView_;
    CGFloat cellHeight;
    
    NSArray *columnArray;
}

- (void)navigationBarSetting;

// Table row definition
typedef enum {
    MSOTableColumn1 = 0,
    MSOTableColumn2,
    MSOTableColumn3,
    MSOTableColumn4,
    MSOTableColumn5,
    MSOTableColumn6,
    MCDTableRowNum,
} MedicinalCarbOffDictionaryTableRows;

@end
