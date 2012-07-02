//
//  FoodSearchTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "FoodSearchTableViewController.h"


@implementation FoodSearchTableViewController
#import "ImageUtil.h"

#pragma mark -
#pragma mark Initialization

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        sectionArray = [[NSMutableArray alloc] init];
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
    
    UIButton *searchCategoryAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchCategoryAllButton setFrame:CGRectMake(0, 48, 80, 44)];
    [searchCategoryAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchCategoryAllButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchCategoryAllButton setShowsTouchWhenHighlighted:YES];
    [searchCategoryAllButton setTag:kSearchTabCategoryAll];
    [searchCategoryAllButton addTarget:self action:@selector(searchCategoryButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchCategoryAllButton];
    
    UIButton *searchCategoryVegeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchCategoryVegeButton setFrame:CGRectMake(80, 48, 80, 44)];
    [searchCategoryVegeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchCategoryVegeButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchCategoryVegeButton setShowsTouchWhenHighlighted:YES];
    [searchCategoryVegeButton setTag:kSearchTabCategoryVege];
    [searchCategoryVegeButton addTarget:self action:@selector(searchCategoryButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchCategoryVegeButton];
    
    UIButton *searchCategoryMeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchCategoryMeatButton setFrame:CGRectMake(160, 48, 80, 44)];
    [searchCategoryMeatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchCategoryMeatButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchCategoryMeatButton setShowsTouchWhenHighlighted:YES];
    [searchCategoryMeatButton setTag:kSearchTabCategoryMeat];
    [searchCategoryMeatButton addTarget:self action:@selector(searchCategoryButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchCategoryMeatButton];
    
    UIButton *searchCategoryHerbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchCategoryHerbButton setFrame:CGRectMake(240, 48, 80, 44)];
    [searchCategoryHerbButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchCategoryHerbButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchCategoryHerbButton setShowsTouchWhenHighlighted:YES];
    [searchCategoryHerbButton setTag:kSearchTabCategoryHerb];
    [searchCategoryHerbButton addTarget:self action:@selector(searchCategoryButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchCategoryHerbButton];
    
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, kDisplayWidth, 323)];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setBackgroundColor:[UIColor clearColor]];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [self.view addSubview:tableView_];
    [tableView_ release];
    
    [self settingSearchAll];
}

/***************************************************************
 * 検索タブ押下時
 ***************************************************************/
- (void)searchCategoryButtonPushed:(UIButton *)searchCategoryButton {
    
    int category = [searchCategoryButton tag];
    [searchTabImageView setTag:category]; 
    
    NSString *imageName = nil;
    if (category == kSearchTabCategoryAll) {
        imageName = kSearchTabAllImageName;
        [self settingSearchAll];
    } else if (category == kSearchTabCategoryVege) {
        imageName = kSearchTabVegeImageName;
        [self settingSearchWithCategory:@"野菜、果物"];
    } else if (category == kSearchTabCategoryMeat) {
        imageName = kSearchTabMeatImageName;
        [self settingSearchWithCategory:@"魚、肉、ほか"];
    } else if (category == kSearchTabCategoryHerb) {
        imageName = kSearchTabHerbImageName;
        [self settingSearchWithCategory:@"生薬"];
    }
    
    [tableView_ reloadData];
    [tableView_ setContentOffset:CGPointMake(0, 0)];
    
    [searchTabImageView setImage:[UIImage imageNamed:imageName]];
}

/***************************************************************
 * カテゴリ検索
 ***************************************************************/
