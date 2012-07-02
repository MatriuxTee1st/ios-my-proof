//
//  ConstitutionDiagnosisCell.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/17.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchingButton.h"


@interface ConstitutionDiagnosisCell : UITableViewCell {
    UILabel *questionLabel;
    SwitchingButton *selectButton;
    
}

@property(nonatomic, retain) UILabel *questionLabel;
@property(nonatomic, retain) SwitchingButton *selectButton;

@end
