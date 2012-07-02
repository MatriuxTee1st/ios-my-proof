//
//  RecipeViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeViewController.h"
#import "ImageUtil.h"
#import "MedicinalCarbOffAppDelegate.h"

@implementation RecipeViewController
@synthesize delegate;
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithRecipeNo:(int)recipeNo {
    self = [super init];
    if (self) {
        
   
        recipeEntity = [[RecipeEntity alloc] init];
        
        // レシピ情報を取得し、格納
        RecipeEntity *resultRecipeEntity = [DatabaseUtility selectRecipeDataWithRecipeNo:recipeNo];
        [recipeEntity setRecipeNo:[resultRecipeEntity recipeNo]];
        [recipeEntity setThumbnailPhotoNo:[resultRecipeEntity thumbnailPhotoNo]];
        [recipeEntity setPhotoNo:[resultRecipeEntity photoNo]];
        [recipeEntity setRecipeName:[resultRecipeEntity recipeName]];
        [recipeEntity setTime:[resultRecipeEntity time]];
        [recipeEntity setCalorie:[resultRecipeEntity calorie]];
        [recipeEntity setCommentRecipe:[resultRecipeEntity commentRecipe]];
        [recipeEntity setPerson:[resultRecipeEntity person]];
        [recipeEntity setIsFavorite:[resultRecipeEntity isFavorite]];
        [recipeEntity setCarbQty:[resultRecipeEntity carbQty]];
        
        
        // 食材、調味料、作り方を取得し、格納
        NSArray *mainIngredientArray = [DatabaseUtility selectMainIngredientArrayWithRecipeNo:recipeNo];
        [recipeEntity setMainIngredientEntityArray:[NSMutableArray arrayWithArray:mainIngredientArray]];
        NSArray *sauceAArray = [DatabaseUtility selectSauceAArrayWithRecipeNo:recipeNo];
        [recipeEntity setSauceAEntityArray:[NSMutableArray arrayWithArray:sauceAArray]];
        NSArray *sauceBArray = [DatabaseUtility selectSauceBArrayWithRecipeNo:recipeNo];
        [recipeEntity setSauceBEntityArray:[NSMutableArray arrayWithArray:sauceBArray]];
        NSArray *sauceCArray = [DatabaseUtility selectSauceCArrayWithRecipeNo:recipeNo];
        [recipeEntity setSauceCEntityArray:[NSMutableArray arrayWithArray:sauceCArray]];
        NSArray *processArray = [DatabaseUtility selectProcessArrayWithRecipeNo:recipeNo];
        [recipeEntity setProcessArray:[NSMutableArray arrayWithArray:processArray]];
        
        relationalRecipeUtil = [[RelationalRecipeUtil alloc] init];
        [relationalRecipeUtil setDelegate:self];
        
        // 関連レシピを取得し、格納
        // アプリのレシピの場合
        if (recipeNo <= kRecipeCount) {
            // recipeCellEntityの配列をDBから取得
            NSArray *recipeCellEntityArray = [DatabaseUtility selectRelationalRecipeArrayWithRecipeNo:recipeNo];
            [recipeEntity setRelationalRecipeCellEntityArray:[NSMutableArray arrayWithArray:recipeCellEntityArray]];
        }
        // 追加レシピの場合
        else {
            // recipeNoの配列をDBから取得
            NSArray *relationalRecipeNoArray = [DatabaseUtility selectRelationalRecipeNoWithRecipeNo:recipeNo];
            PrintLog(@"RelationalRecipe: %@", relationalRecipeNoArray);
            
            // フィルターを通し、追加レシピのrecipeNoだけ取得
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF > %d", kRecipeCount];
            NSArray *filteredArray = [relationalRecipeNoArray filteredArrayUsingPredicate:predicate];
            PrintLog(@"FilteredRecipe: %@", filteredArray);
            // 追加レシピが1つ以上入っているの場合
            if ([filteredArray count] > 0) {
                [relationalRecipeUtil setRecipeNoArray:relationalRecipeNoArray];
                [relationalRecipeUtil getRelationalRecipe];
            }
            // アプリのレシピしか入っていない場合
            else if ([relationalRecipeNoArray count] > 0) {
                NSArray *relationalRecipeArray = [DatabaseUtility selectRelationalRecipeArrayWithRecipeNo:recipeNo];
                [recipeEntity setRelationalRecipeCellEntityArray:[NSMutableArray arrayWithArray:relationalRecipeArray]];
            }
        }
        
        [self sendRankingDataPostRequest];
        
        
    }
    return self;
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    PrintLog(@"");
    
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setFrame:CGRectMake(0, 0, kDisplayWidth, kDisplayHeight - kTabBarHeight - kStatusBarHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self navigationBarSetting];
    
    isTopView = YES;
    
  
    // レシピ名
    UILabel *recipeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,  94, 229, 50)];
    [recipeTitleLabel setBackgroundColor:[UIColor clearColor]];
    [recipeTitleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [recipeTitleLabel setText:[recipeEntity recipeName]];
    [recipeTitleLabel setTextColor:kColorRecipeName];
    [recipeTitleLabel setNumberOfLines:2];
    [self.view addSubview:recipeTitleLabel];
    [recipeTitleLabel release];
    
    // ブックマークボタン
    bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookmarkButton setExclusiveTouch:YES];
    [bookmarkButton setFrame:CGRectMake(262, 120,  50, 60)];
    [bookmarkButton addTarget:self action:@selector(bookmarkButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookmarkButton];
    
    // タイマーボタン
    timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timerButton setExclusiveTouch:YES];
    [timerButton setFrame:CGRectMake(212, 116,  50, 60)];
    [timerButton setImage:[UIImage imageNamed:kTimerButtonImageName] forState:UIControlStateNormal];
    [timerButton setImage:[UIImage imageNamed:kTimerButtonImageName] forState:UIControlStateDisabled];
    [timerButton addTarget:self action:@selector(timerButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timerButton];
    
    // 糖質
    UIImageView *carbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 144, 25, 25)];
    [carbImageView setImage:[UIImage imageNamed:kCarbIconImageName]];
    [self.view addSubview:carbImageView];
    [carbImageView release];
    
    UILabel *carbLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 146, 66, 25)];
    [carbLabel setBackgroundColor:[UIColor clearColor]];
    [carbLabel setTextColor:kColorRecipeGreyText];
    [carbLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeEntity carbQty]]];
    [carbLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:carbLabel];
    [carbLabel release];
    
    // カロリー
    UIImageView *calorieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(79, 144, 25, 25)];
    [calorieImageView setImage:[UIImage imageNamed:kCalorieIconImageName]];
    [self.view addSubview:calorieImageView];
    [calorieImageView release];
    
    UILabel *calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 146, 66, 25)];
    [calorieLabel setBackgroundColor:[UIColor clearColor]];
    [calorieLabel setTextColor:kColorRecipeGreyText];
    [calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeEntity calorie]]];
    [calorieLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:calorieLabel];
    [calorieLabel release];

    // 調理時間
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(154, 144, 25, 25)];
    [timeImageView setImage:[UIImage imageNamed:kTimeIconImageName]];
    [self.view addSubview:timeImageView];
    [timeImageView release];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(178, 146, 66, 25)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextColor:kColorRecipeGreyText];
    [timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeEntity time]]];
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:timeLabel];
    [timeLabel release];
    
    // 水平区切り線    
    UIImageView *dotLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 172, kDisplayWidth, 1)];
    [dotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    [self.view addSubview:dotLineImageView];
    [dotLineImageView release];
    
    
    // 作り方
    howToCookTableViewController = [[HowToCookTableViewController alloc] init];
    [howToCookTableViewController setRecipeEntity:recipeEntity];
    [howToCookTableViewController setDelegate:self];
    [howToCookTableViewController.view setHidden:YES];
    [self.view addSubview:howToCookTableViewController.view];
    
    [self tabImageViewSetting];
    
    // 写真拡大時の影
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 480)];
    [backView setBackgroundColor:[UIColor blackColor]];
    [backView setAlpha:0.0f];
    [backView setHidden:YES];
    [self.view addSubview:backView];
    [backView release];
    
    // 写真の影
    photoShadowImageView = [[UIImageView alloc] init];
    [photoShadowImageView setImage:[UIImage imageNamed:kPhotoShadowImageName]];
    [photoShadowImageView setFrame:CGRectMake(36, 169, 247, 247)];
    [self.view addSubview:photoShadowImageView];
    [photoShadowImageView release];
    
    // 写真
    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setExclusiveTouch:YES];
    [photoButton setFrame:CGRectMake(57, 180, 205, 226)];
    [photoButton setTag:kPhotoScaleTagNormal];
    if (recipeEntity.recipeNo <= kRecipeCount) {
        [photoButton setImage:[UIImage imageNamed:[recipeEntity photoNo]] forState:UIControlStateNormal];
    } else {
        [photoButton setImage:[ImageUtil loadImage:[recipeEntity photoNo]] forState:UIControlStateNormal];
    }
    
    [photoButton setShowsTouchWhenHighlighted:YES];
    [photoButton addTarget:self action:@selector(photoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    photoCenter = photoButton.center;
    [self.view addSubview:photoButton];
    
    expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [expandButton setExclusiveTouch:YES];
    [expandButton setFrame:CGRectMake(220, 166, 57, 57)];
    [expandButton setTag:kPhotoScaleTagNormal];
    [expandButton setImage:[UIImage imageNamed:kExpandIconImageName] forState:UIControlStateNormal];
    [expandButton addTarget:self action:@selector(photoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self performSelector:@selector(expandButtonWillDisappear) withObject:nil afterDelay:2.5f];
    [self.view addSubview:expandButton];
}

/***************************************************************
 * 拡大ボタン消滅
 ***************************************************************/
- (void)expandButtonWillDisappear {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [expandButton setAlpha:0.0f];
                     }
     ];
}


