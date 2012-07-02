//
//  RecipeStoreViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 2/17/12.
//  Copyright (c) 2012 レッドフォックス株式会社. All rights reserved.
//

#import "RecipeStoreViewController.h"
#import "RecipeStoreDetailViewController.h"
#import "RecipeStoreCell.h"
#import "RecipeTableEntity.h"
#import "DatabaseUtility.h"
#import "Utility.h"
#import "JSON.h"
#import "NSData+Base64.h"

static NSString * appStoreProductIdKey = @"appstore_product_id";
static NSString * productIdKey         = @"product_id";
static NSString * priceKey             = @"price";
static NSString * productLeadCellKey   = @"read_statement";
static NSString * productLeadDetailKey = @"explanation_text";
static NSString * productNameKey       = @"product_name";
static NSString * recipeItemKey        = @"recipe";
static NSString * recipeNoKey          = @"recipe_no";
static NSString * recipeSizeKey        = @"recipe_size";
static NSString * photoCountKey        = @"photo_count";

static NSString * productImageKey        = @"productImage";

@interface RecipeStoreViewController ()

- (void)getProductImage;
- (void)getRecipeTableData;

@end

@implementation RecipeStoreViewController
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    self = [super init];
    if (self) {
        conn = nil;
        cellWasSelected = NO;
        recipeTableEntityArray = [[NSMutableArray alloc] init];
        recipeImageUtil = [[RecipeImageUtil alloc] init];
        [recipeImageUtil setDelegate:self];
        noRecipesString = [[NSMutableString alloc] initWithFormat:@"%@", NSLocalizedString(@"レシピを取得中です", @"レシピを取得中です")];
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
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self navigationBarSetting];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, 368) style:UITableViewStylePlain];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [self.view addSubview:tableView_];
    [tableView_ release];
    
    // インジケータ設定
    indicatorBackView = [[UIView alloc] initWithFrame:CGRectMake(130, 145, 60, 60)];
    [indicatorBackView setBackgroundColor:[UIColor blackColor]];
    [indicatorBackView setAlpha:0.5f];
    indicatorBackView.layer.cornerRadius = 10.0f;
    [self.view addSubview:indicatorBackView];
    [indicatorBackView setHidden:YES];
    [indicatorBackView release];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 150, 50, 50)];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicatorView];
    [indicatorView release];
}

/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [self resumeRequest];
}

/***************************************************************
 * ビュー非表示前
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
    [noRecipesString release], noRecipesString = nil;
    [recipeTableEntityArray release], recipeTableEntityArray = nil;
    [super dealloc];
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
}

- (void)goToProduct:(NSInteger)productId {
    RecipeStoreDetailViewController *recipeStoreDetailViewController = [[RecipeStoreDetailViewController alloc] initWithProductId:productId];
    for (RecipeTableEntity *recipeTableEntity in recipeTableEntityArray) {
        if (productId == recipeTableEntity.productId) {
            [recipeStoreDetailViewController setRecipeTableEntity:recipeTableEntity];
            break;
        }
    }
    
    [self.navigationController pushViewController:recipeStoreDetailViewController animated:NO];
    [recipeStoreDetailViewController release];
}

/***************************************************************
 * リクエスト開始
 ***************************************************************/
- (void)resumeRequest {
    if ([[[self.navigationController viewControllers] lastObject] isKindOfClass:[RecipeStoreViewController class]]) {
        PrintLog(@"Resume Recipe Store View Controller request.");
        if ([recipeTableEntityArray count] == 0) {
            [self getRecipeTableData];
        } else {
            for (int i = 0; i < [recipeTableEntityArray count]; i++) {
                RecipeTableEntity *tableEntity = [recipeTableEntityArray objectAtIndex:i];
                if (![tableEntity productImage]) {
                    productCounter = i;
                    [self getProductImage];
                    break;
                }
            }
        }
        [tableView_ reloadData];
    } else if ([[[self.navigationController viewControllers] lastObject] isKindOfClass:[RecipeStoreDetailViewController class]]) {
        PrintLog(@"Resume Recipe Store Detail View Controller request.");
        RecipeStoreDetailViewController *recipeStoreDetailViewController = (RecipeStoreDetailViewController *)[[self.navigationController viewControllers] lastObject];
        [recipeStoreDetailViewController resumeRequest];
    }
}

/***************************************************************
 * リクエスト中止
 ***************************************************************/
