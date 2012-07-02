//
//  PhotoSearchViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "PhotoSearchViewController.h"


@implementation PhotoSearchViewController

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    self = [super init];
    if (self) {
        recipeDataArray = [[DatabaseUtility selectAllRecipeData] retain];
    }
    return self;
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navigationBarSetting];
    
    isGridAnimated = YES;

    photoGridViewController = [[PhotoGridViewController alloc] init];
    [photoGridViewController setDelegate:self];
    [self.view addSubview:photoGridViewController.view];
    
    photoListTableViewController = [[PhotoListTableViewController alloc] init];
    [photoListTableViewController setDelegate:self];
    [self.view addSubview:photoListTableViewController.view];
}


/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [recipeDataArray release], recipeDataArray = nil;
    recipeDataArray = [[DatabaseUtility selectAllRecipeData] retain];
    
    [photoGridViewController setRecipeArray:recipeDataArray];
    [photoListTableViewController setRecipeArray:recipeDataArray];
    
    [photoGridViewController viewWillAppear:isGridAnimated];
    [photoListTableViewController viewWillAppear:YES];
    isGridAnimated = NO;
}

/***************************************************************
 * レシピ画面へ遷移
 ***************************************************************/
- (void)transitionToRecipeViewWithRecipeNo:(int)recipeNo {
    RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:recipeNo];
    [recipeViewController setDelegate:self];
    [self.navigationController pushViewController:recipeViewController animated:YES];
    [recipeViewController release];
}

/***************************************************************
 * 関連レシピ遷移要求を受けた時
 * ・元あった個別レシピ画面をpopする
 * ・新しい関連レシピの個別レシピ画面をpushする
 ***************************************************************/
- (void)transitionRelativeRecipeWithRecipeNo:(int)recipeNo {
    
    [self.navigationController popViewControllerAnimated:NO];
    
    RecipeViewController *relativePage = [[RecipeViewController alloc] initWithRecipeNo:recipeNo];
    [relativePage setDelegate:self];
    [self.navigationController pushViewController:relativePage animated:NO];
    [relativePage startTransitionAnimation];
    [relativePage release];    
}

/***************************************************************
 * ナビゲーションバーの設定
 ***************************************************************/
- (void)navigationBarSetting {
    // ナビゲーションバーの設定
    UIImage *navigationBarImage = [UIImage imageNamed:kNavigationBarImageName];
    UIImageView *navigationBarImageView = [[UIImageView alloc] initWithImage:navigationBarImage];
    navigationBarImageView.frame = kNavigationBarFrame;
    [self.view addSubview:navigationBarImageView];
    [navigationBarImageView release];
    
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kNavigationBarTitleShashinName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
    
    // ナビゲーションバーの戻るボタンの設定
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:kBackButtonImageName] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(kNavigationBarLeftButtonOriginX,
                                    kNavigationBarButtonOriginY,
                                    backButton.imageView.image.size.width + kButtonTouchBuffer,
                                    backButton.imageView.image.size.height)];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];    
    
    // ナビゲーションバーの切り替えボタンの設定
    changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setTag:kChangeButtonTagToList];
    [changeButton setImage:[UIImage imageNamed:kNavigationBarSwitchImageName] forState:UIControlStateNormal];
    [changeButton setFrame:CGRectMake(kNavigationBarRightButtonOriginX,
                                      kNavigationBarButtonOriginY,
                                      changeButton.imageView.image.size.width + kButtonTouchBuffer,
                                      changeButton.imageView.image.size.height)];
    [changeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [changeButton addTarget:self action:@selector(changeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];    
}  

/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************
 * 切り替えボタン押下
 ***************************************************************/
- (void)changeButtonPushed:(UIButton *)button {
    int tag = [button tag];
    [photoListTableViewController.view setHidden:NO];
    
    CGFloat listCenterY = 228.f;
    CGFloat gridCenterY = 228.f;
    
    [photoListTableViewController.view setCenter:CGPointMake(photoListTableViewController.view.center.x, listCenterY)];
    
    if (tag == kChangeButtonTagToList) {
        [changeButton setImage:[UIImage imageNamed:kNavigationBarSwitch2ImageName] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.35f
                         animations:^{
                             [photoGridViewController.view setCenter:CGPointMake(-160, gridCenterY)];
                             [photoListTableViewController.view setCenter:CGPointMake(160, listCenterY)];
                         }
                         completion:^(BOOL finished) {
                         }];
        [button setTag:kChangeButtonTagToGrid];
    } else if (tag == kChangeButtonTagToGrid) {
        [changeButton setImage:[UIImage imageNamed:kNavigationBarSwitchImageName] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.35f
                         animations:^{
                             [photoGridViewController.view setCenter:CGPointMake(160, gridCenterY)];
                             [photoListTableViewController.view setCenter:CGPointMake(320 + 160, listCenterY)];
                         }
                         completion:^(BOOL fihished) {
                             [photoListTableViewController.view setCenter:CGPointMake(photoListTableViewController.view.center.x, listCenterY + 480)];
                         }];
        [button setTag:kChangeButtonTagToList];
    }
    
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
    [recipeDataArray release];
    [photoGridViewController release];
    [photoListTableViewController release];
    [super dealloc];
}


@end
