//
//  MedicinalCarbOffDictionaryDetailViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DatabaseUtility.h"
#import "Utility.h"

@interface MedicinalCarbOffDictionaryDetailViewController : UIViewController {
    UIView *backgroundView_;
    UIScrollView *scrollView_;
    UIView *titleView_;
    UILabel *navigationBarTitleLabel;
    
    NSArray *medicinalCarbOffDictionaryArray;
    
    NSInteger currentRow;
    NSInteger currentSection;
    NSInteger maxRow;
    NSInteger maxSection;
    
    UIButton *nextCookingTipButton;
    UIButton *previousCookingTipButton;
}

@property (nonatomic, retain) NSArray *medicinalCarbOffDictionaryArray;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSInteger currentSection;

- (void)navigationBarSetting;
- (UIScrollView *)setScrollViewContents;
- (UIView *)setTitleViewContents;

@end
