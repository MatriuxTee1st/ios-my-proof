//
//  DiagnosisResultViewController.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/11.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface DiagnosisResultViewController : UIViewController {
    NSDictionary *resultDictionary;
    NSInteger type;
}
- (id)initWithType:(NSInteger)type_;
- (void)navigationBarSetting;

@end
