//
//  Utility.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SwitchingButton.h"

@interface Utility : NSObject {

    
}
+ (id)makeStandardButton:(UIButton *)button 
              title:(NSString *)title 
                  x:(float)x
                  y:(float)y
              width:(float)width
             height:(float)height;
+ (NSArray *)getConstitutionDiagnosisQuestionDictionary;
+ (NSArray *)getConstitutionDiagnosisResultDictionary;
+ (NSArray *)getMedicinalCarbOffDictionaryArray;
+ (NSArray *)getFoodDictionaryArray;
+ (NSArray *)getColumnArray;
+ (NSDictionary *)getIntroductionDictionary;
+ (NSDictionary *)getEditorDictionary;
+ (void)settingNavigationBarTitleLabel:(UILabel *)label;
+ (void)setSelectButtonImage:(SwitchingButton *)selectButton;
+ (void)setLastProductNotificationCount:(NSInteger)count;
+ (NSInteger)lastProductNotificationCount;
+ (NSDate *)getTomorrowNoonDate;
+ (void)scheduleNotificationWithCount:(NSInteger)count;
+ (void)cancelNotification;

@end
