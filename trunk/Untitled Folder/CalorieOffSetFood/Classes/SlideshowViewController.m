//
//  SlideshowViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/19.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlideshowViewController.h"
#import "ImageUtil.h"

static CGFloat imageWidth = 320.f;

@implementation SlideshowViewController

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [self stopTimer];
    [recipeInfo release], recipeInfo = nil;
    [randomRecipeIndexes release], randomRecipeIndexes = nil;
    [super dealloc];
}

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    PrintLog(@"");
    self = [super init];
    if (self) {
        [self startTimer];
        recipeInfo = [[NSArray alloc] initWithArray:[DatabaseUtility selectAllRecipeData]];
        recipeCount = [recipeInfo count];
        randomRecipeIndexes = [[NSMutableArray alloc] init];
        [self createRandomIndexes];
    }
    return self;
}

/***************************************************************
 * ビュー読み込み時
 ***************************************************************/
- (void)loadView {
    [super loadView];
    self.view = [[[UIView alloc] init] autorelease];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    [self navigationBarSetting];
    
    // スライド画像の一枚目
    if ([randomRecipeIndexes count] == 0) {
        [self createRandomIndexes];
    }
    recipeIndex = [[randomRecipeIndexes objectAtIndex:0] intValue];
    [randomRecipeIndexes removeObjectAtIndex:0];
    
    // 最初に出てくる画像の設定
    UIImage *firstImage = nil;
    if (recipeIndex <= kRecipeCount) {
        firstImage = [UIImage imageNamed:[[recipeInfo objectAtIndex:recipeIndex] photoNo]];
    } else {
        firstImage = [ImageUtil loadImage:[[recipeInfo objectAtIndex:recipeIndex] photoNo]];
    }
    slideImageButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideImageButton1 setExclusiveTouch:YES];
    [slideImageButton1 setFrame:CGRectMake(0, 6.0f + kNavigationBarHeight, imageWidth, imageWidth * 1.1)];
    [slideImageButton1 setBackgroundImage:firstImage forState:UIControlStateNormal];
    [slideImageButton1 setBackgroundImage:firstImage forState:UIControlStateHighlighted];
    [slideImageButton1 setTag:0];
    [slideImageButton1 addTarget:self
                          action:@selector(goToRecipe:)
                forControlEvents:UIControlEventTouchUpInside];
    [slideImageButton1 setAlpha:1.0f];
    [[self view] addSubview:slideImageButton1];

    // スライド画像の二枚目
    slideImageButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideImageButton2 setExclusiveTouch:YES];
    [slideImageButton2 setFrame:CGRectMake(0, 6.0f + kNavigationBarHeight, imageWidth, imageWidth * 1.1)];
    [slideImageButton2 addTarget:self
                          action:@selector(goToRecipe:)
                forControlEvents:UIControlEventTouchUpInside];
    [slideImageButton2 setAlpha:0.0f];
    [[self view] addSubview:slideImageButton2];

}

/***************************************************************
 * ビュー表示後
 ***************************************************************/
- (void)viewDidAppear:(BOOL)animated {
    // Turn of auto sleep
    PrintLog(@"Idle Timer Disabled");
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self startTimer];
}

/***************************************************************
 * ビュー非表示後
 ***************************************************************/
- (void)viewDidDisappear:(BOOL)animated {
    // Turn on auto sleep
    PrintLog(@"Idle Timer Enabled");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self stopTimer];
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
    
    // ナビゲーションバーのタイトルの設定
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kNavigationBarTitleSlideshowName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
    
    // ナビゲーションバーの戻るボタンの設定
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:kBackButtonImageName] forState:UIControlStateNormal];
    [backButton setExclusiveTouch:YES];
    [backButton setFrame:CGRectMake(kNavigationBarLeftButtonOriginX,
                                    kNavigationBarButtonOriginY,
                                    backButton.imageView.image.size.width + kButtonTouchBuffer,
                                    backButton.imageView.image.size.height)];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}  

/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

/***************************************************************
 * スライド遷移
 ***************************************************************/
