//
//  FoodDictionaryDetailViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/21.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeCell.h"
#import "RecipeEntity.h"
#import "DatabaseUtility.h"
#import "RecipeViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface FoodDictionaryDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIView *backgroundView_;
    UIScrollView *scrollView_;
    NSArray *foodDictionaryArray;
    NSInteger currentRow;
    NSInteger currentSection;
    NSInteger maxRow;
    NSInteger maxSection;
    NSInteger relatedRecipeCount;
    CGSize descriptionLabelSize;
    
    UIButton *nextIngredientButton;
    UIButton *previousIngredientButton;
    
    UILabel *navigationBarTitleLabel;
}

@property (nonatomic, retain) NSArray *foodDictionaryArray;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) NSInteger currentSection;

- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;
- (void)navigationBarSetting;
- (UIScrollView *)setScrollViewContents;

@end
