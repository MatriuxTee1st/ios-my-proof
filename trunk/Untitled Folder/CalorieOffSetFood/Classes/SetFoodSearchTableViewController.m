//
//  SetFoodSearchTableViewController.h
//  CalorieOffSetFood
//
//  Created by  on 12/06/28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetFoodSearchTableViewController.h"


@implementation SetFoodSearchTableViewController
#import "ImageUtil.h"

#pragma mark -
#pragma mark Initialization

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithType:(NSInteger)type_ {
    self = [super init];
    if (self) {
        type = type_;
        cellArray = [[NSMutableArray alloc] init];
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
    
    searchTabImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSearchTabAllImageName]];
    [searchTabImageView setFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, 44)];
    [searchTabImageView setImage:[UIImage imageNamed:kSearchTabAllImageName]];
    [self.view addSubview:searchTabImageView];
    [searchTabImageView release];
    
    UIButton *searchTypeBButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchTypeBButton setFrame:CGRectMake(0, 48, 160, 44)];
    [searchTypeBButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchTypeBButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchTypeBButton setShowsTouchWhenHighlighted:YES];
    [searchTypeBButton setTag:kBodyTypeB];
    [searchTypeBButton addTarget:self action:@selector(searchTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchTypeBButton];
    
    UIButton *searchTypeAButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchTypeAButton setFrame:CGRectMake(160, 48, 160, 44)];
    [searchTypeAButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchTypeAButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchTypeAButton setShowsTouchWhenHighlighted:YES];
    [searchTypeAButton setTag:kBodyTypeA];
    [searchTypeAButton addTarget:self action:@selector(searchTypeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchTypeAButton];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, kDisplayWidth, 323)];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setBackgroundColor:[UIColor clearColor]];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [self.view addSubview:tableView_];
    [tableView_ release];
    
    [self settingSearch];
}

/***************************************************************
 * 検索タブ押下時
 ***************************************************************/
- (void)searchTypeButtonPushed:(UIButton *)button {
    type = [button tag];
    [searchTabImageView setTag:type]; 
	
    [self settingSearch];
}

/***************************************************************
 * カテゴリ検索
 ***************************************************************/
- (void)settingSearch {
    PrintLog(@"{");
    NSString *imageName = nil;
    if (type == kBodyTypeA) {
        imageName = kSearchTabBodyTypeAImageName;
    } else if (type == kBodyTypeB) {
        imageName = kSearchTabBodyTypeBImageName;
    }
    
    [searchTabImageView setImage:[UIImage imageNamed:imageName]];
    
    [cellArray removeAllObjects];
    [cellArray setArray:[DatabaseUtility selectRecipeCellWithBodyType:type]];
    
    [tableView_ reloadData];
    [tableView_ setContentOffset:CGPointMake(0, 0)];
    PrintLog(@"}");
}

#pragma mark -
#pragma mark View lifecycle
/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    NSInteger rowCount;
    
    if ([cellArray count] == 0) {
        rowCount = 1;
    } else {
        rowCount = [cellArray count];
    }
    
    return rowCount;
}


/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cellArray count] != 0) {
        static NSString *CellIdentifier = @"Cell";
        
        RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
		
        RecipeCellEntity *recipeCellEntity = [cellArray objectAtIndex:indexPath.row];
		
        // サムネイル画像設定
        if (recipeCellEntity.recipeNo <= kRecipeCount) {
            [cell.photoImageView setImage:[UIImage imageNamed:[recipeCellEntity thumbnailPhotoName]]];
        } else {
            [cell.photoImageView setImage:[ImageUtil loadImage:[recipeCellEntity thumbnailPhotoName]]];
        }
        
        [cell.costLabel setText:[NSString stringWithFormat:@"%¥%d", [recipeCellEntity cost]]];
        [cell.calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeCellEntity calorie]]];
		
        NSString *recipeName = [recipeCellEntity recipeName];
        UIFont *recipeNameFont = [UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize];
        [cell.recipeNameLabel setText:recipeName];   
        [cell.recipeNameLabel setFont:recipeNameFont];
        [cell.recipeNameLabel setNeedsDisplay];
        
        if (recipeCellEntity.recipeNo > kRecipeCount) {
            NSDate *recipeDate = [DatabaseUtility selectDownloadDate:recipeCellEntity.recipeNo];
            
            // 1週間以内に購入した場合
            if ([[NSDate date] timeIntervalSinceDate:recipeDate] < 60 * 60 * 24 * 7) {
                [cell.addonImageView setHidden:NO];
            } else {
                [cell.addonImageView setHidden:YES];
            }
        } else {
            [cell.addonImageView setHidden:YES];
        }
		
        return cell;
    } else {
        static NSString *CellIdentifier = @"EmptyCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        [[cell textLabel] setText:NSLocalizedString(@"このカテゴリが空です", @"このカテゴリが空です")];
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:22.f]];
        [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
        [[cell textLabel] setTextColor:[UIColor grayColor]];
        [cell setUserInteractionEnabled:NO];
        
        return cell;
    }
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
    // Push food dictionary detail view controller.
	RecipeCellEntity *recipeCellEntity = [cellArray objectAtIndex:indexPath.row];
    SetFoodDetailViewController *setFoodDetailViewController = [[SetFoodDetailViewController alloc] initWithRecipeNo:[recipeCellEntity recipeNo]];
    [[self navigationController] pushViewController:setFoodDetailViewController animated:YES];
    [setFoodDetailViewController release];
    [tableView_ deselectRowAtIndexPath:indexPath animated:NO];
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
    [navigationBarTitleLabel setText:kNavigationBarTitleSetFoodName];
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
    [cellArray release];
    [super dealloc];
}



@end