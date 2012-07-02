//
//  SNSService.h
//
//  Created by nolan.warner on 11/10/27.
//  Copyright 2011 redfox, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

#import "SNSSettingsViewController.h"

#import "TwitterView.h"
#import "FacebookView.h"

#import "Facebook.h"

#define kAccessUrlTwitter   @"http://twitter.com/"
#define kAccessUrlFacebook  @"http://www.facebook.com/"
//#define kAccessUrlMixi      @"http://www.mixi.jp/"

#define kTwitterOAuthConsumerKey    @"bXmNhWNATMvsA7uUfV9SA";
#define kTwitterOAuthConsumerSecret @"YNfzEP9VSX03z2ozYW3Ku9PwEgYFBroj5hbUoUAKw";
#define kTwitterAuthDataKey         @"twitterAuthData"
#define kFacebookToken              @"fbToken"
#define kFacebookExpirationDate     @"fbExpirationDate"
#define kShortURL                   @"http://goo.gl/aNS7y"
#define kIntroString                @"糖質オフダイエットアプリ"

@interface SNSService : NSObject <MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    id delegate;
    UIView *currentView;
    
    NSString *recipeContents;
    NSString *recipeName;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *recipeContents;
@property (nonatomic, retain) NSString *recipeName;

+ (BOOL)canUseNetwork:(NSString *)accessUrl;
- (void)doSNS;

@end

@protocol SNSServiceDelegate

- (void)setAutoSleepMode;

@end