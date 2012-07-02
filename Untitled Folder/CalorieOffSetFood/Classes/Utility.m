//
//  Utility.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "Utility.h"


@implementation Utility

/***************************************************************
 * モック用ボタン生成
 ***************************************************************/
+ (id)makeStandardButton:(UIButton *)button 
                   title:(NSString *)title 
                       x:(float)x
                       y:(float)y
                   width:(float)width
                  height:(float)height {
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(x, y, width, height)];
    [button setTitle:title
            forState:UIControlStateNormal];
    return button;
}

/***************************************************************
 * 体質診断設問Dictionaryを返す
 ***************************************************************/
+ (NSArray *)getConstitutionDiagnosisQuestionDictionary {
    NSString *arrayPath = [[NSBundle mainBundle] pathForResource:@"ConstitutionDiagnosisQuestion" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:arrayPath];
}

/***************************************************************
 * 体質診断結果Dictionaryを返す
 ***************************************************************/
+ (NSArray *)getConstitutionDiagnosisResultDictionary {
    NSString *arrayPath = [[NSBundle mainBundle] pathForResource:@"ConstitutionDiagnosisResult" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:arrayPath];
}

/***************************************************************
 * 薬膳辞典Arrayを返す
 ***************************************************************/
+ (NSArray *)getMedicinalCarbOffDictionaryArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MedicinalCarbOffDictionary" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

/***************************************************************
 * 食材辞典Arrayを返す
 ***************************************************************/
+ (NSArray *)getFoodDictionaryArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FoodDictionary" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

/***************************************************************
 * 教えて薬膳コラムArrayを返す
 ***************************************************************/
+ (NSArray *)getColumnArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Column" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

/***************************************************************
 * このアプリについてDictionaryを返す
 ***************************************************************/
+ (NSDictionary *)getIntroductionDictionary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AboutThisApp" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

/***************************************************************
 * 監修者紹介Dictionaryを返す
 ***************************************************************/
+ (NSDictionary *)getEditorDictionary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Editor" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

/***************************************************************
 * ソート用比較関数
 ***************************************************************/
NSComparisonResult compareKey(id value1, id value2, void *context) { 
    
    NSString *string1 = (NSString *)value1;
    NSString *string2 = (NSString *)value2;
    NSLog(@"[compareKey] {}");
    
    
    return [string1 compare:string2];
}

/***************************************************************
 * ナビゲーションバーのタイトルラベルの設定
 ***************************************************************/
+ (void)settingNavigationBarTitleLabel:(UILabel *)label {
    
    [label setTextAlignment:UITextAlignmentCenter];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setTextColor:kNavigationBarTitleTextColor];
    [label setShadowColor:kNavigationBarTitleShadowColor];
    [label setBackgroundColor:[UIColor clearColor]];
}


/***************************************************************
 * 体質診断の選択ボタンの画像設定
 ***************************************************************/
+ (void)setSelectButtonImage:(SwitchingButton *)selectButton {
    if ([selectButton check]) {
        [selectButton setImage:[UIImage imageNamed:kSelectButtonOnImageName]];
    } else {
        [selectButton setImage:[UIImage imageNamed:kSelectButtonOffImageName]];
    }
}

/***************************************************************
 * 通知カウントを設定
 ***************************************************************/
+ (void)setLastProductNotificationCount:(NSInteger)count {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:count forKey:@"productNotificationCount"];
    [userDefaults synchronize];
}

/***************************************************************
 * 通知カウントを返す
 ***************************************************************/
+ (NSInteger)lastProductNotificationCount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [userDefaults integerForKey:@"productNotificationCount"];
    return count;
}

/***************************************************************
 * 通知の登録日を返す
 ***************************************************************/
+ (NSDate *)getTomorrowNoonDate {
    unsigned int intFlags        = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar         = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDate *tomorrowDate         = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24];
    NSDateComponents *components = [calendar components:intFlags fromDate:tomorrowDate];
    [components setHour:12];
    
    NSDate *tomorrowNoonDate = [calendar dateFromComponents:components];
    
    PrintLog(@"%@", [NSDate date]);
    PrintLog(@"tomorrowDate: %@", tomorrowDate);
    PrintLog(@"tomorrowNoonDate: %@", tomorrowNoonDate);
    
    
    return tomorrowNoonDate;
}

/***************************************************************
 * Schedule Notification
 ***************************************************************/
+ (void)scheduleNotificationWithCount:(NSInteger)count {
    
    
    NSInteger lastCount = [Utility lastProductNotificationCount];
    if (lastCount != count) {
        [Utility setLastProductNotificationCount:count];
        
        [Utility cancelNotification];
        
        if (count > 0) {
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil) {
                return;
            }
            localNotif.fireDate = [Utility getTomorrowNoonDate];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            
            localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"新しいアドオンレシピが%d件あります。", nil), count];
            localNotif.alertAction = NSLocalizedString(@"View Details", nil);
            
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = count;
            localNotif.repeatCalendar = [NSCalendar currentCalendar];
            localNotif.repeatInterval = NSMonthCalendarUnit;
            
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"event" forKey:@"key"];
            localNotif.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            [localNotif release];
        }
    } else {
        [Utility cancelNotification];
    }
    
}

/***************************************************************
 * Cancel Notification
 ***************************************************************/
+ (void)cancelNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