- (void)nextSlide {
    if ([randomRecipeIndexes count] == 0) {
        [self createRandomIndexes];
    }
    
    recipeIndex = [[randomRecipeIndexes objectAtIndex:0] intValue];
    [randomRecipeIndexes removeObjectAtIndex:0];
    
    UIImage *nextImage = nil;
    NSString *photoNoPrefix = [[[recipeInfo objectAtIndex:recipeIndex] photoNo] substringToIndex:7];
    if (![photoNoPrefix isEqualToString:@"photoNo"]) {
        nextImage = [UIImage imageNamed:[[recipeInfo objectAtIndex:recipeIndex] photoNo]];
    } else {
        nextImage = [ImageUtil loadImage:[[recipeInfo objectAtIndex:recipeIndex] photoNo]];
    }

    [UIView transitionWithView:[self view]
                      duration:1.0
                       options:UIViewAnimationOptionTransitionNone
                    animations:^{
                        if (slideImageButton1.alpha == 1.f) {
                            //Fade out image1.
                            [slideImageButton1 setAlpha:0.f];
//                            [recipeNameLabel1 setAlpha:0.f];
                            
                            //Fade in image2 with next image.
                            [slideImageButton2 setBackgroundImage:nextImage forState:UIControlStateNormal];
                            [slideImageButton2 setBackgroundImage:nextImage forState:UIControlStateHighlighted];
                            [slideImageButton2 setAlpha:1.f];
//                            [recipeNameLabel2 setText:[[recipeInfo objectAtIndex:recipeIndex] recipeName]];
//                            [recipeNameLabel2 setAlpha:1.f];
                        } else {
                            //Fade in image1 with next image.
                            [slideImageButton1 setBackgroundImage:nextImage forState:UIControlStateNormal];
                            [slideImageButton1 setBackgroundImage:nextImage forState:UIControlStateHighlighted];
                            [slideImageButton1 setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
                            [slideImageButton1 setAlpha:1.f];
//                            [recipeNameLabel1 setText:[[recipeInfo objectAtIndex:recipeIndex] recipeName]];
//                            [recipeNameLabel1 setAlpha:1.f];
                            
                            //Fade out image2.
                            [slideImageButton2 setAlpha:0.f];
//                            [recipeNameLabel2 setAlpha:0.f];
                        }
                    }
                    completion:nil];    
}

/***************************************************************
 * randomRecipeIndexのオブジェクトの入れ替え
 ***************************************************************/
- (void)swapObjectAtIndex:(int)n withIndex:(int)i {
    NSNumber *tmpNumber = [randomRecipeIndexes objectAtIndex:i];
    [randomRecipeIndexes replaceObjectAtIndex:i withObject:[randomRecipeIndexes objectAtIndex:n]];
    [randomRecipeIndexes replaceObjectAtIndex:n withObject:tmpNumber];
}

/***************************************************************
 * インデクスをランダムに作成
 ***************************************************************/
- (void)createRandomIndexes {
    for (int i = 0; i < recipeCount; i++) {
        [randomRecipeIndexes insertObject:[NSNumber numberWithInt:i] atIndex:i];
    }
    
    for (int i = 0; i < recipeCount; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = recipeCount - i;
        int n = (arc4random() % nElements) + i;
        [self swapObjectAtIndex:n withIndex:i];
    }
    
    // Change the first element if it is the same as the last element from the last loop
    if ([[randomRecipeIndexes objectAtIndex:0] intValue] == recipeIndex) {
        [self swapObjectAtIndex:0 withIndex:recipeCount / 2];
    }
}

/***************************************************************
 * 画像ボタン押下
 ***************************************************************/
- (void)goToRecipe:(id)sender {
    NSInteger recipeNo = [[recipeInfo objectAtIndex:recipeIndex] recipeNo];
    RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:recipeNo];
    [recipeViewController setDelegate:self];
    [self.navigationController pushViewController:recipeViewController animated:YES];
    [recipeViewController release];
}

/***************************************************************
 * タイマーの初期化
 ***************************************************************/
- (void)startTimer {
    if(!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                 target:self
                                               selector:@selector(nextSlide)
                                               userInfo:nil
                                                repeats:YES];
    }
}

/***************************************************************
 * タイマーの中止
 ***************************************************************/
- (void)stopTimer {
    [timer invalidate], timer = nil;
}

@end
