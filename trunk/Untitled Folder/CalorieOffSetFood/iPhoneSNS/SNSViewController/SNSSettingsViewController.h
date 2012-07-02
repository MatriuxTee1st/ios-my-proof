//
//  SNSSettingsViewController.h
//  SocialNetworking
//
//  Created by Nolan Warner on 10/18/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "FBConnect.h"
#import "SA_OAuthTwitterController.h"
@class SA_OAuthTwitterEngine;

@interface SNSSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FBSessionDelegate, FBDialogDelegate, SA_OAuthTwitterControllerDelegate, UIAlertViewDelegate> {
    UITableView *_accountTableView;
    Facebook *facebook;
    SA_OAuthTwitterEngine *twitterEngine;
    id delegate;
    
    BOOL isFBSaved;
    BOOL isTwitterSaved;
    
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, assign) id delegate;

- (void)navigationBarSetting;

@end

@protocol SNSSettingsViewControllerDelegate

- (void)setAutoSleepMode;

@end