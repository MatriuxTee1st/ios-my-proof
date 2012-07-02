//
//  RecipeCell.h
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/17.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalUpLabel.h"

@interface RecipeCell : UITableViewCell {
    UIImageView *photoImageView;
    UIImageView *timeIconImageView;
    UIImageView *calorieIconImageView;
    UIImageView *costIconImageView;
    UIImageView *carbIconImageView;
    UIImageView *addonImageView;
    VerticalUpLabel *recipeNameLabel;
    UILabel *costLabel;
    UILabel *timeLabel;
    UILabel *calorieLabel;
}

@property(nonatomic, retain) UIImageView *photoImageView;
@property(nonatomic, retain) UIImageView *timeIconImageView;
@property(nonatomic, retain) UIImageView *calorieIconImageView;
@property(nonatomic, retain) UIImageView *costIconImageView;
@property(nonatomic, retain) UIImageView *carbIconImageView;
@property(nonatomic, retain) UIImageView *addonImageView;
@property(nonatomic, retain) VerticalUpLabel *recipeNameLabel;
@property(nonatomic, retain) UILabel *costLabel;
@property(nonatomic, retain) UILabel *timeLabel;
@property(nonatomic, retain) UILabel *calorieLabel;

@end