- (void)pauseRequest {
    if ([[[self.navigationController viewControllers] lastObject] isKindOfClass:[RecipeStoreViewController class]]) {
        PrintLog(@"Pause Recipe Store View Controller request.");
        [recipeImageUtil cancelRequest];
        [self cancelRequest];
        [self indicatorDisappearAnimation];
    } else if ([[[self.navigationController viewControllers] lastObject] isKindOfClass:[RecipeStoreDetailViewController class]]) {
        if (!cellWasSelected) {
            PrintLog(@"Pause Recipe Store Detail View Controller request.");
            RecipeStoreDetailViewController *recipeStoreDetailViewController = (RecipeStoreDetailViewController *)[[self.navigationController viewControllers] lastObject];
            [recipeStoreDetailViewController pauseRequest];
        } else {
            PrintLog(@"Pause Recipe Store View Controller request.");
            [recipeImageUtil cancelRequest];
            [self cancelRequest];
            [self indicatorDisappearAnimation];
            cellWasSelected = NO;
        }
    }
}

/***************************************************************
 * In-App Purchase停止
 ***************************************************************/
- (void)cancelInAppPurchase {
    if ([[[self.navigationController viewControllers] lastObject] isKindOfClass:[RecipeStoreDetailViewController class]]) {
        PrintLog(@"");
        RecipeStoreDetailViewController *recipeStoreDetailViewController = (RecipeStoreDetailViewController *)[[self.navigationController viewControllers] lastObject];
        [recipeStoreDetailViewController cancelInAppPurchase];
    }
}

#pragma mark - Network methods

/***************************************************************
 * バナーデータ取得
 ***************************************************************/
