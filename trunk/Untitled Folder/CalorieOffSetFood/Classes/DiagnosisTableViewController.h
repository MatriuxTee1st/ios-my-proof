//
//  DiagnosisTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/07.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "ConstitutionDiagnosisCell.h"

@interface DiagnosisTableViewController : UITableViewController {
    UITableView *tableView_;
    NSArray *questionArray;
    NSMutableArray *switchStatusArray;
    int checkSum[2];
}

- (void)navigationBarSetting;

@end
