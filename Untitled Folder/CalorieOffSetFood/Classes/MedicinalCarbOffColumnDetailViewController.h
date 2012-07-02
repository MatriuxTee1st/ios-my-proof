//
//  MedicinalCarbOffColumnDetailViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface MedicinalCarbOffColumnDetailViewController : UIViewController {
    NSDictionary *columnDictionary;
    NSInteger indexNumber;
}

@property (nonatomic, retain) NSDictionary *columnDictionary;
@property (nonatomic, assign) NSInteger indexNumber;

- (void)navigationBarSetting;

@end