- (void)getRecipeTableData {
    // インターネット接続確認
    internetConnectionStatus = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [internetConnectionStatus currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                            message:@"しばらくしてから再度お試しください"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        // インジケータ表示設定
        [indicatorView startAnimating];
        [indicatorBackView setHidden:NO];
        [tableView_ setUserInteractionEnabled:NO];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerProductList];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSData *requestData 
        = [[NSString stringWithFormat:@"%@", kRankingServerPassword] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

/***************************************************************
 * 通信開始時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    receivedData = [[NSMutableData alloc] init];
    
    PrintLog(@"通信開始");
}

/***************************************************************
 * データ受信時
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
//    PrintLog(@"データ受信中");
}

/***************************************************************
 * インジケータ非表示アニメーション
 ***************************************************************/
- (void)indicatorDisappearAnimation {
    [indicatorView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
    [indicatorBackView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [indicatorView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
                         [indicatorBackView setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
                     }
                     completion:^(BOOL finished) {
                         [indicatorView stopAnimating];
                         [indicatorBackView setHidden:YES];     
                         [indicatorView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                         [indicatorBackView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];    
                     }
     ];    
}

/***************************************************************
 * 通信完了
 ***************************************************************/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    PrintLog(@"通信完了");
    [conn release], conn = nil;
    [self indicatorDisappearAnimation];
    
    NSString *result = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    [receivedData release], receivedData = nil;
    NSArray *resultArray = [NSArray arrayWithArray:[[result JSONValue] objectForKey:@"productList"]];
    
    [recipeTableEntityArray removeAllObjects];
    for (NSDictionary *recipeDictionary in resultArray) {
        RecipeTableEntity *recipeTableEntity = [[RecipeTableEntity alloc] init];
        [recipeTableEntity setAppStoreProductId:[recipeDictionary objectForKey:appStoreProductIdKey]];
        [recipeTableEntity setProductId:[[recipeDictionary objectForKey:productIdKey] intValue]];
        [recipeTableEntity setPrice:[[recipeDictionary objectForKey:priceKey] intValue]];
        [recipeTableEntity setProductLeadCell:[recipeDictionary objectForKey:productLeadCellKey]];
        [recipeTableEntity setProductLeadDetail:[recipeDictionary objectForKey:productLeadDetailKey]];
        [recipeTableEntity setProductName:[recipeDictionary objectForKey:productNameKey]];
        [recipeTableEntity setPreviewCount:[[recipeDictionary objectForKey:photoCountKey] intValue]];
        PrintLog(@"Preview Count: %d", recipeTableEntity.previewCount);
        
        NSMutableArray *recipeNoArray = [[NSMutableArray alloc] init];
        NSMutableArray *recipeSizeArray = [[NSMutableArray alloc] init];
        for (NSDictionary *recipeItemDictionary in [recipeDictionary objectForKey:recipeItemKey]) {
            [recipeNoArray addObject:[NSNumber numberWithInt:[[recipeItemDictionary objectForKey:recipeNoKey] intValue]]];
            [recipeSizeArray addObject:[recipeItemDictionary objectForKey:recipeSizeKey]];
        }
        [recipeTableEntity setRecipeNoArray:recipeNoArray];
        [recipeTableEntity setRecipeSizeArray:recipeSizeArray];
        [recipeNoArray release];
        [recipeSizeArray release];
        
        [recipeTableEntityArray addObject:recipeTableEntity];
        [recipeTableEntity release];
    }
    [noRecipesString setString:[NSString stringWithFormat:@"%@", NSLocalizedString(@"新しいレシピはありません", @"新しいレシピはありません")]];
    [tableView_ reloadData];
    [tableView_ setUserInteractionEnabled:YES];
    
    if ([recipeTableEntityArray count] != 0) {
        productCounter = 0;
        [self getProductImage];
    }
}

/***************************************************************
 * 通信失敗
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PrintLog(@"通信失敗");
    [conn release], conn = nil;
    
    [self indicatorDisappearAnimation];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                        message:@"しばらくしてから再度お試しください"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

/***************************************************************
 * 通信中止
 ***************************************************************/
- (void)cancelRequest {
    if (conn) {
        PrintLog(@"通信キャンセル");
        [conn cancel];
        [conn release], conn = nil;
        [receivedData release], receivedData = nil;
    }
}

/***************************************************************
 * プロダクト画像を取得
 ***************************************************************/
- (void)getProductImage {
    if (productCounter < [recipeTableEntityArray count]) {
        RecipeTableEntity *recipeTableEntity = [recipeTableEntityArray objectAtIndex:productCounter]; 
        [recipeImageUtil getImageForRecipeNo:[recipeTableEntity productId]
                             recipeImageType:RecipeImageTypeProduct];
    } else {
        productCounter = 0;
        [recipeImageUtil cancelRequest];
    }
}

/***************************************************************
 * レシピ画像の設定
 ***************************************************************/
- (void)getImageFinishedWithImage:(UIImage *)recipeImage imageNo:(NSInteger)imageNo {
    if (![[recipeTableEntityArray objectAtIndex:productCounter] productImage]) {
        [[recipeTableEntityArray objectAtIndex:productCounter] setProductImage:recipeImage];
    }
    
    productCounter++;
    [self getProductImage];
    [tableView_ reloadData];
}

#pragma mark - Table view data source

/***************************************************************
 * セクション数
 ***************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([recipeTableEntityArray count] > 0) {
        return [recipeTableEntityArray count];
    } else {
        return 1;
    }
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RecipeStoreCell";
    
    RecipeStoreCell *cell = (RecipeStoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([recipeTableEntityArray count] > 0) {
        [cell setUserInteractionEnabled:YES];
        [cell.textLabel setHidden:YES];
        [cell.photoImageView setHidden:NO];
        [cell.arrowImageView setHidden:NO];
        [cell.recipeTitleLabel setHidden:NO];
        [cell.leadLabel setHidden:NO];
        [cell.priceLabel setHidden:NO];
        
        RecipeTableEntity *recipeTableEntity = [recipeTableEntityArray objectAtIndex:[indexPath row]];
        if ([recipeTableEntity productImage]) {
            CATransition *transition = [CATransition animation];
            [transition setType:kCATransitionFade];
            [transition setTimingFunction:UIViewAnimationOptionCurveEaseInOut];
            [cell.photoImageView.layer addAnimation:transition forKey:nil];
            [cell.photoImageView setImage:[recipeTableEntity productImage]];
        } else {
            [cell.photoImageView setImage:nil];
        }
        [cell.recipeTitleLabel setText:[recipeTableEntity productName]];
        [cell.leadLabel setText:[recipeTableEntity productLeadCell]];
        
        // Check if product id exists.
        BOOL productExists = [DatabaseUtility checkProductExists:recipeTableEntity.productId];
        
        if (productExists) {
            [cell.priceLabel setText:@"購入済み"];
        } else {
            [cell.priceLabel setText:[NSString stringWithFormat:@"¥%d",[recipeTableEntity price]]];
        }
    } else {
        [cell setUserInteractionEnabled:NO];
        [cell.textLabel setHidden:NO];
        [cell.textLabel setEnabled:NO];
        [cell.photoImageView setHidden:YES];
        [cell.arrowImageView setHidden:YES];
        [cell.recipeTitleLabel setHidden:YES];
        [cell.leadLabel setHidden:YES];
        [cell.priceLabel setHidden:YES];
        [cell.textLabel setText:noRecipesString];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:22.f]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

/***************************************************************
 * セル選択時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    cellWasSelected = YES;
    RecipeStoreDetailViewController *recipeStoreDetailViewController = [[RecipeStoreDetailViewController alloc] initWithProductId:[[recipeTableEntityArray objectAtIndex:[indexPath row]] productId]];
    [recipeStoreDetailViewController setRecipeTableEntity:[recipeTableEntityArray objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:recipeStoreDetailViewController animated:YES];
    [recipeStoreDetailViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108.f;
}

@end
