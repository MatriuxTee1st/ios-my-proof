//
//  SlideshowViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/19.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseUtility.h"
#import "RecipeEntity.h"
#import "RecipeViewController.h"
#import "Utility.h"

@interface SlideshowViewController : UIViewController {
    NSTimer *timer;
//    UILabel *recipeNameLabel1;
//    UILabel *recipeNameLabel2;
    UIButton *slideImageButton1;
    UIButton *slideImageButton2;
    
    NSArray *recipeInfo;
    NSInteger recipeIndex;
    NSInteger recipeCount;
    NSMutableArray *randomRecipeIndexes;
}

- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo;
- (void)navigationBarSetting;
- (void)startTimer;
- (void)stopTimer;
- (void)createRandomIndexes;

@end
