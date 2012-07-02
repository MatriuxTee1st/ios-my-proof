//
//  RecipeStoreDetailViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RecipeStoreDetailViewController.h"
#import "VerticalUpLabel.h"
#import "DatabaseUtility.h"
#import "SauceInsertEntity.h"
#import "Utility.h"
#import "ImageUtil.h"
#import "JSON.h"
#import "NSData+Base64.h"
#import "MedicinalCarbOffAppDelegate.h"

static NSString *recipeImageKey = @"recipeImage";
static CGFloat imageScrollViewHeight = 264;
static CGFloat imageBuffer = 42.f;

typedef enum {
    alertTypeNotConnectITunesStore = 0,
    alertTypeNoPayment,
    alertTypeFailInAppPurchase,
    alertTypeNotProductID,
    alertTypeFinished,
}alertType;

@interface RecipeStoreDetailViewController ()

- (void)setupPreviewImages;
- (void)indicatorAppearAnimation:(CGPoint)center withDownloadWaitingView:(BOOL)show;
- (void)indicatorDisappearAnimation;
- (void)setupView;
- (void)showWaitingLabelWithText:(NSString *)text;

@end

@implementation RecipeStoreDetailViewController

@synthesize recipeTableEntity;
@synthesize productImage;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithProductId:(NSInteger)newProductId {
    self = [super init];
    if (self) {
        productId = newProductId;
        recipeImageDictionary = [[NSMutableDictionary alloc] init];
        recipeImageUtil = [[RecipeImageUtil alloc] init];
        [recipeImageUtil setDelegate:self];
        productDetailUtil = [[ProductDetailUtil alloc] init];
        [productDetailUtil setDelegate:self];
        productRecipeUtil = [[ProductRecipeUtil alloc] init];
        [productRecipeUtil setDelegate:self];
        recipePreviewUtil = [[RecipePreviewUtil alloc] init];
        [recipePreviewUtil setDelegate:self];
        imageNoArray = nil;
        previewImageNoArray = [[NSMutableArray alloc] init];
        recipeCounter = 0;
    }
    return self;
}

#pragma mark - View lifecycle

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES];
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navigationBarSetting];
    
    ranSetupView = NO;
    isPurchasing = NO;
    isPurchaseRequest = NO;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, 368)];
    [self.view addSubview:mainScrollView];
    [mainScrollView release];
    
    // インジケータ設定
    downloadWaitingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [downloadWaitingView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3f]];
    [downloadWaitingView setHidden:YES];
    [self.tabBarController.view addSubview:downloadWaitingView];
    [downloadWaitingView release];
    
    downloadWaitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 220, 140, 30)];
    [downloadWaitingLabel setBackgroundColor:[UIColor blackColor]];
    [downloadWaitingLabel setAlpha:0.5f];
    [downloadWaitingLabel.layer setCornerRadius:10.0f];
    [downloadWaitingLabel setTextColor:[UIColor colorWithWhite:.9f alpha:0.9f]];
    [downloadWaitingLabel setTextAlignment:UITextAlignmentCenter];
    [downloadWaitingLabel setHidden:YES];
    [self.view addSubview:downloadWaitingLabel];
    [downloadWaitingLabel release];
    
    indicatorBackView = [[UIView alloc] initWithFrame:CGRectMake(130, 145, 60, 60)];
    [indicatorBackView setBackgroundColor:[UIColor blackColor]];
    [indicatorBackView setAlpha:0.5f];
    indicatorBackView.layer.cornerRadius = 10.0f;
    [indicatorBackView setHidden:YES];
    [self.view addSubview:indicatorBackView];
    [indicatorBackView release];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 150, 50, 50)];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView release];
}

/***************************************************************
 * レシピ画像の設定
 ***************************************************************/
