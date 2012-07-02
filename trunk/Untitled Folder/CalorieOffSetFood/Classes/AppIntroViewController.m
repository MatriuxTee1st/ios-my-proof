//
//  AppIntroViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 3/9/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppIntroViewController.h"

static NSString * appUrlString = @"http://www.oisy-yakuzen.jp/application/application_list.html";

@interface AppIntroViewController ()

- (void)indicatorAppearAnimation;
- (void)indicatorDisappearAnimation;

@end

@implementation AppIntroViewController

#pragma mark -
#pragma mark Initialization
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle
/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navigationBarSetting];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, 368)];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    [webView release];
    
    indicatorBackView = [[UIView alloc] initWithFrame:CGRectMake(130, 145, 60, 60)];
    [indicatorBackView setBackgroundColor:[UIColor blackColor]];
    [indicatorBackView setAlpha:0.5f];
    indicatorBackView.layer.cornerRadius = 10.0f;
    [indicatorBackView setHidden:YES];
    [self.view addSubview:indicatorBackView];
    [indicatorBackView release];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 150, 50, 50)];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView release];
    
    NSURL *url = [NSURL URLWithString:appUrlString];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self indicatorAppearAnimation];
}

/***************************************************************
 * ナビゲーションバーの設定
 ***************************************************************/
- (void)navigationBarSetting {
    // ナビゲーションバーの設定
    UIImage *navigationBarImage = [UIImage imageNamed:kNavigationBarImageName];
    UIImageView *navigationBarImageView = [[UIImageView alloc] initWithImage:navigationBarImage];
    navigationBarImageView.frame = kNavigationBarFrame;
    [self.view addSubview:navigationBarImageView];
    [navigationBarImageView release];
    
    // ナビゲーションバーのタイトルの設定
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kNavigationBarTitleAppIntroName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
    
    // ナビゲーションバーの戻るボタンの設定
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:kBackButtonImageName] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(kNavigationBarLeftButtonOriginX,
                                    kNavigationBarButtonOriginY,
                                    backButton.imageView.image.size.width + kButtonTouchBuffer,
                                    backButton.imageView.image.size.height)];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}  

/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************
 * インジケータ表示アニメーション
 ***************************************************************/
- (void)indicatorAppearAnimation {
    if (![indicatorView isAnimating]) {
        CATransition *fadeTransition = [CATransition animation];
        [fadeTransition setType:kCATransitionFade];
        [fadeTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [indicatorBackView.layer addAnimation:fadeTransition forKey:nil];
    }
    [indicatorBackView setHidden:NO];
    
    [indicatorView startAnimating];
}

/***************************************************************
 * インジケータ非表示アニメーション
 ***************************************************************/
- (void)indicatorDisappearAnimation {
    [indicatorView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
    [indicatorBackView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [indicatorView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
                         [indicatorBackView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
                     }
                     completion:^(BOOL finished) {
                         [indicatorView stopAnimating];
                         [indicatorBackView setHidden:YES];
                         [indicatorView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                         [indicatorBackView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)]; 
                     }
     ];    
}

#pragma mark - Wev View Delegate methods

/***************************************************************
 * 通信開始時
 ***************************************************************/
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

/***************************************************************
 * 通信完了時
 ***************************************************************/
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self indicatorDisappearAnimation];
}

/***************************************************************
 * 通信失敗時
 ***************************************************************/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self indicatorDisappearAnimation];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                        message:@"しばらくしてから再度お試しください"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark Memory management

/***************************************************************
 * メモリ警告時
 ***************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

/***************************************************************
 * メモリ警告後
 ***************************************************************/
- (void)viewDidUnload {
    [super viewDidUnload];
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}

@end
