//
//  BookmarkViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/05.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "BookmarkViewController.h"
#import "ImageUtil.h"


@implementation BookmarkViewController
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

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
    
    tableView_= [[UITableView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f) style:UITableViewStylePlain];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [[self view] addSubview:tableView_];
    [tableView_ release];
    
}

/***************************************************************
 * ビュー表示時
 * ・テーブルリロード
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    PrintLog(@"{");
    [super viewWillAppear:animated];
    favoritesList_ = [[NSArray alloc] initWithArray:[DatabaseUtility selectFavoritesData]];
    [tableView_ reloadData];
    PrintLog(@"}");
}

/***************************************************************
 * ビュー非表示時
 ***************************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    if (favoritesList_ != nil) {
        [favoritesList_ release], favoritesList_ = nil;
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
    [super dealloc];
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
    NSInteger rowCount = [favoritesList_ count];
    if (rowCount == 0) {
        rowCount = 1;
    }
    return rowCount;
}


/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RecipeCell";
    
    RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([favoritesList_ count] != 0) {
        [cell setUserInteractionEnabled:YES];
        [cell.textLabel setHidden:YES];
        [cell.photoImageView setHidden:NO];
        [cell.timeLabel setHidden:NO];
        [cell.calorieLabel setHidden:NO];
        [cell.recipeNameLabel setHidden:NO];
        RecipeCellEntity *recipeCellEntity = [favoritesList_ objectAtIndex:indexPath.row];
        
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
    } else {
        [cell setUserInteractionEnabled:NO];
        [cell.textLabel setHidden:NO];
        [cell.textLabel setEnabled:NO];
        [cell.photoImageView setHidden:YES];
        [cell.timeLabel setHidden:YES];
        [cell.calorieLabel setHidden:YES];
        [cell.recipeNameLabel setHidden:YES];
        [cell.textLabel setText:NSLocalizedString(@"お気に入り未登録", @"お気に入り未登録")];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:22.f]];
        [cell.addonImageView setHidden:YES];
    }
    
    return cell;
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
    [navigationBarTitleLabel setText:kNavigationBarTitleOkiniiriName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
}

#pragma mark - Table view delegate

/***************************************************************
 * セル選択時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCellEntity *recipeCellEntity = [favoritesList_ objectAtIndex:indexPath.row];
    RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:[recipeCellEntity recipeNo]];
    [recipeViewController setDelegate:self];
    [self.navigationController pushViewController:recipeViewController animated:YES];
    [recipeViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.f;
}


@end