- (void)settingSearchWithCategory:(NSString *)category {
    PrintLog(@"{");
    [sectionArray removeAllObjects];
    
    NSArray *foodSectionArray = [NSArray arrayWithArray:[DatabaseUtility selectFoodSectionWithCategory:category]];
    NSMutableDictionary *searchNoDictionary = [[NSMutableDictionary alloc] init];
    int index = 0;
    for (FoodModel *foodModel in foodSectionArray) {
        FoodSectionEntity *foodSectionEntity = [[FoodSectionEntity alloc] init];
        [foodSectionEntity setFoodSearchNo:[foodModel foodSearchNo]];
        [foodSectionEntity setFoodName:[foodModel foodName]];
        [foodSectionEntity setCategory:[foodModel category]];
        [foodSectionEntity setFirstLetter:[foodModel firstLetter]];
        
        NSMutableArray *recipeCellArray = [[NSMutableArray alloc] init];
        [foodSectionEntity setRecipeCellArray:recipeCellArray];
        [recipeCellArray release];
        [searchNoDictionary setValue:[NSString stringWithFormat:@"%d", index] forKey:[NSString stringWithFormat:@"%d", [foodSectionEntity foodSearchNo]]];
        [sectionArray addObject:foodSectionEntity];
        [foodSectionEntity release];
        index++;
    }
    
    if ([sectionArray count] != 0) {
        NSArray *allRecipeCellArray = [NSArray arrayWithArray:[DatabaseUtility selectRecipeCellWithCategory:category]];    
        for (RecipeCellEntity *recipeCellEntity in allRecipeCellArray) {
            int index = [[searchNoDictionary objectForKey:[NSString stringWithFormat:@"%d", [recipeCellEntity searchNo]]] intValue];
            [[[sectionArray objectAtIndex:index] recipeCellArray] addObject:recipeCellEntity];
        }        
    }
    
    [searchNoDictionary release];
    PrintLog(@"}");
}

/***************************************************************
 * 全検索
 ***************************************************************/
- (void)settingSearchAll {
    PrintLog(@"{");
    [sectionArray removeAllObjects];
    
    NSArray *foodSectionArray = [NSArray arrayWithArray:[DatabaseUtility selectFoodSection]];
    NSMutableDictionary *searchNoDictionary = [[NSMutableDictionary alloc] init];
    int index = 0;
    for (FoodModel *foodModel in foodSectionArray) {
        FoodSectionEntity *foodSectionEntity = [[FoodSectionEntity alloc] init];
        [foodSectionEntity setFoodSearchNo:[foodModel foodSearchNo]];
        [foodSectionEntity setFoodName:[foodModel foodName]];
        [foodSectionEntity setCategory:[foodModel category]];
        [foodSectionEntity setFirstLetter:[foodModel firstLetter]];
        
        NSMutableArray *recipeCellArray = [[NSMutableArray alloc] init];
        [foodSectionEntity setRecipeCellArray:recipeCellArray];
        [recipeCellArray release];
        [sectionArray addObject:foodSectionEntity];
        [searchNoDictionary setValue:[NSString stringWithFormat:@"%d", index] forKey:[NSString stringWithFormat:@"%d", [foodSectionEntity foodSearchNo]]];
        [foodSectionEntity release];
        index++;
    }
    
    NSArray *allRecipeCellArray = [NSArray arrayWithArray:[DatabaseUtility selectRecipeCell]];
    for (RecipeCellEntity *recipeCellEntity in allRecipeCellArray) {
        int index = [[searchNoDictionary objectForKey:[NSString stringWithFormat:@"%d", [recipeCellEntity searchNo]]] intValue];
        [[[sectionArray objectAtIndex:index] recipeCellArray] addObject:recipeCellEntity];
    }

    [searchNoDictionary release];
    PrintLog(@"}");
}

#pragma mark -
#pragma mark View lifecycle
/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([searchTabImageView.image isEqual:[UIImage imageNamed:kSearchTabAllImageName]]) {
        [self settingSearchAll];
    } else if ([searchTabImageView.image isEqual:[UIImage imageNamed:kSearchTabVegeImageName]]) {
        [self settingSearchWithCategory:@"野菜、果物"];
    } else if ([searchTabImageView.image isEqual:[UIImage imageNamed:kSearchTabMeatImageName]]) {
        [self settingSearchWithCategory:@"魚、肉、ほか"];
    } else if ([searchTabImageView.image isEqual:[UIImage imageNamed:kSearchTabHerbImageName]]) {
        [self settingSearchWithCategory:@"生薬"];
    }
    
    [tableView_ reloadData];
    [tableView_ setContentOffset:CGPointMake(0, 0)];
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
    NSInteger sectionCount;
    
    if ([sectionArray count] == 0) {
        sectionCount = 1;
    } else {
        sectionCount = [sectionArray count];
    }
    
    return sectionCount;
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount;
    
    if ([sectionArray count] == 0) {
        rowCount = 1;
    } else {
        rowCount = [[[sectionArray objectAtIndex:section] recipeCellArray] count];
    }
    
    return rowCount;
}

