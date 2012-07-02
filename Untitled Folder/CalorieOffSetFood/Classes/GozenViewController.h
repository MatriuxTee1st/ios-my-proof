//
//  GozenViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "GozenDetailViewController.h"

@interface GozenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tableView_;
}

- (void)navigationBarSetting;

@end
