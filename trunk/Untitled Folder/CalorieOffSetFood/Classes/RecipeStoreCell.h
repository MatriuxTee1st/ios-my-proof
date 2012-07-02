//
//  RecipeStoreCell.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalUpLabel.h"

@interface RecipeStoreCell : UITableViewCell {
    UIImageView *photoImageView;
    UIImageView *arrowImageView;
    VerticalUpLabel *recipeTitleLabel;
    VerticalUpLabel *leadLabel;
    UILabel *priceLabel;
}

@property(nonatomic, retain) UIImageView *photoImageView;
@property(nonatomic, retain) UIImageView *arrowImageView;
@property(nonatomic, retain) VerticalUpLabel *recipeTitleLabel;
@property(nonatomic, retain) VerticalUpLabel *leadLabel;
@property(nonatomic, retain) UILabel *priceLabel;

@end
