//
//  TwitterView.m
//  Masuda
//
//  Created by ShinjiYamamoto on 11/04/18.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import "TwitterView.h"

#import "SA_OAuthTwitterEngine.h"

#import "SNSService.h"

#define kTwitterTitle               @"Twitter"
#define kTweetConfirmOk             @"投稿しました"
#define kTweetConfirmNg             @"投稿に失敗しました"

#define kMaxLength                  140
#define kFormatCharLength           3
#define kHashTag                    @"#diet"


@interface  TwitterView()

- (void) initView;
- (void) twitterPermissionAction;
- (void)removeScreen;

@end

@implementation TwitterView

/***************************************************************
 * 
 ***************************************************************/
- (id)initWithFrame:(CGRect)frame defaultWord:(NSString *)_defaultWord delegate:(id)_delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        defaultWord = [[NSString alloc] initWithString:_defaultWord];
        delegate    = _delegate;
        
        // 最大入力長
        inputMaxLength = kMaxLength - kFormatCharLength - [kIntroString length] - [defaultWord length] - [kShortURL length] - [kHashTag length];
        
        [self initView];
    }
    return self;
}

/***************************************************************
 * 
 ***************************************************************/
- (void) initView {
    
    self.backgroundColor = [UIColor whiteColor];

    [self navigationBarSetting];
    
    UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 68, 300, 100)];
    [frameImageView setImage:[UIImage imageNamed:kSNSFrameImageName]];
    [self addSubview:frameImageView];
    [frameImageView release];
    
    // 入力エリア
    inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 96)];
    [inputView setText:[NSString stringWithFormat:@"%@\n【%@】%@ %@", kIntroString, defaultWord, kShortURL, kHashTag]];
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
                   action:@selector(tweetAction)
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
    
    [self twitterPermissionAction];
}

/***************************************************************
 * 
 ***************************************************************/
- (void)dealloc {
    
    [_engine release];
    [indicator release];
    
    delegate = nil;
    [super dealloc];
}

/***************************************************************
 * 
 ***************************************************************/
- (void) cancelBtnAction {
    if ([delegate respondsToSelector:@selector(changeIsTopView:)]) {
        [delegate changeIsTopView:YES];
    }
    if ([delegate respondsToSelector:@selector(setAutoSleepMode)]) {
        [delegate setAutoSleepMode];
    } 
    [self removeScreen];
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
    [navigationBarTitleLabel setText:kSNSNavigationBarTitleTwitter];
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

/***************************************************************
 * 
 ***************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [indicator stopAnimating];
    
    if ([delegate respondsToSelector:@selector(setAutoSleepMode)]) {
        [delegate setAutoSleepMode];
    } 
    
    // つぶやき終了
    [self removeScreen];
}

/***************************************************************
 * 
 ***************************************************************/
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
#pragma mark Twitter

/*****************************************************************************
 * つぶやく
 *****************************************************************************/
- (void)tweetAction {
    [sendButton setEnabled:NO];
    [doneButton setEnabled:NO];

    if ([SNSService canUseNetwork:kAccessUrlTwitter]) {
        [self indicatorStart];

        [_engine sendUpdate:[inputView text]];
    }
}

/*****************************************************************************
 * Twitter認証状況の確認
 *****************************************************************************/
- (void)twitterPermissionAction {
    // ネットワークチェック
    if ([SNSService canUseNetwork:kAccessUrlTwitter]) {
        //TwitterEngineの生成
        if(!_engine){
            _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
            _engine.consumerKey    = kTwitterOAuthConsumerKey;
            _engine.consumerSecret = kTwitterOAuthConsumerSecret;
        }
        
        //Twtter登録画面の取得
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];

        // 登録されているか判断
        if (controller) {
            [delegate presentModalViewController: controller animated: YES];
        }
    }
}


#pragma mark SA_OAuthTwitterEngineDelegate

/***************************************************************
 * 
 ***************************************************************/
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    PrintLog(@"Stored twitter OAuth Data");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:kTwitterAuthDataKey];
}  

/***************************************************************
 * 
 ***************************************************************/
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    return [[NSUserDefaults standardUserDefaults] objectForKey:kTwitterAuthDataKey];  
}  

#pragma mark TwitterEngineDelegate  

/***************************************************************
 * 
 ***************************************************************/
- (void) requestSucceeded: (NSString *) requestIdentifier {
    [self confirmAlertView:@"Twitter" alertMessage:kTweetConfirmOk];
}  

/***************************************************************
 * 
 ***************************************************************/
- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
    PrintLog(@"Error: %@", error);
    [self confirmAlertView:@"Twitter" alertMessage:kTweetConfirmNg];
}

#pragma mark - SA_OAuthTwitterViewController Delegate

/***************************************************************************************
 *　Authentication succeeded.
 ***************************************************************************************/
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    if ([delegate respondsToSelector:@selector(changeIsTopView:)]) {
        [delegate changeIsTopView:NO];
    }
}

/***************************************************************************************
 *　Authentication failed.
 ***************************************************************************************/
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    if ([delegate respondsToSelector:@selector(changeIsTopView:)]) {
        [delegate changeIsTopView:NO];
    }
    
    [self confirmAlertView:@"認証エラー" alertMessage:@"認証に失敗しました"];
}

/***************************************************************************************
 *　Authentication cancelled.
 ***************************************************************************************/
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    if ([delegate respondsToSelector:@selector(changeIsTopView:)]) {
        [delegate changeIsTopView:NO];
    }
    
    [self removeScreen];
}

#pragma mark -
#pragma mark UITextViewDelegate

/***************************************************************
 * 
 ***************************************************************/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text length] + [text length] - range.length <= kMaxLength) {
        return YES;
    }else{
        return NO;
    }
}

/***************************************************************
 * 
 ***************************************************************/
- (void)textViewDidChange:(UITextView *)textView {
    [letterCountLabel setText:[NSString stringWithFormat:@"%d文字", kMaxLength - [textView.text length]]];
}

@end
