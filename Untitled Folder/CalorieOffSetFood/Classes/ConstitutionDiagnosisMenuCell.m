//
//  ConstitutionDiagnosisMenuCell.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/25.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "ConstitutionDiagnosisMenuCell.h"

@implementation ConstitutionDiagnosisMenuCell
@synthesize titleLabel;
@synthesize colorLabel;
@synthesize arrowImageView;


/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, kDisplayWidth, 76)];
        [titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:titleLabel];
        [titleLabel release];
        
        colorLabel = [[UILabel alloc] init];
        [colorLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [colorLabel setTextColor:kColorGrayText];
        [self.contentView addSubview:colorLabel];
        [colorLabel release];
        
        arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kArrowIconOffsetX, 
                                                                       38,
                                                                       kArrowIconSizeWidth, 
                                                                       kArrowIconSizeHeight)];
        [arrowImageView setImage:[UIImage imageNamed:kTopArrowImageName]];
        [self.contentView addSubview:arrowImageView];
        [arrowImageView release];
    }
    return self;
}

/***************************************************************
 * 選択時
 ***************************************************************/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {    
    [super setSelected:selected animated:animated];
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [super dealloc];
}
@end