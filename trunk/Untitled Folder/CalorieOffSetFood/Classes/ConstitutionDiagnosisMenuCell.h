//
//  ConstitutionDiagnosisMenuCell.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/25.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConstitutionDiagnosisMenuCell : UITableViewCell {
    UILabel *titleLabel;
    UILabel *colorLabel;
    UIImageView *arrowImageView;
}
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *colorLabel;
@property(nonatomic, retain) UIImageView *arrowImageView;
@end
