//
//  PhotoGridViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/19.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "PhotoGridViewController.h"
#import "ImageUtil.h"

@interface PhotoGridViewController ()

- (void)setupGridView:(BOOL)animated;

@end

@implementation PhotoGridViewController
@synthesize delegate;
@synthesize recipeArray;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {//WithRecipeArray:(NSMutableArray *)array {
    self = [super init];
    if (self) {
//        [self setRecipeArray:array];
    }
    return self;
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    PrintLog(@"{");
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setFrame:CGRectMake(0, 44, 320, 368)];

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 368)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    PrintLog(@"}");
}

- (void)setupGridView:(BOOL)animated {
    [scrollView setContentSize:CGSizeMake(320, 5+115*(int)(([recipeArray count] + 2)/3))];
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 368) animated:NO];
    
    int x = 0;
    int y = 0;
    for (RecipeEntity *recipeEntity in recipeArray) {
        NSString *fileName = [recipeEntity thumbnailPhotoNo];
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoButton setTag:[recipeEntity recipeNo]];
        if (recipeEntity.recipeNo <= kRecipeCount) {
            [photoButton setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
        } else {
            [photoButton setImage:[ImageUtil loadImage:fileName] forState:UIControlStateNormal];
        }
        
        [photoButton setFrame:CGRectMake(160, 50+37*(x+y*3), 1, 1)];
        [photoButton setAlpha:0.0f];
        [photoButton addTarget:self action:@selector(photoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (recipeEntity.recipeNo > kRecipeCount) {
            NSDate *recipeDate = [DatabaseUtility selectDownloadDate:recipeEntity.recipeNo];
            
            // 1週間以内に購入した場合
            if ([[NSDate date] timeIntervalSinceDate:recipeDate] < 60 * 60 * 24 * 7) {
                UIImageView *addonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 29.f, 29.f)];
                [addonImageView setImage:[UIImage imageNamed:kStoreNewBadgeImageName]];
                [addonImageView setUserInteractionEnabled:NO];
                [photoButton addSubview:addonImageView];
                [addonImageView release];
            }
        }
        
        if (animated) {
            [UIView animateWithDuration:0.35f
                                  delay:0.7+(x+y*3)/20.0f
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 [photoButton setFrame:CGRectMake(5+105*x, 5+115*y, 100, 110)];
                                 [photoButton setAlpha:1.0f];
                             }
                             completion:^(BOOL finished){
                             }
             ];
        } else {
            [photoButton setFrame:CGRectMake(5+105*x, 5+115*y, 100, 110)];
            [photoButton setAlpha:1.0f];
        }
        
        /*
         [UIView animateWithDuration:0.35f
         delay:0.7+(x+y*3)/20.0f
         options:UIViewAnimationCurveLinear
         animations:^{
         photoButton.center = CGPointMake(5+50+105*x, 5+55+115*y);
         [photoButton setTransform:CGAffineTransformMakeScale(100, 110)];
         [photoButton setAlpha:1.0f];
         }
         completion:^(BOOL finished){
         }
         ];
         */
        
        [scrollView addSubview:photoButton];
        
        x++;
        if (x==3) {
            y++;
            x=0;
        }
        
    }
}

#pragma mark -
#pragma mark View lifecycle
/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    for (UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    [self setupGridView:animated];
}
/***************************************************************
 * ビュー表示後
 ***************************************************************/
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
}
/***************************************************************
 * ビュー非表示前
 ***************************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
/***************************************************************
 * ビュー非表示後
 ***************************************************************/
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];  
}

/***************************************************************
 * 写真ボタン押下時
 ***************************************************************/
- (void)photoButtonPushed:(UIButton *)button {
    PrintLog(@"button tag = %d", [button tag]);
    [self.delegate transitionToRecipeViewWithRecipeNo:[button tag]];

}

/***************************************************************
 * メモリ警告時
 ***************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

/***************************************************************
 * メモリ警告後
 ***************************************************************/
- (void)viewDidUnload {
    [super viewDidUnload];
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    PrintLog(@"");
    [recipeArray release], recipeArray = nil;
    [delegate release];
    [super dealloc];
}

@end
