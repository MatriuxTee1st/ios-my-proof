//
//  TopTableViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/13.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Reachability.h"
#import "JSON.h"
#import "SetFoodSearchTableViewController.h"
#import "FoodSearchTableViewController.h"
#import "PhotoSearchViewController.h"
#import "BodyTypeSearchTableViewController.h"
#import "ConstitutionDiagnosisTableViewController.h"
#import "CategorySearchTableViewController.h"

@interface TopViewController : UIViewController <NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIButton *bannerButton;
    UIImage *bannerImage;
    NSTimeInterval delay;
    NSURL *bannerURL;
    
    BOOL isShowingBanner;
    
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
}

- (void)getBannerData;
- (void)insertBanner:(BOOL)animated;
- (void)removeBanner;

@end
