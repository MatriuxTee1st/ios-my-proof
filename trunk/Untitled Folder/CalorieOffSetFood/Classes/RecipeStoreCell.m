//
//  RecipeStoreCell.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeStoreCell.h"

@implementation RecipeStoreCell

@synthesize photoImageView;
@synthesize arrowImageView;
@synthesize recipeTitleLabel;
@synthesize leadLabel;
@synthesize priceLabel;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 16, 70, 76)];
        [self.contentView addSubview:photoImageView];
        [photoImageView release];
        
        arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kArrowIconOffsetX, 
                                                                       floorf((108.f - kArrowIconSizeHeight) / 2.f),
                                                                       kArrowIconSizeWidth, 
                                                                       kArrowIconSizeHeight)];
        [arrowImageView setImage:[UIImage imageNamed:kTopArrowImageName]];
        [self.contentView addSubview:arrowImageView];
        [arrowImageView release];
        
        recipeTitleLabel = [[VerticalUpLabel alloc] init];
        [recipeTitleLabel setBackgroundColor:[UIColor clearColor]];
        [recipeTitleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [recipeTitleLabel setTextColor:[UIColor colorWithRed:0.275f green:0.208f blue:0.047f alpha:1.0f]];
        [recipeTitleLabel setFont:[UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize]];
        [recipeTitleLabel setNumberOfLines:2];
        [recipeTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [recipeTitleLabel setFrame:CGRectMake(82, 6, 165, 40)];
        [self.contentView addSubview:recipeTitleLabel];
        [recipeTitleLabel release];
        
        leadLabel = [[VerticalUpLabel alloc] initWithFrame:CGRectMake(82, 50, 200, 56)];
        [leadLabel setHighlightedTextColor:[UIColor whiteColor]];
        [leadLabel setFont:[UIFont systemFontOfSize:11]];
        [leadLabel setTextColor:kColorRecipeGreyText];
        [leadLabel setNumberOfLines:0];
        [leadLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        [leadLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:leadLabel];
        [leadLabel release];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(247, 6, 55, 20)];
        [priceLabel setHighlightedTextColor:[UIColor whiteColor]];
        [priceLabel setFont:[UIFont systemFontOfSize:13]];
        [priceLabel setTextColor:kColorRecipeGreyText];
        [priceLabel setTextAlignment:UITextAlignmentRight];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:priceLabel];
        [priceLabel release];
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
