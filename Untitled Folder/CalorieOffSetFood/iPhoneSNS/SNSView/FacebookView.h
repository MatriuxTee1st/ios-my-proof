//
//  FacebookView.h
//  Masuda
//
//  Created by ShinjiYamamoto on 11/04/18.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Facebook
#import "FBConnect.h"

@interface FacebookView : UIView <UITextViewDelegate, FBSessionDelegate, FBRequestDelegate, FBDialogDelegate> {
    
    id delegate;
    NSString *defaultWord;
    UITextView *inputView;
    UILabel *letterCountLabel;
    UIButton *sendButton;
    UIButton *doneButton;
    
    UIBarButtonItem *cancelBtn;
    UIActivityIndicatorView *indicator;
    
    // Facebook
    Facebook        *facebook;
    BOOL             canPermissionAccess;
    
    int inputMaxLength;
}

- (id)initWithFrame:(CGRect)frame defaultWord:(NSString *)_defaultWord delegate:(id)_delegate;
- (void)navigationBarSetting;

@end

@protocol FacebookViewDelegate

- (void)setAutoSleepMode;
- (void)fbKeepTokenAction;

@end