//
//  TwitterView.h
//  Masuda
//
//  Created by ShinjiYamamoto on 11/04/18.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Twitter
#import "SA_OAuthTwitterController.h"
@class SA_OAuthTwitterEngine;

@interface TwitterView : UIView <UITextViewDelegate, SA_OAuthTwitterControllerDelegate, UIAlertViewDelegate>{
    
    id delegate;
    NSString *defaultWord;
    UITextView *inputView;
    UILabel *letterCountLabel;
    UIButton *sendButton;
    UIButton *doneButton;
    
    UIBarButtonItem *cancelBtn;
    UIActivityIndicatorView *indicator;
    
    // Twitter
    SA_OAuthTwitterEngine *_engine;
    
    int inputMaxLength;
}

- (id)initWithFrame:(CGRect)frame defaultWord:(NSString *)_defaultWord delegate:(id)_delegate;
- (void)navigationBarSetting;

@end

@protocol TwitterViewDelegate

- (void)setAutoSleepMode;
- (void)changeIsTopView:(BOOL)isTopView_;

@end
