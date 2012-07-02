//
//  MedicinalTipsViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "SlideshowViewController.h"
#import "MedicinalCarbOffColumnViewController.h"
#import "MedicinalCarbOffDictionaryViewController.h"
#import "FoodDictionaryViewController.h"
#import "GozenViewController.h"
#import "AppIntroViewController.h"
#import "AboutThisAppViewController.h"
#import "EditorIntroductionViewController.h"
#import "CarbCountViewController.h"

@interface MedicinalTipsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView_;
    CGFloat cellHeight;
}

- (void)navigationBarSetting;

// Table row definition
typedef enum {
    MedicinalTipsTableRowMedicalCookingColumn = 0,
    MedicinalTipsTableRowFoodDictionary,
    MedicinalTipsTableRowMedicalCookingDictionary,
    MedicinalTipsTableRowSlideshow,
    MedicinalTipsTableRowAppIntro,
    MedicinalTipsTableRowCarbCount,
    MedicinalTipsTableRowAboutThisApp,
    MedicinalTipsTableRowEditorIntroduction,
    MedicinalTipsTableRowNum,
    
    //Currently Not Used
    MedicinalTipsTableRowGozen,
} MedicinalTipsTableRows;

@end
