//
//  SNSSettingsViewController.m
//  SocialNetworking
//
//  Created by Nolan Warner on 10/18/11.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "SNSSettingsViewController.h"
#import "SA_OAuthTwitterEngine.h"
#include "SNSService.h"

static CGFloat rowHeight = 44.f;

@interface SNSSettingsViewController ()

- (void)clearTwitter;
- (void)clearFacebook;
- (void) indicatorStart;

@end

@implementation SNSSettingsViewController

@synthesize delegate;

/***************************************************************
 * 
 ***************************************************************/
- (void)dealloc {
    [_accountTableView release], _accountTableView = nil;
    [twitterEngine release], twitterEngine = nil;
    [facebook release], facebook = nil;
    [super dealloc];
}

/***************************************************************
 * 
 ***************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        facebook = [[Facebook alloc] initWithAppId:kAppFacebookId andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:kFacebookToken] 
            && [defaults objectForKey:kFacebookExpirationDate]) {
            facebook.accessToken = [defaults objectForKey:kFacebookToken];
            facebook.expirationDate = [defaults objectForKey:kFacebookExpirationDate];
        }
    }
    return self;
}

/***************************************************************
 * 
 ***************************************************************/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/***************************************************************
 * 
 ***************************************************************/
- (void)loadView {
    [super loadView];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self navigationBarSetting];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // ネットワークチェック
    if([defaults valueForKey:kTwitterAuthDataKey]){
        isTwitterSaved = YES;
    } else {
        isTwitterSaved = NO;
    }
    
    if([defaults valueForKey:kFacebookToken]){
        isFBSaved = YES;
    } else {
        isFBSaved = NO;
    }
    
    _accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, 150) 
                                                         style:UITableViewStyleGrouped];
    [_accountTableView setDelegate:self];
    [_accountTableView setDataSource:self];
    [_accountTableView setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:_accountTableView];
    
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
    [navigationBarTitleLabel setText:kSNSNavigationBarTitleAccountSettings];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(kDisplayWidth - 61.f, 4.f, 51.f, 36.f)];
    [doneButton setImage:[UIImage imageNamed:kSNSButtonDoneImageName] forState:UIControlStateNormal];
    [doneButton addTarget:self
                   action:@selector(done)
         forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:doneButton];
} 

/***************************************************************
 * 
 ***************************************************************/
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/***************************************************************
 * 
 ***************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

/***************************************************************
 * 
 ***************************************************************/