/***************************************************************
 * セクション設定
 ***************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = nil;
    if ([sectionArray count] != 0) {
        sectionView = [[[UIView alloc] init] autorelease];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSectionBarImageName]];
        [imageView setFrame:CGRectMake(0, 0, 320, 23)];
        [sectionView addSubview:imageView];
        [imageView release];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDisplayWidth, 23)];
        if ([[[sectionArray objectAtIndex:section] foodName] isEqualToString:@"黒米"]) {
            [label setText:@"  黒米・黒豆"];
        } else {
            [label setText:[NSString stringWithFormat:@"  %@", [[sectionArray objectAtIndex:section] foodName]]];
        }
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:16]];
        [label setBackgroundColor:[UIColor clearColor]];
        [sectionView addSubview:label];
        [label release];
    }
    
    return sectionView;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([sectionArray count] != 0) {
        static NSString *CellIdentifier = @"Cell";
        
        RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

        FoodSectionEntity *foodSectionEntity = [sectionArray objectAtIndex:indexPath.section];
        RecipeCellEntity *recipeCellEntity = [[foodSectionEntity recipeCellArray] objectAtIndex:indexPath.row];

        // サムネイル画像設定
        if (recipeCellEntity.recipeNo <= kRecipeCount) {
            [cell.photoImageView setImage:[UIImage imageNamed:[recipeCellEntity thumbnailPhotoNo]]];
        } else {
            [cell.photoImageView setImage:[ImageUtil loadImage:[recipeCellEntity thumbnailPhotoNo]]];
        }
        
        [cell.costLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeCellEntity carbQty]]];
        [cell.timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeCellEntity time]]];
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

/***************************************************************
 * ターブルのインデクス
 ***************************************************************/
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray *indexArray;
    
    if ([sectionArray count] != 0) {
        indexArray = [[[NSArray alloc] initWithObjects:@"あ", @"か", @"さ", @"た", @"な", @"は", @"ま", @"や", @"ら", @"わ", nil] autorelease];
    } else {
        indexArray = nil;
    }
    
    return  indexArray;
}

/***************************************************************
 * インデクスタップ時
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSUInteger found = NSNotFound;
    while (found == NSNotFound && index >= 0) {
        found = [sectionArray indexOfObjectPassingTest:^(id element, NSUInteger idx, BOOL * stop){
            FoodSectionEntity *testFoodSectionEntity = (FoodSectionEntity *)element;
            
            NSArray *indexArray = [[NSArray alloc] initWithObjects:
                                   @"あ", @"い", @"う", @"え", @"お", 
                                   @"か", @"き", @"く", @"け", @"こ", 
                                   @"さ", @"し", @"す", @"せ", @"そ", 
                                   @"た", @"ち", @"つ", @"て", @"と", 
                                   @"な", @"に", @"ぬ", @"ね", @"の", 
                                   @"は", @"ひ", @"ふ", @"へ", @"ほ", 
                                   @"ま", @"み", @"む", @"め", @"も", 
                                   @"や", @"や", @"ゆ", @"ゆ", @"よ", 
                                   @"ら", @"り", @"る", @"れ", @"ろ", 
                                   @"わ", @"わ", @"を", @"を", @"ん", 
                                   nil];
            if ([testFoodSectionEntity.firstLetter isEqualToString:[indexArray objectAtIndex:(index * 5)]] ||
                [testFoodSectionEntity.firstLetter isEqualToString:[indexArray objectAtIndex:(index * 5) + 1]] ||
                [testFoodSectionEntity.firstLetter isEqualToString:[indexArray objectAtIndex:(index * 5) + 2]] ||
                [testFoodSectionEntity.firstLetter isEqualToString:[indexArray objectAtIndex:(index * 5) + 3]] ||
                [testFoodSectionEntity.firstLetter isEqualToString:[indexArray objectAtIndex:(index * 5) + 4]]) {
                *stop = YES;
            } else {
                *stop = NO;
            }
            [indexArray release];
            
            return *stop;
        }];
        
        index--;
    }
        
    if (found == NSNotFound) {
        return 0;
    } else {
        return found;
    }
}


#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecipeCellEntity *recipeCellEntity = [[[sectionArray objectAtIndex:indexPath.section] recipeCellArray] objectAtIndex:indexPath.row];
    RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:[recipeCellEntity recipeNo]];
    [recipeViewController setDelegate:self];
    [self.navigationController pushViewController:recipeViewController animated:YES];
    [recipeViewController release];
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
    [navigationBarTitleLabel setText:kNavigationBarTitleShokuzaiName];
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
    [sectionArray release];
    [super dealloc];
}



@end

