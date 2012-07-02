//
//  SplashViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/1/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "SplashViewController.h"

@implementation SplashViewController

@synthesize delegate;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [imageView setContentMode:UIViewContentModeBottom];
    [self.view addSubview:imageView];
    [imageView release];
}

/***************************************************************
 * ビュー表示後
 ***************************************************************/
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([delegate respondsToSelector:@selector(splashScreenDidAppear:)]) {
        [delegate splashScreenDidAppear:self];
    }
    [self performSelector:@selector(hide) withObject:nil afterDelay:2.5f];
}

/***************************************************************
 * ビュー非表示後
 ***************************************************************/
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([delegate respondsToSelector:@selector(splashScreenDidDisappear:)]) {
        [delegate splashScreenDidDisappear:self];
    }
}

/***************************************************************
 * スプラッシュ画像の非表示
 ***************************************************************/
- (void)hide {
    [self dismissModalViewControllerAnimated:YES];
}

/***************************************************************
 * メモリ警告時
 ***************************************************************/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/***************************************************************
 * メモリ警告後
 ***************************************************************/
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}

@end
