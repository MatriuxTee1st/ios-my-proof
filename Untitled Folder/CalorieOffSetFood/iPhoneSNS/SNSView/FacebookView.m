//
//  FacebookView.m
//  Masuda
//
//  Created by ShinjiYamamoto on 11/04/18.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import "FacebookView.h"

#import "SNSService.h"

#define kFacebookTitle      @"Facebook"
#define kPostConfirmOk      @"投稿しました"
#define kPostConfirmNg      @"投稿に失敗しました"


#define kMaxLength         140
#define kFormatCharLength  2

@interface FacebookView ()

- (void) fbPermissionAction;
- (void) initView;
- (void)removeScreen;;

@end

@implementation FacebookView

/*****************************************************************************
 * 
 *****************************************************************************/
- (id)initWithFrame:(CGRect)frame defaultWord:(NSString *)_defaultWord delegate:(id)_delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        defaultWord = [[NSString alloc] initWithString:_defaultWord];
        delegate    = _delegate;
        
        // 最大入力長
        inputMaxLength = kMaxLength - kFormatCharLength - [kIntroString length] - [defaultWord length] - [kShortURL length];
        PrintLog(@"%d", inputMaxLength);
        
        [self initView];
    }
    return self;
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void) initView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self navigationBarSetting];
    
    UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 68, 300, 100)];
    [frameImageView setImage:[UIImage imageNamed:kSNSFrameImageName]];
    [self addSubview:frameImageView];
    [frameImageView release];
    
    // 入力エリア
    inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 96)];
    [inputView setText:[NSString stringWithFormat:@"%@\n【%@】\n%@", kIntroString, defaultWord, kShortURL]];
    inputView.delegate               = self;
    inputView.textColor              = [UIColor brownColor];
    inputView.backgroundColor        = [UIColor clearColor];
    inputView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputView.autocorrectionType     = UITextAutocorrectionTypeNo;
    inputView.font                   = [UIFont systemFontOfSize:14.f];
    [self addSubview:inputView];
    [inputView release];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setExclusiveTouch:YES];
    [sendButton setFrame:CGRectMake(77, 170, 165, 50)];
    [sendButton setImage:[UIImage imageNamed:kSNSButtonShareImageName] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:kSNSButtonShareImageName] forState:UIControlStateDisabled];
    [sendButton addTarget:self
                   action:@selector(fbUploadAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
    
    // Count
    letterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 44, 110, 24)];
    [letterCountLabel setFont:[UIFont systemFontOfSize:14.f]];
    [letterCountLabel setText:[NSString stringWithFormat:@"%d文字", kMaxLength - [inputView.text length]]];
    [letterCountLabel setTextAlignment:UITextAlignmentRight];
    [letterCountLabel setTextColor:[UIColor brownColor]];
    [self addSubview:letterCountLabel];
    [letterCountLabel release];
    
    // ネットワークチェック
    if ([SNSService canUseNetwork:kAccessUrlFacebook]) {
        facebook = [[Facebook alloc] initWithAppId:kAppFacebookId andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:kFacebookToken] 
            && [defaults objectForKey:kFacebookExpirationDate]) {
            facebook.accessToken = [defaults objectForKey:kFacebookToken];
            facebook.expirationDate = [defaults objectForKey:kFacebookExpirationDate];
        }
        [self fbPermissionAction];
    }
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)dealloc {
    
    [facebook release];
    [defaultWord release];
    [indicator release];
    
    [super dealloc];
}

/***************************************************************
 * ナビゲーションバーの設定
 ***************************************************************/
