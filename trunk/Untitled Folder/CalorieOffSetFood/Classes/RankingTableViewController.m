//
//  RankingTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "RankingTableViewController.h"
#import "NSData+Base64.h"
#import "MedicinalCarbOffAppDelegate.h"

static NSInteger sampleLabelTag = 100;

@implementation RankingTableViewController


#pragma mark -
#pragma mark Initialization
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        isBack = NO;
        rankingArray = [[NSMutableArray alloc] init];
        recipeCellEntityArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            [recipeCellEntityArray addObject:[[[RecipeCellEntity alloc] init] autorelease]];
        }
        relationalRecipeUtil = [[RelationalRecipeUtil alloc] init];
        [relationalRecipeUtil setDelegate:self];
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
    [self.navigationController setNavigationBarHidden:YES];
    
    [self navigationBarSetting];

    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, kDisplayMinHeight)];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setBackgroundColor:[UIColor clearColor]];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
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
 * ランキング情報取得
 ***************************************************************/
- (void)getRankingCellArray {
    NSMutableArray *rankingNoArray = [[NSMutableArray alloc] initWithCapacity:[rankingArray count]];
    
    for (int i = 0; i < [rankingArray count]; i++) {
        if ([[[rankingArray objectAtIndex:i] valueForKey:@"recipe_no"] intValue] > kRecipeCount) {
            [rankingNoArray addObject:[[rankingArray objectAtIndex:i] valueForKey:@"recipe_no"]];
        }
    }
    
    PrintLog(@"Ranking: %@", rankingNoArray);
    [relationalRecipeUtil setRecipeNoArray:rankingNoArray];
    [rankingNoArray release];
    
    [relationalRecipeUtil getRelationalRecipe];
}

/***************************************************************
 * ランキングセル設定
 ***************************************************************/
- (void)setRelationalRecipe:(NSMutableArray *)cellEntityArray {
    NSMutableArray *sorterArray = [[[NSMutableArray alloc] init] autorelease];
    
    // １つ以上入っている場合
    if (cellEntityArray) {
        // アプリ内のレシピを追加
        for (NSDictionary *rankingDictionary in rankingArray) {
            NSInteger recipeNo = [[rankingDictionary objectForKey:@"recipe_no"] intValue];
            if (recipeNo <= kRecipeCount) {
                RecipeCellEntity *recipeCellEntity = [DatabaseUtility selectRecipeCellWithRecipeNo:recipeNo];
                [cellEntityArray addObject:recipeCellEntity];
            }
        }
        
        [sorterArray addObjectsFromArray:cellEntityArray];
    }
    // １つも入っていない場合
    else {
        // 配列を初期化
        NSMutableArray *insertCellEntityArray = [[NSMutableArray alloc] init];
        
        // アプリ内のレシピを追加
        for (NSDictionary *rankingDictionary in rankingArray) {
            NSInteger recipeNo = [[rankingDictionary objectForKey:@"recipe_no"] intValue];
            if (recipeNo <= kRecipeCount) {
                RecipeCellEntity *recipeCellEntity = [DatabaseUtility selectRecipeCellWithRecipeNo:recipeNo];
                [insertCellEntityArray addObject:recipeCellEntity];
            }
        }
        
        [sorterArray addObjectsFromArray:insertCellEntityArray];
        
        // 配列を解放
        [insertCellEntityArray release];
    }
    
    for (int i = 0; i < [sorterArray count]; i++) {
        RecipeCellEntity *recipeCellEntity = [sorterArray objectAtIndex:i];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recipe_no == %d", [recipeCellEntity recipeNo]];
        NSArray *filteredArray = [rankingArray filteredArrayUsingPredicate:predicate];
        [recipeCellEntityArray replaceObjectAtIndex:[rankingArray indexOfObject:[filteredArray objectAtIndex:0]] withObject:recipeCellEntity];
    }
    
    if ([sorterArray count] != 10) {
        [rankingArray removeAllObjects];
        
        PrintLog(@"Couldnt find all 10 recipes.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                            message:@"しばらくしてから再度お試しください"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        [tableView_ reloadData];
    }
    
    [self indicatorDisappearAnimation];
}

/*****************************************************************************
 * プロダクト詳細ページに遷移
 *****************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            MedicinalCarbOffAppDelegate *appDelegate = (MedicinalCarbOffAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate goToProduct:productId];
            break;
        }
        default:
            break;
    }
}

/***************************************************************
 * ランキングデータ取得
 ***************************************************************/
- (void)getRankingData {
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
        NSString * urlString = [NSString stringWithFormat:@"%@%@", kRankingServerBaseURL, kRankingServerGetRanking];
        NSURL *url = [NSURL URLWithString:urlString];
        
        // インジケータ表示設定
        [indicatorView startAnimating];
        [indicatorBackView setHidden:NO];

        NSData *requestData 
        = [[NSString stringWithFormat:@"%@", kRankingServerPassword] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; 
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];        
        [NSURLConnection connectionWithRequest:request delegate:self];
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
    NSString *result = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
    [receivedData release];
    
    NSDictionary *rankingDictionary = [result JSONValue];
    PrintLog(@"%@", rankingDictionary);
    if ([rankingDictionary objectForKey:@"result"]) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray = [[rankingDictionary objectForKey:@"record"] sortedArrayUsingDescriptors:sortDescriptors];
        
        if (![sortedArray isEqualToArray:rankingArray]) {
            [rankingArray removeAllObjects];
            [rankingArray addObjectsFromArray:sortedArray];
            [self getRankingCellArray];
        } else {
            [self indicatorDisappearAnimation];
        }

    } else {
        PrintLog(@"Couldnt download initial ranking data.");
        [self indicatorDisappearAnimation];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                            message:@"しばらくしてから再度お試しください"
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}


/***************************************************************
 * 通信エラー
 ***************************************************************/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self indicatorDisappearAnimation];

    PrintLog(@"Couldnt download initial ranking data.");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通信に失敗しました"
                                                        message:@"しばらくしてから再度お試しください"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
    
}


