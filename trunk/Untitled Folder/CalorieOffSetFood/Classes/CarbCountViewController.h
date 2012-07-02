//
//  CarbCountViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 3/9/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarbCountViewController : UIViewController <UIWebViewDelegate> {
    UIView *indicatorBackView;
    UIActivityIndicatorView *indicatorView;
}

- (void)navigationBarSetting;

@end