- (void)done {
    if ([delegate respondsToSelector:@selector(setAutoSleepMode)]) {
        [delegate setAutoSleepMode];
    } 
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table Data Source

/***************************************************************
 * 
 ***************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/***************************************************************
 * 
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

/***************************************************************
 * 
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return rowHeight;
}

/***************************************************************
 * 
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.f, 0.f, 100.f, rowHeight)];
        [statusLabel setBackgroundColor:[UIColor clearColor]];
        [statusLabel setFont:[UIFont systemFontOfSize:14]];
        [statusLabel setTag:7200];
        [statusLabel setTextColor:kColorGrayText];
        [cell.contentView addSubview:statusLabel];
        [statusLabel release];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kArrowIconOffsetX - 10, 
                                                                                    floorf((rowHeight - kArrowIconSizeHeight) / 2.f),
                                                                                    kArrowIconSizeWidth, 
                                                                                    kArrowIconSizeHeight)];
        [arrowImageView setImage:[UIImage imageNamed:kTopArrowImageName]];
        [[cell contentView] addSubview:arrowImageView];
        [arrowImageView release];
    }
    
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:7200];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Twitter";
        
        if (isTwitterSaved) {
            [statusLabel setText:NSLocalizedString(@"解除する", @"解除する")];
        } else {
            [statusLabel setText:NSLocalizedString(@"設定する", @"設定する")];
        }
    } 
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Facebook";
        
        if (isFBSaved) {
            [statusLabel setText:NSLocalizedString(@"解除する", @"解除する")];
        } else {
            [statusLabel setText:NSLocalizedString(@"設定する", @"設定する")];
        }
    }
    
    return cell;
}

/***************************************************************
 * 
 ***************************************************************/
- (void) indicatorStart {
    
    indicator = [[UIActivityIndicatorView alloc] 
                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.frame = CGRectMake(self.view.frame.size.width/2-20, 
                                 self.view.frame.size.height/2-20, 
                                 40, 
                                 40);
    [self.view addSubview:indicator];
    [indicator release];
    [indicator startAnimating];
}

/***************************************************************
 * 
     ***************************************************************/
- (void) confirmAlert:(NSString *)snsTitle {
    
    UIAlertView *networkAlertView = [[UIAlertView alloc] initWithTitle:snsTitle
                                                               message:@"認証情報を削除しました"
                                                              delegate:nil
                                                     cancelButtonTitle:@"確認"
                                                     otherButtonTitles:nil];
    [networkAlertView show];
    [networkAlertView release]; 
}

/***************************************************************
 * 
 ***************************************************************/
- (void)clearFacebook {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:kFacebookToken];
    [defaults setValue:nil forKey:kFacebookExpirationDate];
    [defaults synchronize];
    
    // 通信状況の確認を行う
    if ([SNSService canUseNetwork:kAccessUrlFacebook]) {
        [facebook logout:self];
        [self confirmAlert:@"Facebook"];
        isFBSaved = NO;
        [_accountTableView reloadData];
    }
}

/***************************************************************
 * 
 ***************************************************************/
- (void)clearTwitter {
    // 通信状況の確認を行う
    if ([SNSService canUseNetwork:kAccessUrlTwitter]) {
        [twitterEngine clearAccessToken];
        
        isTwitterSaved = NO;
        
        [_accountTableView reloadData];
        
        [self confirmAlert:@"Twitter"];
    }
}

#pragma mark - Table Delegate

/***************************************************************
 * 
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // twitter
    if (indexPath.row == 0) {
        
        if (isTwitterSaved) {
            UIAlertView *clearAlertView = [[UIAlertView alloc] initWithTitle:@"連携の削除"
                                                                       message:@"連携を削除しますか？"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"いいえ"
                                                             otherButtonTitles:@"はい", nil];
            [clearAlertView setDelegate:self];
            [clearAlertView setTag:202];
            [clearAlertView show];
            [clearAlertView release];
        } else {
            // ネットワークチェック
            if ([SNSService canUseNetwork:kAccessUrlTwitter]) {
                //TwitterEngineの生成
                twitterEngine.consumerKey    = kTwitterOAuthConsumerKey;
                twitterEngine.consumerSecret = kTwitterOAuthConsumerSecret;
                
                //Twtter登録画面の取得
                UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine
                                                                                                               delegate:self];
                
                // 登録さpれているか判断
                // 登録済みの場合
                if (controller){
                    //登録されていない場合、登録画面を表示する
                    [self presentModalViewController:controller animated:YES];
                }
            }
        }
    } 
    
    // facebook
    else if (indexPath.row == 1) {
        if (isFBSaved) {
            UIAlertView *clearAlertView = [[UIAlertView alloc] initWithTitle:@"連携の削除"
                                                                     message:@"連携を削除しますか？"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"いいえ"
                                                           otherButtonTitles:@"はい", nil];
            [clearAlertView setDelegate:self];
            [clearAlertView setTag:203];
            [clearAlertView show];
            [clearAlertView release];
        } else {
            // デリゲートの設定
            // ネットワークチェック
            if ([SNSService canUseNetwork:kAccessUrlFacebook]) {
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
        }
    }
}

#pragma mark - UIAlertViewDelegate

/***************************************************************
 * 
 ***************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Yes
    if (buttonIndex == 1) {
        if ([alertView tag] == 202) {
            [self clearTwitter];
        } else if ([alertView tag] == 203) {
            [self clearFacebook];
        }
    }
    // No
    else if (buttonIndex == 0) {
        
    }
}

#pragma mark - SA_OAuthTwitterEngineDelegate

/***************************************************************
 * 
 ***************************************************************/
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:kTwitterAuthDataKey];
    [defaults synchronize];
    
    isTwitterSaved = YES;
    [_accountTableView reloadData];
}  

/***************************************************************
 * 
 ***************************************************************/
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kTwitterAuthDataKey];  
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
    
    isFBSaved = YES;
    [_accountTableView reloadData];
}

/*****************************************************************************
 * ログイン失敗（キャンセル）
 *****************************************************************************/
- (void)fbDidNotLogin:(BOOL)cancelled {
    
}

/***************************************************************
 * 
 ***************************************************************/
- (void)fbDidLogout {
    PrintLog(@"Facebook Did Logout");
}

@end
