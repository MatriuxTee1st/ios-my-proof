//
//  RecipeCell.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/17.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeCell.h"


@implementation RecipeCell
@synthesize photoImageView;
@synthesize timeIconImageView;
@synthesize calorieIconImageView;
@synthesize costIconImageView;
@synthesize carbIconImageView;
@synthesize addonImageView;
@synthesize recipeNameLabel;
@synthesize costLabel;
@synthesize timeLabel;
@synthesize calorieLabel;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 70, 76)];
        [self.contentView addSubview:photoImageView];
        [photoImageView release];
        
        recipeNameLabel = [[VerticalUpLabel alloc] init];
        [recipeNameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [recipeNameLabel setBackgroundColor:[UIColor clearColor]];
        [recipeNameLabel setTextColor:[UIColor blackColor]];
        [recipeNameLabel setNumberOfLines:2];
        [recipeNameLabel setFrame:CGRectMake(88, 10, 210, 40)];
        [self.contentView addSubview:recipeNameLabel];
        [recipeNameLabel release];
        
        costIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(74, 60, 25, 25)];
        [costIconImageView setImage:[UIImage imageNamed:kCostIconImageName]];
        [self.contentView addSubview:costIconImageView];
        [costIconImageView release];
        
        calorieIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(146, 60, 25, 25)];
        [calorieIconImageView setImage:[UIImage imageNamed:kCalorieIconImageName]];
        [self.contentView addSubview:calorieIconImageView];
        [calorieIconImageView release];

//        timeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(224, 60, 25, 25)];
//        [timeIconImageView setImage:[UIImage imageNamed:kTimeIconImageName]];
//        [self.contentView addSubview:timeIconImageView];
//        [timeIconImageView release];
        
        costLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 62, 66, 25)];
        [costLabel setHighlightedTextColor:[UIColor whiteColor]];
        [costLabel setFont:[UIFont systemFontOfSize:kTimeAndCalorieFontSize]];
        [costLabel setTextColor:kColorRecipeGreyText];
        [costLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:costLabel];
        [costLabel release];
      
        calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 62, 66, 25)];
        [calorieLabel setHighlightedTextColor:[UIColor whiteColor]];
        [calorieLabel setFont:[UIFont systemFontOfSize:kTimeAndCalorieFontSize]];
        [calorieLabel setTextColor:kColorRecipeGreyText];
        [calorieLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:calorieLabel];
        [calorieLabel release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(248, 62, 66, 25)];
        [timeLabel setHighlightedTextColor:[UIColor whiteColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:kTimeAndCalorieFontSize]];
        [timeLabel setTextColor:kColorRecipeGreyText];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:timeLabel];
        [timeLabel release];
        
        
        addonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 29.f, 29.f)];
        [addonImageView setImage:[UIImage imageNamed:kStoreNewBadgeImageName]];
        [addonImageView setBackgroundColor:[UIColor clearColor]];
        [addonImageView setHidden:YES];
        [self.contentView addSubview:addonImageView];
        [addonImageView release];
        
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
