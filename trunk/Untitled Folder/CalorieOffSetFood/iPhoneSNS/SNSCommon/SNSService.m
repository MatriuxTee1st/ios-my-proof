//
//  SNSService.m
//
//  Created by nolan.warner on 11/10/27.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import "SNSService.h"

#import "Reachability.h"

@interface SNSService ()
- (void)showMailModalView;
@end

@implementation SNSService

@synthesize delegate;
@synthesize recipeContents;
@synthesize recipeName;

/***************************************************************************************
 *　Network error alert.
 ***************************************************************************************/
+ (void) networkErrorAlert {
    
    UIAlertView *networkAlertView = [[UIAlertView alloc] initWithTitle:@"通信エラー"
                                                               message:@"通信状況を確認して下さい"
                                                              delegate:nil
                                                     cancelButtonTitle:@"確認"
                                                     otherButtonTitles:nil];
    [networkAlertView show];
    [networkAlertView release];    
}

/***************************************************************************************
 *　メモリ解放
 ***************************************************************************************/
- (void)dealloc {
    [recipeContents release], recipeContents = nil;
    [recipeName release], recipeName = nil;
    [super dealloc];
}

/***************************************************************************************
 *　ネットワークに接続されているかチェックする
 ***************************************************************************************/
+ (BOOL) canUseNetwork:(NSString *)accessUrl {
    
    NSString *connectPage = accessUrl;
    
    connectPage = [connectPage stringByReplacingOccurrencesOfString:@"http://"
                                                                 withString:@""];
    
    connectPage = [connectPage substringToIndex:[connectPage rangeOfString:@"/"].location];
    
    Reachability *hostReach = [Reachability reachabilityWithHostName:connectPage];
    if ([hostReach currentReachabilityStatus] == NotReachable){
        [self networkErrorAlert];
        return NO;
    } else {
        return YES;
    }
}

/***************************************************************************************
 *　Perform SNS action.
 ***************************************************************************************/
- (void)doSNS {
    currentView = [[delegate tabBarController] view];
    UIActionSheet *snsSheet = [[UIActionSheet alloc] initWithTitle:@"シェアー方法を選択して下さい"
                                                          delegate:self
                                                 cancelButtonTitle:@"キャンセル"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Twitter", @"Facebook", @"材料をメールで送信", @"アカウント設定", nil];
    
    snsSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [snsSheet showFromTabBar:[delegate tabBarController].tabBar];
    [snsSheet release];
}

/***************************************************************************************
 *　Show SNS options.
 ***************************************************************************************/
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Twitter
    if (buttonIndex == 0) {
        TwitterView *twitterView = [[TwitterView alloc] initWithFrame:CGRectMake(0.f, kStatusBarHeight, kDisplayWidth, kDisplayHeight - kStatusBarHeight) 
                                                          defaultWord:recipeName
                                                             delegate:delegate];
        [currentView addSubview:twitterView];
        [twitterView release];
        PrintLog(@"Twitter");
    }
    // Facebook
    else if (buttonIndex == 1) {
        FacebookView *facebookView = [[FacebookView alloc] initWithFrame:CGRectMake(0.f, kStatusBarHeight, kDisplayWidth, kDisplayHeight - kStatusBarHeight)
                                                             defaultWord:recipeName
                                                                delegate:delegate];
        [currentView addSubview:facebookView];
        [facebookView release];
        PrintLog(@"Facebook");
    }
    // Mail
    else if (buttonIndex == 2) {
        [self showMailModalView];
    }
    // SNS Settings
    else if (buttonIndex == 3) {
        SNSSettingsViewController *settingsVC = [[SNSSettingsViewController alloc] init];
        [settingsVC setDelegate:delegate];
        if ([delegate respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [delegate presentModalViewController:settingsVC animated:YES];
        }
        [settingsVC release];
    }
    // Cancel
    else if (buttonIndex == 4) {
        if ([delegate respondsToSelector:@selector(setAutoSleepMode)]) {
            [delegate setAutoSleepMode];
        } 
    }
}

/***************************************************************
 * メール送信表示
 ***************************************************************/
- (void)showMailModalView {
    NSString *subject = [NSString stringWithFormat:@"買い物リスト: %@", recipeName];
    NSString *body = [NSString stringWithFormat:@"%@", recipeContents];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMailComposeDelegate:self];
        
        // 件名内容
        [mailViewController setSubject:subject];
        
        // 本文内容
        [mailViewController setMessageBody:body isHTML:NO];
        
        [delegate presentModalViewController:mailViewController animated:YES];
        [mailViewController release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"メール設定" 
                                                        message:@"メールアドレスを設定して下さい。"
                                                       delegate:self 
                                              cancelButtonTitle:@"確認" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

/***************************************************************
 * メール送信ボタンまたはキャンセルボタン押下時
 ***************************************************************/
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error { 
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            PrintLog(@"Canceled");
            break;
        case MFMailComposeResultSaved:
            PrintLog(@"Saved");
            break;
        case MFMailComposeResultSent:
            PrintLog(@"Sent");
            break;
        case MFMailComposeResultFailed:
            PrintLog(@"Failed with error message: %@", [error description]);
            break;
        default: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"メール" message:@"メール通信が出来ませんでした。"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        }
    }
    
    [delegate dismissModalViewControllerAnimated:YES];
}

@end
