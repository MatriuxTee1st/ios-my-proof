//
//  ConstitutionDiagnosisTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/13.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DiagnosisTableViewController.h"
#import "ConstitutionDiagnosisMenuCell.h"

@interface ConstitutionDiagnosisTableViewController : UITableViewController {

    UITableView *tableView_;
}

- (void)navigationBarSetting;

@end
