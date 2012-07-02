//
//  RecipeStoreDetailViewController.h
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPurchaseManager.h"
#import "Reachability.h"
#import "RecipeTableEntity.h"
#import "RecipeImageUtil.h"
#import "ProductRecipeUtil.h"
#import "ProductDetailUtil.h"
#import "ProductCountUtil.h"
#import "RecipePreviewUtil.h"

@interface RecipeStoreDetailViewController : UIViewController <NSURLConnectionDataDelegate, UIScrollViewDelegate> {
    UIScrollView *mainScrollView;
    UIPageControl *page;
    UIView *pageBackView;
    
    AppPurchaseManager *appPurchaseManager; // AppPurchaseマネージャー
    Reachability *internetConnectionStatus;
    NSMutableData *receivedData;
    
    RecipeTableEntity *recipeTableEntity;
    NSMutableArray *imageNoArray;
    NSMutableArray *previewImageNoArray;
    UIImage *productImage;
    UIScrollView *imageScrollView;
    
    RecipeImageUtil *recipeImageUtil;
    ProductRecipeUtil *productRecipeUtil;
    ProductDetailUtil *productDetailUtil;
    RecipePreviewUtil *recipePreviewUtil;
    
    NSMutableDictionary *recipeImageDictionary;
    NSInteger recipeCounter;
    NSInteger recipePreviewCounter;
    
    BOOL ranSetupView;
    BOOL canFinishIndicatorView;
    BOOL purchaseRequestIsValid;
    
    UIButton *purchaseButton;
    BOOL productExists;
    NSInteger productId;
    BOOL isPreview;
    BOOL isPurchasing;
    BOOL isPurchaseRequest;
    NSData *productReceiptData;
    
    UIView *indicatorBackView;
    UIActivityIndicatorView *indicatorView;
    UIView *downloadWaitingView;
    UIView *downloadWaitingBackView;
    UILabel *downloadWaitingLabel;
}

- (id)initWithProductId:(NSInteger)newProductId;
- (void)navigationBarSetting;
//- (void)getRecipeData;
- (void)getImageFinishedWithImage:(UIImage *)recipeImage imageNo:(NSInteger)imageNo;
- (void)getImageFailed;
- (void)requestInAppPurchase;
- (void)releaseAppPurchaseManager;
- (void)setProductRecipe:(NSArray *)recipeArray;
- (void)setProductDetail:(RecipeTableEntity *)newRecipeTableEntity;
- (void)resumeRequest;
- (void)pauseRequest;
- (void)cancelInAppPurchase;
- (void)productRecipeRequestCancelled;

@property (nonatomic, retain) RecipeTableEntity *recipeTableEntity;
@property (nonatomic, retain) UIImage *productImage;

@end
