//
//  MixiView.m
//  Masuda
//
//  Created by ShinjiYamamoto on 11/06/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MixiView.h"

#import "MixiAuthUIVC.h"

#define kMixiTitle          @"ツッコミ入力"
#define kMixiConfirmOk      @"ツッコミました"
#define kMixiConfirmNg      @"ツッコミに失敗しました"

#define kMaxLength          140
#define kFormatCharLength   5
#define kTag                @"薬膳レシピ"
#define kMixiAuthCodeKey    @"authorizationCode"
#define kMixiAccessTokenKey @"accessToken"
#define kMixiAccessTokenUrl @"http://mixi.jp/connect_authorize_success.html"
#define kAuthorityValue     @"r_profile w_voice"

@implementation MixiView


- (void) dealloc {
    
    [defaultWord release];
    
    [mixi release];
    mixi = nil;
    
    [super dealloc];
}


#pragma mark -

/*****************************************************************************
 * 閉じるボタン
 *****************************************************************************/
- (void) cancelBtnAction {
    [self removeFromSuperview];
}


/*****************************************************************************
 * 読み込み開始（インジケータビューの生成）
 *****************************************************************************/
- (void) indicatorStart {
    
    indicator = [[UIActivityIndicatorView alloc] 
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.frame = CGRectMake(self.frame.size.width/2-20, 
                                 self.frame.size.height/2-20, 
                                 40, 
                                 40);
    [self addSubview:indicator];
    [indicator startAnimating];
    [indicator release];
    
    cancelBtn.enabled = NO;
    inputView.userInteractionEnabled = NO;
}

/*****************************************************************************
 * 読み込み終了（インジケータ終了）
 *****************************************************************************/
- (void) indicatorEnd {
    if (indicator) {
        [indicator stopAnimating];
        indicator = nil;

        [self removeFromSuperview];
    }
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
    alertView.delegate = self;
    [alertView show];
    [alertView release];
}

/*****************************************************************************
 * アラート選択時
 *****************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self indicatorEnd];
}


#pragma mark -
#pragma mark ビューの生成

/*****************************************************************************
 * ナビゲーションバーの生成
 *****************************************************************************/
- (void) initNaviView {
    
    // スペース
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    // キャンセルボタン
    cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                              target:self
                                                              action:@selector(cancelBtnAction)];
    // ツールバーボタンリスト
    NSArray *toolBarBtnList = [[NSArray alloc] initWithObjects:space, cancelBtn, nil];
    [space release];
    [cancelBtn release];
    
    // ナビバー
    UIToolbar *naviBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    naviBar.barStyle = UIBarStyleBlack;
    [naviBar setItems:toolBarBtnList];
    [self addSubview:naviBar];
    [naviBar release];
    
    [toolBarBtnList release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, 160, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = kMixiTitle;
    [naviBar addSubview:titleLabel];
    [titleLabel release];
}

/*****************************************************************************
 * 
 *****************************************************************************/
- (void) initInputView {
    
    // 入力エリア
    inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 320, self.frame.size.height)];
    inputView.delegate               = self;
    inputView.textColor              = [UIColor whiteColor];
    inputView.backgroundColor        = [UIColor clearColor];
    inputView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    inputView.autocorrectionType     = UITextAutocorrectionTypeNo;
    inputView.returnKeyType          = UIReturnKeyDone;
    [self addSubview:inputView];
    [inputView release];
    
    [inputView becomeFirstResponder];
}

/*****************************************************************************
 * ビューの初期化
 *****************************************************************************/
- (void) initView {
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    [self initInputView];
    [self initNaviView];
}

#pragma mark -

/*****************************************************************************
 * 
 *****************************************************************************/
- (id)initWithFrame:(CGRect)frame defaultWord:(NSString *)_defaultWord delegate:(id)_delegate {
    self = [super initWithFrame:frame];
    if (self) {
        defaultWord = [[NSString alloc] initWithString:_defaultWord];
        delegate    = _delegate;
        
        // 最大入力長
        inputMaxLength = kMaxLength - kFormatCharLength - [kTag length] - [defaultWord length];
        
        [self initView];
    }
    return self;
}