- (void)setupView {
    if (!ranSetupView) {
        ranSetupView = YES;
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 76, 76)];
        [thumbnailImageView setImage:[recipeTableEntity productImage]];
        [mainScrollView addSubview:thumbnailImageView];
        [thumbnailImageView release];
        [productImage release], productImage = nil;
        
        VerticalUpLabel *recipeTitleLabel = [[VerticalUpLabel alloc] initWithFrame:CGRectMake(88, 10, 210, 40)];
        [recipeTitleLabel setBackgroundColor:[UIColor clearColor]];
        [recipeTitleLabel setTextColor:[UIColor colorWithRed:0.275f green:0.208f blue:0.047f alpha:1.0f]];
        [recipeTitleLabel setFont:[UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize]];
        [recipeTitleLabel setNumberOfLines:2];
        [recipeTitleLabel setText:[NSString stringWithFormat:@"%@", [recipeTableEntity productName]]];
        [recipeTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [mainScrollView addSubview:recipeTitleLabel];
        [recipeTitleLabel release];
        
        // Check if product id exists.
        productExists = NO;
        purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *priceString = [NSString stringWithFormat:@"¥%d", [recipeTableEntity price]];
        if ([DatabaseUtility checkProductExists:recipeTableEntity.productId]) {
            productExists = YES;
            [purchaseButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
            priceString = [NSString stringWithFormat:@"購入済み"];
        }
        
        [purchaseButton setFrame:CGRectMake(296 - 80, 50, 80, 40)];
        [purchaseButton setTitle:priceString forState:UIControlStateNormal];
        [purchaseButton setTitleColor:[UIColor colorWithWhite:.6 alpha:.6] forState:UIControlStateDisabled];
        [purchaseButton setBackgroundColor:[UIColor clearColor]];
        [purchaseButton setBackgroundImage:[UIImage imageNamed:kStorePriceButtonImageName] forState:UIControlStateNormal];
        [purchaseButton setBackgroundImage:[UIImage imageNamed:kStoreAlreadyPurchasedButtonImageName] forState:UIControlStateDisabled];
        [purchaseButton setEnabled:NO];
        [purchaseButton addTarget:self action:@selector(purchaseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mainScrollView addSubview:purchaseButton];
        
        NSString *leadString = [NSString stringWithFormat:@"%@", [recipeTableEntity productLeadDetail]];
        CGSize leadSize = [leadString sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(300, 3000)];
        UILabel *leadLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDisplayWidth - leadSize.width) / 2, 96, leadSize.width, leadSize.height)];
        [leadLabel setBackgroundColor:[UIColor clearColor]];
        [leadLabel setFont:[UIFont systemFontOfSize:16]];
        [leadLabel setLineBreakMode:UILineBreakModeWordWrap];
        [leadLabel setNumberOfLines:0];
        [leadLabel setText:leadString];
        [mainScrollView addSubview:leadLabel];
        [leadLabel release];
        
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, leadLabel.frame.origin.y + leadSize.height + imageBuffer, kDisplayWidth - 60, imageScrollViewHeight)];
        [imageScrollView setContentSize:CGSizeMake(kDisplayWidth - 60, imageScrollViewHeight)];
        [imageScrollView setDelegate:self];
        [imageScrollView setShowsHorizontalScrollIndicator:NO];
        [imageScrollView setShowsVerticalScrollIndicator:NO];
        [imageScrollView setPagingEnabled:YES];
        [imageScrollView setClipsToBounds:NO];
        [mainScrollView addSubview:imageScrollView];
        [imageScrollView release];
        
        pageBackView = [[UIView alloc] init];
        [pageBackView setBackgroundColor:[UIColor blackColor]];
        [pageBackView setAlpha:0.5f];
        [pageBackView.layer setCornerRadius:5.0f];
        [pageBackView setHidden:YES];
        [mainScrollView addSubview:pageBackView];
        [pageBackView release];
        
        page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, imageScrollView.frame.origin.y + imageScrollViewHeight + 20, 320, 20)];
        [page setNumberOfPages:1];
        [page setHidesForSinglePage:YES];
        [page setUserInteractionEnabled:NO];
        [page setCurrentPage:0];
        [mainScrollView addSubview:page];
        [page release];
        
        CGSize pageSize = [page sizeForNumberOfPages:page.numberOfPages];
        [pageBackView setFrame:CGRectMake(-5 + (kDisplayWidth - pageSize.width) / 2, page.frame.origin.y, pageSize.width + 10, 20)];
        
        [mainScrollView setContentSize:CGSizeMake(kDisplayWidth, page.frame.origin.y + page.frame.size.height + imageBuffer - 20)];
        
        imageNoArray = [[NSMutableArray alloc] initWithArray:recipeTableEntity.recipeNoArray];
        
        isPreview = YES;
    }
    
    if (isPreview || productExists) {
        [self setupPreviewImages];
    } else {
        [self getImageFinishedWithImage:nil imageNo:0];
    }
}