/***************************************************************
 * 関連レシピセル選択時
 ***************************************************************/
- (void)selectedRelativeRecipeCellWithRecipeNo:(int)recipeNo {
    [self.delegate transitionRelativeRecipeWithRecipeNo:recipeNo];
}

/***************************************************************
 * 関連レシピアニメーション
 * ・関連レシピボタン押下後、delegateクラスから呼ばれる
 ***************************************************************/
- (void)startTransitionAnimation {
    [self.view setTransform:CGAffineTransformMakeScale(1.05f, 1.05f)];
    [self.view setAlpha:0.6f];
     [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view setTransform:CGAffineTransformMakeScale(1, 1)];
                         [self.view setAlpha:1.0f];
                     }
     ];
}

/***************************************************************
 * 写真ボタン押下時
 ***************************************************************/
- (void)photoButtonPushed:(UIButton *)button {
    
    
    if ([button tag] == kPhotoScaleTagNormal) {
        [backView setHidden:NO];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             photoButton.center = CGPointMake(160, 228);
                             [photoButton setTransform:CGAffineTransformMakeScale(320.0/205.0, 352.0/226.0)];
                             photoShadowImageView.center = CGPointMake(160, 228);
                             [photoShadowImageView setTransform:CGAffineTransformMakeScale(320.0/247.0, 352.0/247.0)];
                             [backView setAlpha:1.0f];
                             [expandButton setAlpha:0.0f];
                         }
         ];        
        [photoButton setTag:kPhotoScaleTagExpand];
    } else {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             photoButton.center = CGPointMake(160, photoCenter.y);
                             [photoButton setTransform:CGAffineTransformMakeScale(1, 1)];
                             photoShadowImageView.center = CGPointMake(160, photoCenter.y);
                             [photoShadowImageView setTransform:CGAffineTransformMakeScale(1, 1)];
                             [backView setAlpha:0.0f];
                         }
                         completion:^(BOOL finished){
                             [backView setHidden:YES];                             
                         }
         ];
        [photoButton setTag:kPhotoScaleTagNormal];
    }
}