#pragma mark -
#pragma mark View lifecycle

/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    RecipeCellEntity *recipeCellEntity = [recipeCellEntityArray objectAtIndex:0];
    if (recipeCellEntity.recipeNo != 0) {
        [tableView_ reloadData];
    }
}
/***************************************************************
 * ビュー表示後
 ***************************************************************/
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*
     * DBに問合せ
     * ・タブ切り替えで表示したときに通信発生
     * ・ナビゲーションバーのバックボタンで遷移したときは通信しない
     */
    if (isBack) {
        isBack = NO;
    } else {
        [self getRankingData];        
    }

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

#pragma mark -
#pragma mark Table view data source

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
    return [rankingArray count];
}


/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    NSInteger badgeImageTag = 2111;
    
    RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView *badgeImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 29.f, 29.f)] autorelease];
        [badgeImageView setTag:badgeImageTag];
        [cell.contentView addSubview:badgeImageView];
        
        UILabel *sampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 88)];
        [sampleLabel setBackgroundColor:[UIColor colorWithWhite:.7 alpha:.3]];
        [sampleLabel setTag:sampleLabelTag];
        [sampleLabel setHidden:YES];
        [sampleLabel setText:@"レシピストア"];
        [sampleLabel setTextAlignment:UITextAlignmentCenter];
        [sampleLabel setTextColor:[UIColor colorWithWhite:.2 alpha:.3]];
        [sampleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [cell.contentView addSubview:sampleLabel];
        [sampleLabel release];
    }
    

    RecipeCellEntity *recipeCellEntity = [recipeCellEntityArray objectAtIndex:[indexPath row]];
    
    // サムネイル画像設定とサンプル表示
    UILabel *sampleLabel= (UILabel *)[cell viewWithTag:sampleLabelTag];
    if ([recipeCellEntity recipeNo] > kRecipeCount) {
        if (![[recipeCellEntity thumbnailPhotoNo] isEqualToString:@""]) {
            UIImage *recipeImage = [UIImage imageWithData:[NSData dataWithBase64EncodedString:[recipeCellEntity thumbnailPhotoNo]]];
            [cell.photoImageView setImage:recipeImage];
        }
        [sampleLabel setHidden:[DatabaseUtility checkDoesRecipeExist:[recipeCellEntity recipeNo]]];
    } else {
        [cell.photoImageView setImage:[UIImage imageNamed:[recipeCellEntity thumbnailPhotoNo]]];
        PrintLog(@"[セル表示] thumbnail = %@", [recipeCellEntity thumbnailPhotoNo]);
        [sampleLabel setHidden:YES];
    }

    [cell.costLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeCellEntity carbQty]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeCellEntity time]]];
    [cell.calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeCellEntity calorie]]];
    
    NSString *recipeName = [recipeCellEntity recipeName];
    UIFont *recipeNameFont = [UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize];
    [cell.recipeNameLabel setText:recipeName];   
    [cell.recipeNameLabel setFont:recipeNameFont];
    [cell.recipeNameLabel setNeedsDisplay];
    
    UIImageView *badgeImageView = (UIImageView *)[cell viewWithTag:badgeImageTag];
    [badgeImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d", kRankingBadgeImageName, [indexPath row] + 1]]];

    return cell;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    RecipeCellEntity *recipeCellEntity = [recipeCellEntityArray objectAtIndex:[indexPath row]];
    UILabel *sampleLabel= (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:sampleLabelTag];
    if ([recipeCellEntity recipeNo] > kRecipeCount && ![sampleLabel isHidden]) {
        PrintLog(@"ProductId: %d", [recipeCellEntity productId]);
        productId = [recipeCellEntity productId];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新レシピ購入"
                                                            message:@"このレシピはレシピストアで購入できます。今すぐレシピストアに移動しますか？"
                                                           delegate:self
                                                  cancelButtonTitle:@"いいえ"
                                                  otherButtonTitles:@"レシピストア", nil];
        [alertView show];
        [alertView release];
    } else {
        isBack = YES;
        
        RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:[recipeCellEntity recipeNo]];
        [recipeViewController setDelegate:self];
        [self.navigationController pushViewController:recipeViewController animated:YES];
        [recipeViewController release];
    }

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
    [navigationBarTitleLabel setText:kNavigationBarTitleRankingName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
}  


#pragma mark -
#pragma mark Memory management

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
    [recipeCellEntityArray release];
    [rankingArray release];
    [super dealloc];
}


@end