#pragma mark -

/*****************************************************************************
 * ボイス投稿
 *****************************************************************************/
- (void) uploadVoice:(NSString *)_authorizationCode {
    
    //認証コードが存在する場合    
    if (_authorizationCode && ![_authorizationCode isEqualToString:@""]) {
        
        //認証コードの取得
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_authorizationCode forKey: kMixiAuthCodeKey];
        
        //アクセストークンの取得
        NSString *accessToken;
        accessToken = [defaults objectForKey:kMixiAccessTokenKey];
        
        //アクセストークンを保持していない場合
        if (!accessToken) {
            
            // Access Tokenの取得
            accessToken = [mixi getAccessToken:_authorizationCode 
                                   redirectURI:kMixiAccessTokenUrl];
        }
        
        //アクセストークンを設定
        [mixi setAccessToken:accessToken];
        
        // ボイス投稿
        [mixi postVoice:[NSString stringWithFormat:@"【%@ ー %@】%@", kTag, defaultWord, inputView.text]];
    }

    // 認証コードが存在しない場合（同意しない）
    else {
        [self indicatorEnd];
    }
}

/*****************************************************************************
 * 認証ビューの生成
 *****************************************************************************/
- (void) setAuthView {
    
    if (!mixi) {
        mixi = [[Mixi alloc] init:kMixiConsumerKey consumerSecret:kMixiConsumerKeySecret delegate:self];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //アクセストークンの取得
    NSString *accessToken       = [defaults objectForKey:kMixiAccessTokenKey];
    NSString *authorizationCode = [defaults objectForKey:kMixiAuthCodeKey];
    
    //アクセストークンが保持されてない場合
    if (!accessToken) {
        
        // Aauthorize request URLの作成
        NSString *urlString = [mixi getAauthorizeRequestURL:kAuthorityValue];
        
        //登録ビューの生成
        MixiAuthUIVC *mixiAuthUIVC              = [[MixiAuthUIVC alloc] init];
        mixiAuthUIVC.aDelegate                  = self;
        mixiAuthUIVC.authUrl                    = urlString;
        UINavigationController *mixiAuthNavi    = [[UINavigationController alloc] initWithRootViewController:mixiAuthUIVC];
        mixiAuthNavi.navigationBar.barStyle     = UIBarStyleBlack;
        [mixiAuthUIVC release];
        
        [delegate presentModalViewController:mixiAuthNavi animated:YES];
        [mixiAuthNavi release];
    } 
    
    //アクセストークンを保持している場合
    else {
        
        //つぶやき＆画像アップロード
        [self uploadVoice:authorizationCode];
    }
}

/*****************************************************************************
 * ボイスの投稿を行う
 *****************************************************************************/
- (void) mixiPostsVoice {
    
    [self indicatorStart];
    
    // 画像の投稿を行う
    [NSTimer scheduledTimerWithTimeInterval:0.0
                                     target:self
                                   selector:@selector(setAuthView)
                                   userInfo:nil
                                    repeats:NO];
}


/*****************************************************************************
 * 再コネクション
 *****************************************************************************/
- (void) mixiReAccessAction:(MixiAction) action {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (action == MixiActionGetAccessCode) {
        [self setAuthView];
    } else if (action == MixiActionPostVoice) {
        [self uploadVoice:[defaults objectForKey:kMixiAuthCodeKey]];
    }
}

- (void) mixiRequestFinished {
    [self confirmAlertView:@"mixi" alertMessage:kMixiConfirmOk];
}

- (void) mixiRequestFailed {
    [self confirmAlertView:@"mixi" alertMessage:kMixiConfirmNg];
}
- (void) mixiAuthCancel {
    [self indicatorEnd];
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	
    // 入力終了
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self mixiPostsVoice];
        return NO;
    } 
    
    // 入力中
    else{
        if ([textView.text length] + [text length] - range.length <= inputMaxLength) {
            return YES;
        }else{
            return NO;
        }
    }
}


@end