/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    PrintLog(@"{");
    BOOL isFavorite = [DatabaseUtility selectIsFavoriteWithRecipeNo:[recipeEntity recipeNo]];
    
    [recipeEntity setIsFavorite:isFavorite];
    
    if ([recipeEntity isFavorite]) {
        [bookmarkButton setTag:kBookmarkButtonTagOn];
        [bookmarkButton setImage:[UIImage imageNamed:kBookmarkButtonOnImageName] forState:UIControlStateNormal];    
    } else {
        [bookmarkButton setTag:kBookmarkButtonTagOff];
        [bookmarkButton setImage:[UIImage imageNamed:kBookmarkButtonOffImageName] forState:UIControlStateNormal];
    }
    PrintLog(@"}");
}

/***************************************************************
 * 上部タブの設定
 ***************************************************************/
- (void)tabImageViewSetting {
    headerTabImageView   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kRecipeUpperTabButtonPhotoImageName]];
    [headerTabImageView setFrame:CGRectMake(0, 44, kDisplayWidth, 44)];
    [headerTabImageView setTag:kRecipeUpperTabPhoto];
    [headerTabImageView setImage:[UIImage imageNamed:kRecipeUpperTabButtonPhotoImageName]];
    [self.view addSubview:headerTabImageView];
    
    
    UIButton *upperTabPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [upperTabPhotoButton setExclusiveTouch:YES];
    [upperTabPhotoButton setFrame:CGRectMake(0, 48, 160, 44)];
    [upperTabPhotoButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [upperTabPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [upperTabPhotoButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [upperTabPhotoButton setShowsTouchWhenHighlighted:YES];
    [upperTabPhotoButton setTag:kRecipeUpperTabPhoto];
    [upperTabPhotoButton addTarget:self action:@selector(upperTabButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upperTabPhotoButton];
    
    UIButton *upperTabHowToCookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [upperTabHowToCookButton setExclusiveTouch:YES];
    [upperTabHowToCookButton setFrame:CGRectMake(160, 48, 160, 44)];
    [upperTabHowToCookButton.titleLabel setFont:[UIFont systemFontOfSize:15]];    
    [upperTabHowToCookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [upperTabHowToCookButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [upperTabHowToCookButton setShowsTouchWhenHighlighted:YES];
    [upperTabHowToCookButton setTag:kRecipeUpperTabHowToCook];
    [upperTabHowToCookButton addTarget:self action:@selector(upperTabButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upperTabHowToCookButton];
    

}

/***************************************************************
 * 上部タブボタン押下時
 ***************************************************************/
- (void)upperTabButtonPushed:(UIButton *)pushedButton {
    [howToCookTableViewController.view setHidden:YES];
    
    int tag = [pushedButton tag];
    [headerTabImageView setTag:tag];
    NSString *imageName = nil;
    if (tag == kRecipeUpperTabPhoto) {
        imageName = kRecipeUpperTabButtonPhotoImageName;
        [backView setHidden:NO];
        [photoButton setHidden:NO];
        [photoShadowImageView setHidden:NO];
        // Turn on auto sleep
        PrintLog(@"Idle Timer Enabled");
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    } else if (tag == kRecipeUpperTabHowToCook) {
        imageName = kRecipeUpperTabButtonHowToCookImageName;   
        [howToCookTableViewController.view setHidden:NO];
        [backView setHidden:YES];
        [photoButton setHidden:YES];
        [expandButton setHidden:YES];
        [photoShadowImageView setHidden:YES];
        // Turn off auto sleep
        PrintLog(@"Idle Timer Disabled");
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    [headerTabImageView setImage:[UIImage imageNamed:imageName]];
}


/***************************************************************
 * お気に入りボタン押下時
 ***************************************************************/
- (void)bookmarkButtonPushed:(UIButton *)button {
    if ([button tag] == kBookmarkButtonTagOff) {
        [button setImage:[UIImage imageNamed:kBookmarkButtonOnImageName] forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyMMddHHmmssS"];
        NSString *currentDate = [formatter stringFromDate:[NSDate date]];
        [formatter release];
        
        BOOL success = [DatabaseUtility updateFavoritesRecipeNo:[recipeEntity recipeNo] value:YES date:currentDate];
        if (!success) {
            PrintLog(@"DBの更新が失敗しました。");
        }
        
        [button setTag:kBookmarkButtonTagOn];
    } else {
        BOOL success = [DatabaseUtility updateFavoritesRecipeNo:[recipeEntity recipeNo] value:NO date:@""];
        if (!success) {
            PrintLog(@"DBの更新が失敗しました。");
        }
        
        [button setImage:[UIImage imageNamed:kBookmarkButtonOffImageName] forState:UIControlStateNormal];
        [button setTag:kBookmarkButtonTagOff];
    }
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
    [navigationBarTitleLabel setText:kNavigationBarTitleRecipeName];
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
    
    UIButton *snsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [snsButton setImage:[UIImage imageNamed:kNavigationBarShareImageName] forState:UIControlStateNormal];
    [snsButton setExclusiveTouch:YES];
    [snsButton setFrame:CGRectMake(kNavigationBarRightButtonOriginX,
                                   kNavigationBarButtonOriginY,
                                   snsButton.imageView.image.size.width + kButtonTouchBuffer,
                                   snsButton.imageView.image.size.height)];
    [snsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [snsButton addTarget:self
                  action:@selector(showSNS)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:snsButton];
    
}

/***************************************************************
 * メール送信表示
 ***************************************************************/
- (NSString *)getMailContents {
    NSMutableString *contents = [[[NSMutableString alloc] init] autorelease];
    [contents insertString:[NSString stringWithFormat:@"材料（%d人分）\n", [recipeEntity person]] atIndex:0];
    
    // Main Ingredients
    for (MainIngredientEntity *mainIngredientEntity in [recipeEntity mainIngredientEntityArray]) {
        NSString *ingredientItem = [NSString stringWithFormat:@"%@  %@", [mainIngredientEntity mainIngredientName], [mainIngredientEntity mainIngredientQty]];
        [contents appendFormat:@"・%@\n", ingredientItem];
    }
    
    // Sauce A
    if ([[recipeEntity sauceAEntityArray] count] > 0) {
        NSString *sauceTitle = [NSString stringWithFormat:@"【調味料A】"];
        [contents appendFormat:@"%@\n", sauceTitle];
        for (SauceEntity *sauceEntity in [recipeEntity sauceAEntityArray]) { 
            NSString *sauce = [NSString stringWithFormat:@"%@  %@", [sauceEntity sauceName], [sauceEntity sauceQty]];
            [contents appendFormat:@"・%@\n", sauce];
        }
    }
    
    // Sauce B
    if ([[recipeEntity sauceBEntityArray] count] > 0) {
        NSString *sauceTitle = [NSString stringWithFormat:@"【調味料B】"];
        [contents appendFormat:@"%@\n", sauceTitle];
        for (SauceEntity *sauceEntity in [recipeEntity sauceBEntityArray]) { 
            NSString *sauce = [NSString stringWithFormat:@"%@  %@", [sauceEntity sauceName], [sauceEntity sauceQty]];
            [contents appendFormat:@"・%@\n", sauce];
        }
    }
    
    // Sauce C
    if ([[recipeEntity sauceCEntityArray] count] > 0) {
        NSString *sauceTitle = [NSString stringWithFormat:@"【調味料C】"];
        [contents appendFormat:@"%@\n", sauceTitle];
        for (SauceEntity *sauceEntity in [recipeEntity sauceCEntityArray]) { 
            NSString *sauce = [NSString stringWithFormat:@"%@  %@", [sauceEntity sauceName], [sauceEntity sauceQty]];
            [contents appendFormat:@"・%@\n", sauce];
        }
    }
    
    return contents;
}

/***************************************************************
 * SNS機能の表示
 ***************************************************************/
- (void)showSNS {
    // Turn on auto sleep
    PrintLog(@"Idle Timer Enabled");
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if (!newService) {
        newService = [[SNSService alloc] init];
    }
    [newService setDelegate:self];
    [newService setRecipeName:[recipeEntity recipeName]];
    [newService setRecipeContents:[self getMailContents]];
    [newService doSNS];
}

/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************
 * 関連レシピを設定
 ***************************************************************/
- (void)setRelationalRecipe:(NSMutableArray *)cellEntityArray {
    // １つ以上入っている場合
    if (cellEntityArray) {
        NSArray *relationalRecipeNoArray = [DatabaseUtility selectRelationalRecipeNoWithRecipeNo:[recipeEntity recipeNo]];
        // アプリ内のレシピを追加
        for (NSNumber *recipeNo in relationalRecipeNoArray) {
            if ([recipeNo intValue] <= kRecipeCount) {
                RecipeCellEntity *recipeCellEntity = [DatabaseUtility selectRecipeCellWithRecipeNo:[recipeNo intValue]];
                [cellEntityArray addObject:recipeCellEntity];
            }
        }
        [recipeEntity setRelationalRecipeCellEntityArray:cellEntityArray];
        [howToCookTableViewController setRecipeEntity:recipeEntity];
        [howToCookTableViewController setupRelationalRecipeTable];
    }
    // １つも入っていない場合
    else {
        // 配列を初期化
        NSMutableArray *insertRecipeCellEntityArray = [[NSMutableArray alloc] init];
        NSArray *relationalRecipeNoArray = [DatabaseUtility selectRelationalRecipeNoWithRecipeNo:[recipeEntity recipeNo]];
        // アプリ内のレシピを追加
        for (NSNumber *recipeNo in relationalRecipeNoArray) {
            if ([recipeNo intValue] <= kRecipeCount) {
                RecipeCellEntity *recipeCellEntity = [DatabaseUtility selectRecipeCellWithRecipeNo:[recipeNo intValue]];
                [insertRecipeCellEntityArray addObject:recipeCellEntity];
            }
        }
        
        // １つ以上入っている場合
        if ([insertRecipeCellEntityArray count] > 0) {
            [recipeEntity setRelationalRecipeCellEntityArray:insertRecipeCellEntityArray];
            [howToCookTableViewController setRecipeEntity:recipeEntity];
            [howToCookTableViewController setupRelationalRecipeTable];
        }
        
        // 配列を解放
        [insertRecipeCellEntityArray release];
    }
}

/***************************************************************
 * ランキング用データ送信
 ***************************************************************/
- (void)sendRankingDataPostRequest {
    
    /*
     * 端末に保存していた閲覧データ配列を読み込み
     */
    NSData *savedRankingArrayData = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:@"RankingArrayData"];
    rankingRequestEntityArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:savedRankingArrayData]];

    PrintLog(@"array count = %d", [rankingRequestEntityArray count]);
    
    RankingRequestEntity *rankingRequestEntity = [[RankingRequestEntity alloc] init];
    [rankingRequestEntity setRecipeNo:[recipeEntity recipeNo]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [rankingRequestEntity setViewDate:dateString];
    [rankingRequestEntityArray addObject:rankingRequestEntity];
    [rankingRequestEntity release];
    [dateFormatter release];
    
    for (RankingRequestEntity *entity in rankingRequestEntityArray) {
        PrintLog(@"recipe_no = %d", [entity recipeNo]);
    }
    
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rankingRequestEntityArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"RankingArrayData"];
 
    } else {
        
        NSMutableString *dataArrayMutableString = [[NSMutableString alloc] init];
        for (RankingRequestEntity *entity in rankingRequestEntityArray) {
            [dataArrayMutableString appendFormat:@"{\"recipe_no\":%d,\"view_date\":\"%@\"},", [entity recipeNo], [entity viewDate]];
        }
        // 最後尾のカンマを取り除く
        NSString *dataArrayString = [dataArrayMutableString substringToIndex:[dataArrayMutableString length]-1];
        [dataArrayMutableString release];
        
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerAddHistory];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *requestData 
        = [[NSString stringWithFormat:@"%@&data=[%@]", kRankingServerPassword, dataArrayString] 
           dataUsingEncoding:NSUTF8StringEncoding];
        
                                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        PrintLog(@"%@", [[[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding] autorelease]);        
    }
}


/***************************************************************
 * 通信開始時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    receivedData = [[NSMutableData alloc] init];
    PrintLog(@"通信開始");
}


/***************************************************************
 * データ受信時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}


/***************************************************************
 * 通信完了
 ***************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    PrintLog(@"通信完了");
    PrintLog(@"%@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RankingArrayData"];
}

/***************************************************************
 * 通信エラー
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"");    
}

/***************************************************************
 * ビュー表示後
 ***************************************************************/
-(void)viewDidAppear:(BOOL)animated {
    // Turn off auto sleep
    if (!howToCookTableViewController.view.isHidden && isTopView) {
        PrintLog(@"Idle Timer Disabled");
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

/***************************************************************
 * スリープ機能の切り替え
 ***************************************************************/
- (void)setAutoSleepMode {
    // Turn off auto sleep
    if (!howToCookTableViewController.view.isHidden) {
        PrintLog(@"Idle Timer Disabled");
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } 
    // Turn on auto sleep
    else {
        PrintLog(@"Idle Timer Enabled");
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

- (void)changeIsTopView:(BOOL)isTopView_ {
    isTopView = isTopView_;
}

/***************************************************************
 * タイマーボタン押下時
 ***************************************************************/
- (void)timerButtonPushed:(UIButton *)button {
    [timerButton setEnabled:NO];
    TimerViewController *timerViewController= [TimerViewController sharedTimerViewController];
    [timerViewController setDelegate:self];
    [self.view addSubview:timerViewController.view];
    [timerViewController addTimerSelectionView];
}

/***************************************************************
 * タイマーボタンを押下可能にする
 ***************************************************************/
- (void)enableTimerButton {
    [timerButton setEnabled:YES];
}

/***************************************************************
 * ビュー非表示前
 ***************************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    // Turn on auto sleep
    PrintLog(@"Idle Timer Enabled");
    TimerViewController *timerViewController = [TimerViewController sharedTimerViewController];
    if ([timerViewController isVisible]) {
        [self enableTimerButton];
        [timerViewController removeFromSuperviewInBackground];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
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
    if (relationalRecipeUtil) {
        [relationalRecipeUtil cancelRequest];
        [relationalRecipeUtil release], relationalRecipeUtil = nil;
    }
    
    if (newService) {
        [newService release], newService = nil;
    }
    [rankingRequestEntityArray release];
    [howToCookTableViewController release];

    [recipeEntity release];
    [delegate release];
    
    [super dealloc];
    PrintLog(@"}");
    
}

@end