/***************************************************************
 * プレビュー画像を取得
 ***************************************************************/
- (void)setupPreviewImages {
    recipePreviewCounter = 0;
    
    [previewImageNoArray removeAllObjects];
    
    for (int i = 1; i <= recipeTableEntity.previewCount; i++) {
        [previewImageNoArray addObject:[NSNumber numberWithInt:i]];
    }
    
    if ([previewImageNoArray count] > 0) {
        [recipePreviewUtil getImage:recipeTableEntity.productId photoNo:[[previewImageNoArray objectAtIndex:0] intValue]];
    } else {
        isPreview = NO;
        [self indicatorDisappearAnimation];
        [purchaseButton setEnabled:!productExists];
    }
}

/***************************************************************
 * インジケータ表示アニメーション
 ***************************************************************/
- (void)indicatorAppearAnimation:(CGPoint)center withDownloadWaitingView:(BOOL)show {
    canFinishIndicatorView = NO;
    if (![indicatorView isAnimating]) {
        CATransition *fadeTransition1 = [CATransition animation];
        [fadeTransition1 setType:kCATransitionFade];
        [fadeTransition1 setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [downloadWaitingView.layer addAnimation:fadeTransition1 forKey:nil];
        
        
        CATransition *fadeTransition2 = [CATransition animation];
        [fadeTransition2 setType:kCATransitionFade];
        [fadeTransition2 setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
        [indicatorBackView.layer addAnimation:fadeTransition2 forKey:nil];
    }
    [downloadWaitingView setHidden:!show];
    [indicatorBackView setHidden:NO];
    
    [indicatorView startAnimating];
}

/***************************************************************
 * インジケータ非表示アニメーション
 ***************************************************************/
- (void)indicatorDisappearAnimation {
    canFinishIndicatorView = YES;
    CATransition *fadeTransition = [CATransition animation];
    [fadeTransition setType:kCATransitionFade];
    [fadeTransition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
    [downloadWaitingView.layer addAnimation:fadeTransition forKey:nil];
    [downloadWaitingView setHidden:YES];
    
    [downloadWaitingLabel setHidden:YES];
    
    [indicatorView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
    [indicatorBackView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [indicatorView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
                         [indicatorBackView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
                     }
                     completion:^(BOOL finished) {
                         if (canFinishIndicatorView) {
                             [indicatorView stopAnimating];
                             [indicatorBackView setHidden:YES];
                         }
                         [indicatorView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                         [indicatorBackView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)]; 
                     }
     ];    
}

/***************************************************************
 * ダウンロード中の待機ラベルを表示
 ***************************************************************/
- (void)showWaitingLabelWithText:(NSString *)text {
    [downloadWaitingLabel setText:text];
    CGSize size = [text sizeWithFont:[downloadWaitingLabel font]];
    [downloadWaitingLabel setFrame:CGRectMake((kDisplayWidth - (size.width + 10)) / 2, 220, size.width + 10, 30)];
    [downloadWaitingLabel setHidden:NO];
}

/***************************************************************
 * 購入ボタンの押下時
 ***************************************************************/
- (void)purchaseButtonPressed:(UIButton *)button {
    [purchaseButton setEnabled:NO];
    [self requestInAppPurchase];
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
    [navigationBarTitleLabel setText:kNavigationBarTitleRecipeStoreName];
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
    
}  

/***************************************************************
 * 戻るボタン押下
 ***************************************************************/
- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

/***************************************************************
 * リクエスト開始
 ***************************************************************/
- (void)resumeRequest {
    if (recipeTableEntity) {
        [self setupView];
    } else {
        [self indicatorAppearAnimation:CGPointMake(160, 175) withDownloadWaitingView:NO];
        [productDetailUtil getProductDetail:productId];
    }
}

/***************************************************************
 * リクエスト中止
 ***************************************************************/
- (void)pauseRequest {
    [recipeImageUtil cancelRequest];
    [productDetailUtil cancelRequest];
    [productRecipeUtil cancelRequest];
    
    if (!isPurchasing && !isPurchaseRequest) {
        [self indicatorDisappearAnimation];
    }
}

/***************************************************************
 * In-App Purchase停止
 ***************************************************************/
- (void)cancelInAppPurchase {
    purchaseRequestIsValid = NO;
}

#pragma mark - RecipeImageUtil Delegate Methods

/***************************************************************
 * レシピ画像の設定
 ***************************************************************/
- (void)getImageFinishedWithImage:(UIImage *)recipeImage imageNo:(NSInteger)imageNo {
    PrintLog(@"Recipe Counter: %d", recipeCounter);
    if (recipeImage) {
        NSString *imageKey = [NSString stringWithFormat:@"%@%d", recipeImageKey, imageNo];
        PrintLog(@"%@%d", recipeImageKey, imageNo);
        [recipeImageDictionary setObject:recipeImage forKey:imageKey];
        
        recipeCounter++;
        
        [imageNoArray removeObject:[NSNumber numberWithInt:imageNo]];
        
        // ダウンロードしていない画像が残っている場合
        if ([imageNoArray count] > 0) {
            [self indicatorAppearAnimation:CGPointMake(160, 175) withDownloadWaitingView:YES];
            [self showWaitingLabelWithText:[NSString stringWithFormat:@"画像を取得中: %d / %d", recipeCounter, [recipeTableEntity.recipeNoArray count]]];
            [recipeImageUtil getImageForRecipeNo:[[imageNoArray objectAtIndex:0] intValue] 
                                 recipeImageType:RecipeImageTypeRecipe];
        }
        // 画像のダウンロードが完了した場合
        else {
            [self showWaitingLabelWithText:@"レシピ情報を取得中"];
            [productRecipeUtil getRecipeForProductId:[recipeTableEntity productId]
                                          appStoreId:[recipeTableEntity appStoreProductId]
                                     appStoreReceipt:productReceiptData
                                       recipeNoArray:[recipeTableEntity recipeNoArray]];
            
            [productReceiptData release], productReceiptData = nil;
        }
    }
    // 画像の再取得
    else if (isPurchasing) {
        PrintLog(@"Start getting recipes.");
        // ダウンロードしていない画像が残っている場合
        if ([imageNoArray count] > 0) {
            [self indicatorAppearAnimation:CGPointMake(160, 175) withDownloadWaitingView:YES];
            [self showWaitingLabelWithText:[NSString stringWithFormat:@"画像を取得中: %d / %d", recipeCounter, [recipeTableEntity.recipeNoArray count]]];
            [recipeImageUtil getImageForRecipeNo:[[imageNoArray objectAtIndex:0] intValue] 
                                 recipeImageType:RecipeImageTypeRecipe];
        }
    }
    // 画像のダウンロードが完了した状態で、購入ボタン押した場合
    else if ([imageNoArray count] == 0 && [recipeTableEntity.recipeNoArray count] > 0) {
        [self showWaitingLabelWithText:@"レシピ情報を取得中"];
        [productRecipeUtil getRecipeForProductId:[recipeTableEntity productId]
                                      appStoreId:[recipeTableEntity appStoreProductId]
                                 appStoreReceipt:productReceiptData
                                   recipeNoArray:[recipeTableEntity recipeNoArray]];
        
        [productReceiptData release], productReceiptData = nil;
    }
}

/***************************************************************
 * レシピ画像取得失敗
 ***************************************************************/
- (void)getImageFailed {
    PrintLog(@"Couldnt download detail image data.");
    [self indicatorDisappearAnimation];
    isPreview = YES;
    recipeCounter = 0;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                        message:@"しばらくしてから再度お試しください"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - RecipePreviewUtil Delegate Methods

/***************************************************************
 * 画像取得完了
 ***************************************************************/
- (void)getPreviewImageFinished:(UIImage *)image {
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionReveal];
    [transition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
    
    CGFloat w = 240;
    CGFloat h = 264;
    
    UIImageView *recipeImageView = [[UIImageView alloc] initWithImage:image];
    [recipeImageView setFrame:CGRectMake(recipePreviewCounter * (kDisplayWidth - 60) + (kDisplayWidth - 120 - w) / 2, 0, w, h)];
    [recipeImageView.layer addAnimation:transition forKey:nil];
    [imageScrollView setContentSize:CGSizeMake((recipePreviewCounter + 1) * (kDisplayWidth - 60), imageScrollViewHeight)];
    [imageScrollView addSubview:recipeImageView];
    [recipeImageView release];
    
    recipePreviewCounter++;
    
    [page setNumberOfPages:recipePreviewCounter];
    CGSize pageSize = [page sizeForNumberOfPages:page.numberOfPages];
    [pageBackView setFrame:CGRectMake(-5 + (kDisplayWidth - pageSize.width) / 2, page.frame.origin.y, pageSize.width + 10, 20)];
    
    if (recipePreviewCounter > 1) {
        [pageBackView setHidden:NO];
    }
    
    [previewImageNoArray removeObjectAtIndex:0];
    
    // ダウンロードしていない画像が残っている場合
    if ([previewImageNoArray count] > 0) {
        [self indicatorAppearAnimation:CGPointMake(160, 175) withDownloadWaitingView:NO];
        [self showWaitingLabelWithText:[NSString stringWithFormat:@"画像を取得中: %d / %d", recipePreviewCounter, recipeTableEntity.previewCount]];
        [recipePreviewUtil getImage:recipeTableEntity.productId
                            photoNo:[[previewImageNoArray objectAtIndex:0] intValue]];
    } 
    // 画像のダウンロードが完了した場合
    else {
        isPreview = NO;
        [self indicatorDisappearAnimation];
        [purchaseButton setEnabled:!productExists];
    }
}

/***************************************************************
 * 画像取得失敗
 ***************************************************************/
- (void)getPreviewImageFailed {
    [self indicatorDisappearAnimation];
    [purchaseButton setEnabled:!productExists];
    isPreview = NO;
}

#pragma mark - ProductDetailUtil Delegate Methods

/***************************************************************
 * レシピ詳細を設定
 ***************************************************************/
- (void)setProductDetail:(RecipeTableEntity *)newRecipeTableEntity {
    if (newRecipeTableEntity) {
        [self setRecipeTableEntity:newRecipeTableEntity];
        [self setupView];
    } else {
        PrintLog(@"Couldnt download product detail info.");
        [self indicatorDisappearAnimation];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                            message:@"しばらくしてから再度お試しください"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark - ProductRecipeUtil Delegate Methods

/***************************************************************
 * レシピをデータベースに入れる
 ***************************************************************/
- (void)setProductRecipe:(NSArray *)recipeArray {
    if (recipeArray) {
        [self showWaitingLabelWithText:@"データを保存中"];
        
        // 画像データを保存
        BOOL totalSuccess = YES;
        for (RecipeEntity *recipeEntity in recipeArray) {
            NSString *imageKey = [NSString stringWithFormat:@"%@%d", recipeImageKey, recipeEntity.recipeNo];
            UIImage *image = [recipeImageDictionary objectForKey:imageKey];
            BOOL success1 = [ImageUtil saveImage:image name:recipeEntity.photoName];
            UIImage *thumbnailImage = [ImageUtil resizeImage:[recipeImageDictionary objectForKey:imageKey] width:176 height:194];
            BOOL success2 = [ImageUtil saveImage:thumbnailImage name:[NSString stringWithFormat:@"thumb_%@", recipeEntity.photoName]];
            
            if (!(success1 && success2)) {
                PrintLog(@"Couldnt save recipe image data.");
                
                totalSuccess = NO;
                break;
            }
        }
        
        // レシピデータを保存
        if (totalSuccess) {
            BOOL success = [DatabaseUtility insertNewRecipeForRecipeEntityArray:recipeArray];
            totalSuccess = totalSuccess & success;
            PrintLog(@"DB recipe info insert success = %d", success);
        }
        
        // 完了
        if (totalSuccess) {
            [purchaseButton setTitle:@"購入済み" forState:UIControlStateDisabled];
            [purchaseButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [purchaseButton setEnabled:NO];
            productExists = YES;
            isPurchasing = NO;
            
            NSInteger currentCount = [self.navigationController.tabBarItem.badgeValue intValue] - 1;
            if (currentCount > 0) {
                [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", currentCount]];
            } else {
                [self.navigationController.tabBarItem setBadgeValue:nil];
            }
            
            [Utility scheduleNotificationWithCount:currentCount];
            
            NSString *alertTitle        = NSLocalizedString(@"購入が完了しました", @"購入が完了しました");
            NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"OK");
            UIAlertView *aleartView = [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                  message:nil 
                                                                 delegate:self
                                                        cancelButtonTitle:cancelButtonTitle 
                                                        otherButtonTitles:nil] autorelease];
            [aleartView setTag:alertTypeFinished];
            [aleartView show];
        } else {
            // 不要な画像を削除
            for (RecipeEntity *recipeEntity in recipeArray) {
                [ImageUtil removeImage:recipeEntity.photoName];
                [ImageUtil removeImage:[NSString stringWithFormat:@"thumb_%@", recipeEntity.photoName]];
            }
            
            PrintLog(@"Couldnt save recipe data.");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"データ保存に失敗しました"
                                                                message:@"端末の容量を減らしてから再度お試しください"
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else {
        PrintLog(@"Couldnt download product recipe data.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                            message:@"しばらくしてから再度お試しください"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    [self indicatorDisappearAnimation];
}

/***************************************************************
 * リクエストがキャンゼルされた
 ***************************************************************/
- (void)productRecipeRequestCancelled {
    PrintLog(@"");
    isPreview = YES;
    recipeCounter = 0;
    [self indicatorDisappearAnimation];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                        message:@"しばらくしてから再度お試しください"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark -
#pragma mark アラートメソッド

/**
 アラートを表示します
 */
- (void)showAlertView:(int)alertType {
    NSString *alertTitle        = nil;
    NSString *alertMessage      = nil;
    NSString *cancelButtonTitle = nil; 
    id delegate                 = nil;
    

    // AppPurchaseの支払いが不可能な場合
    if (alertType == alertTypeNoPayment) {
        alertTitle        = NSLocalizedString(@"App内での購入が許可されていません", @"App内での購入が許可されていません");
        alertMessage      = NSLocalizedString(@"「設定」→「一般」→「機能制限」→「App内での購入」をオンにして下さい", @"「設定」→「一般」→「機能制限」→「App内での購入」をオンにして下さい");
        cancelButtonTitle = NSLocalizedString(@"OK", @"OK");
    }
    // AppPurchaseの購入処理に失敗した場合
    else if (alertType == alertTypeFailInAppPurchase) {
        alertTitle        = NSLocalizedString(@"購入処理に失敗しました\nご利用のAppleIDは使用出来ない可能性があります", @"購入処理に失敗しました\nご利用のAppleIDは使用出来ない可能性があります");
        cancelButtonTitle = NSLocalizedString(@"OK", @"OK");
    }
    // iTunesStoreに接続できない場合
    else if (alertType == alertTypeNotConnectITunesStore) {
        alertTitle        = NSLocalizedString(@"iTunes Storeに接続出来ませんでした", @"iTunes Storeに接続出来ませんでした");
        cancelButtonTitle = NSLocalizedString(@"OK", @"OK");
    }
    // プロダクトIDが存在しない場合
    else if (alertType == alertTypeNotProductID) {
        alertTitle        = NSLocalizedString(@"商品情報の取得に失敗しました\n", @"商品情報の取得に失敗しました\ni暗記.jpへお問い合わせ下さい");
        cancelButtonTitle = NSLocalizedString(@"OK", @"OK");
    }
    // メンテナンスの場合
    else {
        alertTitle        = NSLocalizedString(@"現在メンテナンス中のため接続出来ません", @"現在メンテナンス中のため接続出来ません");
        cancelButtonTitle = NSLocalizedString(@"OK", @"OK");
    }
    // アラートを生成します
    UIAlertView *aleartView = [[[UIAlertView alloc] initWithTitle:alertTitle
                                                          message:alertMessage
                                                         delegate:delegate
                                                cancelButtonTitle:cancelButtonTitle
                                                otherButtonTitles:nil] autorelease];
    [aleartView setTag:alertType];
    [aleartView show];
}

#pragma mark -
#pragma mark AppPurchaseメソッド

/**
 AppPurchaseで購入処理を行います
 */
- (void)requestInAppPurchase
{
    [self releaseAppPurchaseManager];
    
    appPurchaseManager = [[AppPurchaseManager alloc] init];
    [appPurchaseManager set_delegate:self];
    
    // 購入処理可能な場合
    if ([appPurchaseManager canMakePayments])
    {
        isPurchaseRequest = YES;
        purchaseRequestIsValid = YES;
        [appPurchaseManager requestProductData:recipeTableEntity.appStoreProductId];
        
        PrintLog(@"%@", recipeTableEntity.appStoreProductId);
        [self indicatorAppearAnimation:CGPointMake(160, 175) withDownloadWaitingView:YES];
    }
    // 購入処理不可能な場合
    else
    {
        [self showAlertView:alertTypeNoPayment];
    }
}

/**
 購入処理に成功した場合
 */
- (void) appPurchasePaymentTransactionFinish:(NSData *)receiptData
{
    isPurchaseRequest = NO;
    if (purchaseRequestIsValid) {
        
        [AppPurchaseManager setReceiptData:receiptData purchaseRecipeId:[recipeTableEntity productId]];
        
        productReceiptData = [[NSData alloc] initWithData:receiptData];
        
        isPreview = NO;
        isPurchasing = YES;
        [self getImageFinishedWithImage:nil imageNo:0];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                            message:@"しばらくしてから再度お試しください"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [self indicatorDisappearAnimation];
    }
    
    PrintLog(@"");
}

/**
 購入処理を失敗した場合
 */
- (void) appPurchasePaymentTransactionFailed:(int)failType
{
    isPurchaseRequest = NO;
    PrintLog(@"");
    // iTunesStoreに接続出来ない場合
    if (failType == appPurchasePaymentFailNotConnectItunesStore) 
    {
        [self showAlertView:alertTypeNotConnectITunesStore];
    }
    // プロダクトIDが存在しない場合
    else if (failType == appPurchasePaymentFailNotProductID)
    {
        [self showAlertView:alertTypeNotProductID];
    }
    // AppPurchaseが許可されていない場合
    else if (failType == appPurchasePaymentFailNotAllowed)
    {
        [self showAlertView:alertTypeNoPayment];
    }
    // 不正なAppleIDの場合
    else if (failType == appPurchasePaymentFailInvaliedAppleID)
    {
        [self showAlertView:alertTypeFailInAppPurchase];
    }
    
    [purchaseButton setEnabled:YES];
    [self indicatorDisappearAnimation];
}

/**
 AppPurchaseマネージャーを解放します
 */
- (void)releaseAppPurchaseManager
{
    if (appPurchaseManager != nil) {
        [appPurchaseManager release], appPurchaseManager = nil;
    }
}

#pragma mark - UIScrollView Delegate Methods

/***************************************************************
 * ScrollView移動開始
 ***************************************************************/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [mainScrollView setContentOffset:CGPointMake(0, mainScrollView.contentSize.height - mainScrollView.frame.size.height) animated:YES];
}

/***************************************************************
 * ScrollView移動中
 ***************************************************************/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = (imageScrollView.contentOffset.x + (kDisplayWidth - 60) / 2) / (kDisplayWidth - 60);
    [page setCurrentPage:currentPage];
}

#pragma mark - Memory Management

/***************************************************************
 * 画面常時前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [self resumeRequest];
}

/***************************************************************
 * 画面非常時前
 ***************************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    [self pauseRequest];
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
    if (recipeImageUtil) {
        [recipeImageUtil cancelRequest];
        [recipeImageUtil release], recipeImageUtil = nil;
    }
    if (productRecipeUtil) {
        [productRecipeUtil cancelRequest];
        [productRecipeUtil release], productRecipeUtil = nil;
    }
    if (productDetailUtil) {
        [productDetailUtil cancelRequest];
        [productDetailUtil release], productDetailUtil = nil;
    }
    if (recipePreviewUtil) {
        [recipePreviewUtil cancelRequest];
        [recipePreviewUtil release], recipePreviewUtil = nil;
    }
    if (imageNoArray) {
        [imageNoArray release], imageNoArray = nil;
    }
    if (previewImageNoArray) {
        [previewImageNoArray release], previewImageNoArray = nil;
    }
    if (productReceiptData) {
        [productReceiptData release], productReceiptData = nil;
    }
    [recipeTableEntity release], recipeTableEntity = nil;
    [recipeImageDictionary release], recipeImageDictionary = nil;
    [super dealloc];
}

@end