- (void)navigationBarSetting {
    // ナビゲーションバーの設定
    UIImage *navigationBarImage = [UIImage imageNamed:kNavigationBarImageName];
    UIImageView *navigationBarImageView = [[UIImageView alloc] initWithImage:navigationBarImage];
    navigationBarImageView.frame = kNavigationBarFrame;
    [self addSubview:navigationBarImageView];
    [navigationBarImageView release];
    
    // ナビゲーションバーのタイトルの設定
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kSNSNavigationBarTitleFacebook];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
    
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setExclusiveTouch:YES];
    [doneButton setFrame:CGRectMake(kDisplayWidth - 61.f, 4.f, 51.f, 36.f)];
    [doneButton setImage:[UIImage imageNamed:kSNSButtonDoneImageName] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:kSNSButtonDoneImageName] forState:UIControlStateDisabled];
    [doneButton addTarget:self
                   action:@selector(cancelBtnAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
} 

#pragma mark -

/*****************************************************************************
 * 確認アラート
 *****************************************************************************/
- (void) confirmAlertView:(NSString *)alertTitle alertMessage:(NSString *)aleartMessage {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:aleartMessage
                                                       delegate:self
                                              cancelButtonTitle:@"確認"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [indicator stopAnimating];
    
    if ([delegate respondsToSelector:@selector(setAutoSleepMode)]) {
        [delegate setAutoSleepMode];
    } 

    // つぶやき終了
    [self removeScreen];
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void) indicatorStart {
    
    indicator = [[UIActivityIndicatorView alloc] 
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.frame = CGRectMake(self.frame.size.width/2-20, 
                                 self.frame.size.height/2-20, 
                                 40, 
                                 40);
    [self addSubview:indicator];
    [indicator startAnimating];
    
    cancelBtn.enabled = NO;
    inputView.userInteractionEnabled = NO;
}

/***************************************************************
 * ストップ画面非表示
 ***************************************************************/
- (void)removeScreen {
    // Enter screen animation.
    CATransition *exitTransition = [CATransition animation];
    [exitTransition setDelegate:self];
    [exitTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
    [exitTransition setType:kCATransitionFade];
    [self.layer addAnimation:exitTransition forKey:nil];
    [self setAlpha:0.f];
}

/***************************************************************
 * アニメーション終了時
 ***************************************************************/
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [self removeFromSuperview];
    [self setAlpha:1.f];
}

#pragma mark -
#pragma mark Facebook

#pragma mark 投稿

/***************************************************************************************
 * アップロードを行う
 ***************************************************************************************/
- (void) fbUploadAction {
    [sendButton setEnabled:NO];
    [doneButton setEnabled:NO];
    
    if ([SNSService canUseNetwork:kAccessUrlFacebook]) {
        [self indicatorStart];
        
        //パラメータの生成
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:inputView.text forKey:@"message"];
        
        //画像のアップロードを行う
        [facebook requestWithMethodName:@"stream.publish"
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
        [params release];
    }
}


/***************************************************************************************
 * Connect to facebook
 ***************************************************************************************/
- (void) fbPermissionAction {
    PrintLog(@"Ask for permission");
    if (![facebook isSessionValid]) {

        //ウォールに投稿する為の権限を与える
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:kAppFacebookId forKey:@"client_id"];
        [params setObject:@"publish_stream" forKey:@"scope"];
        [facebook dialog:@"oauth" andParams:params andDelegate:self];
        [params release];
    }
}

#pragma mark FacebookDelegate

/*****************************************************************************
 * ログイン成功時
 *****************************************************************************/
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:kFacebookToken];
    [defaults setObject:[facebook expirationDate] forKey:kFacebookExpirationDate];
    [defaults synchronize];
    PrintLog(@"Login Successful");
}

/*****************************************************************************
 * ログイン失敗（キャンセル）
 *****************************************************************************/
- (void)fbDidNotLogin:(BOOL)cancelled {
    PrintLog(@"Login Cancelled");
    [self removeScreen];
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)fbDidLogout {
    [self confirmAlertView:@"認証エラー" alertMessage:@"認証に失敗しました"];
    PrintLog(@"Login Failed");
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)fbKeepTokenAction {

}

#pragma mark - Post finished methods

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    PrintLog(@"%@", error);
    facebook.sessionDelegate = nil;
    [self confirmAlertView:@"Facebook" alertMessage:kPostConfirmNg];
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    facebook.sessionDelegate = nil;
    [self confirmAlertView:@"Facebook" alertMessage:kPostConfirmOk];
}

#pragma mark -
#pragma mark ビューの生成

/*****************************************************************************
 * 
 *****************************************************************************/
- (void) cancelBtnAction {
    if ([delegate respondsToSelector:@selector(setAutoSleepMode)]) {
        [delegate setAutoSleepMode];
    } 
    
    [self removeScreen];
}

#pragma mark -
#pragma mark UITextViewDelegate

/*****************************************************************************
 * 
 *****************************************************************************/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text length] + [text length] - range.length <= kMaxLength) {
        return YES;
    }else{
        return NO;
    }
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void)textViewDidChange:(UITextView *)textView {
    [letterCountLabel setText:[NSString stringWithFormat:@"%d文字", kMaxLength - [textView.text length]]];
}

@end
