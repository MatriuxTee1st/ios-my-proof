//
//  ConstitutionDiagnosisCell.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/17.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "ConstitutionDiagnosisCell.h"


@implementation ConstitutionDiagnosisCell
@synthesize questionLabel;
@synthesize selectButton;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 245, 59)];
        [questionLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [questionLabel setNumberOfLines:2];
        [self.contentView addSubview:questionLabel];
        [questionLabel release];
        
        selectButton = [[SwitchingButton alloc] init];
        [selectButton setFrame:CGRectMake(260, 3, 50, 50)];
        [selectButton setImage:[UIImage imageNamed:@"switch_off"]];
        [selectButton setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:selectButton];
        [selectButton release];
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
