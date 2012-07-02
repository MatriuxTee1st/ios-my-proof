//
//  BannerLinkViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/4/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "BannerLinkViewController.h"

@implementation BannerLinkViewController

@synthesize bannerURL;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}

#pragma mark - View lifecycle

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:kNavigationBarFrame];
    [self.view addSubview:navigationBar];
    [navigationBar release];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)] autorelease];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.f, 44.f, kDisplayWidth, kDisplayHeight - 44.f)];
    NSURLRequest *request = [NSURLRequest requestWithURL:bannerURL];
    [bannerURL release];
    
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView release];
}


/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)doneButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
