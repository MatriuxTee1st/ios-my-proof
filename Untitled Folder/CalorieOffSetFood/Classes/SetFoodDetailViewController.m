//
//  SetFoodDetailViewController.m
//  CalorieOffSetFood
//
//  Created by  on 12/06/29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetFoodDetailViewController.h"
#import "ImageUtil.h"

static CGFloat imageWidth = 280.f;
static CGFloat imageHeight = 308.f;
static CGFloat cellHeight = 88.0f;
static CGFloat inset = 10.f;
static CGFloat titleFontSize = 17.f;
static CGFloat fontSize = 14.f;
static CGFloat dotLineOffset = 12.f;

@implementation SetFoodDetailViewController

@synthesize setFoodArray;
@synthesize currentRow;
@synthesize currentSection;

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRecipeNo:(int)recipeNo {
    self = [super init];
    if (self) {
        recipeEntity = [[RecipeEntity alloc] init];
        cellArray = [[NSMutableArray alloc] init];
		
        // レシピ情報を取得し、格納
        RecipeEntity *resultRecipeEntity = [DatabaseUtility selectSetFoodDetail:recipeNo];
        [recipeEntity setRecipeNo:[resultRecipeEntity recipeNo]];
        [recipeEntity setRecipeName:[resultRecipeEntity recipeName]];
        [recipeEntity setCost:[resultRecipeEntity cost]];
        [recipeEntity setCalorie:[resultRecipeEntity calorie]];
        [recipeEntity setPhotoName:[resultRecipeEntity photoName]];
        [recipeEntity setCommentRecipe:[resultRecipeEntity commentRecipe]];
        
        relationalRecipeUtil = [[RelationalRecipeUtil alloc] init];
        [relationalRecipeUtil setDelegate:self];
        
		[cellArray removeAllObjects];
		[cellArray setArray:[DatabaseUtility selectSetRecipeArrayWithRecipeNo:recipeNo]];
    }
    return self;
}
/***************************************************************
 * メモリ警告時
 ***************************************************************/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/***************************************************************
 * メモリ解放
 ***************************************************************/
- (void)dealloc {
    [setFoodArray release], setFoodArray = nil;
    [navigationBarTitleLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    
    [self navigationBarSetting];
    
    maxSection = [setFoodArray count] -1;
    maxRow = [[[setFoodArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
    
    // Initialize backgroud view for transition animations.
    backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)];
    
    scrollView_ = [self setScrollViewContents];
    [backgroundView_ addSubview:scrollView_];
    
    [self.view addSubview:backgroundView_];
    [backgroundView_ release];
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.f, 0.f, kDisplayWidth - 160.f, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [navigationBarTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [navigationBarTitleLabel setNumberOfLines:0];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kNavigationBarTitleSetFoodDetailName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
	
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
    return setRecipeCount;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"%@", cellArray);

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
 * セクション設定
 ***************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[[UIView alloc] init] autorelease];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSectionBarImageName]];
    [imageView setFrame:CGRectMake(0, 0, 320, 23)];
    [sectionView addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 23)];
    [label setText:NSLocalizedString(@"定食メニュー", @"定食メニュー")];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    [label release];
    
    return sectionView;
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
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

/***************************************************************
 * スクロールビューの設定
 ***************************************************************/
- (UIScrollView *)setScrollViewContents {
	
	titleLabelSize = [[recipeEntity recipeName] sizeWithFont:[UIFont systemFontOfSize:titleFontSize]
										   constrainedToSize:CGSizeMake(imageWidth, 100.f)
											   lineBreakMode:UILineBreakModeWordWrap];
    
    descriptionLabelSize = [[recipeEntity commentRecipe] sizeWithFont:[UIFont systemFontOfSize:fontSize]
													constrainedToSize:CGSizeMake(imageWidth, 3000.f)
														lineBreakMode:UILineBreakModeCharacterWrap];

    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, 368.f)] autorelease];
    [scrollView setContentSize:CGSizeMake(kDisplayWidth, inset * 3 + imageHeight + descriptionLabelSize.height + dotLineOffset + cellHeight * 1 + 22.f)];
    
    // レシピ名
    UILabel *recipeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2, inset, imageWidth, titleLabelSize.height)];
	recipeTitleLabel.textAlignment = UITextAlignmentCenter;
    [recipeTitleLabel setBackgroundColor:[UIColor clearColor]];
	[recipeTitleLabel setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
	[recipeTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [recipeTitleLabel setText:[recipeEntity recipeName]];
    [recipeTitleLabel setTextColor:kColorRecipeName];
    [recipeTitleLabel setNumberOfLines:2];
    [scrollView addSubview:recipeTitleLabel];
    [recipeTitleLabel release];
    
    // 費用
    CGFloat costLabelY = titleLabelSize.height + inset * 2;
    UIImageView *costImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2 + 64, costLabelY, 25, 25)];
    [costImageView setImage:[UIImage imageNamed:kCostIconImageName]];
    [scrollView addSubview:costImageView];
    [costImageView release];
    
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2 + 88, costLabelY + 2, 66, 25)];
    [costLabel setBackgroundColor:[UIColor clearColor]];
    [costLabel setTextColor:kColorRecipeGreyText];
    [costLabel setText:[NSString stringWithFormat:@"%¥%d", [recipeEntity cost]]];
    [costLabel setFont:[UIFont systemFontOfSize:kTimeAndCalorieFontSize]];
    [scrollView addSubview:costLabel];
    [costLabel release];
    
    // カロリー
    UIImageView *calorieImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2 + 144, costLabelY, 25, 25)];
    [calorieImageView setImage:[UIImage imageNamed:kCalorieIconImageName]];
    [scrollView addSubview:calorieImageView];
    [calorieImageView release];

	UILabel *calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2 + 168, costLabelY + 2, 66, 25)];
    [calorieLabel setBackgroundColor:[UIColor clearColor]];
    [calorieLabel setTextColor:kColorRecipeGreyText];
    [calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeEntity calorie]]];
	[calorieLabel setFont:[UIFont systemFontOfSize:kTimeAndCalorieFontSize]];
    [scrollView addSubview:calorieLabel];
    [calorieLabel release];

    // 水平区切り線
    CGFloat imageViewY = costLabelY + 25 + dotLineOffset;
    UIImageView *dotLineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageViewY, kDisplayWidth, 1)];
    [dotLineImageView1 setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:dotLineImageView1];
    [dotLineImageView1 release];

    // 画像の設定
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2, imageViewY + dotLineOffset, imageWidth, imageHeight)];
    [imageView setImage:[UIImage imageNamed:[recipeEntity photoName]]];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [scrollView addSubview:imageView];
    [imageView release];
    
    // 説明テキストの設定
    CGFloat descriptionLabelY = imageViewY + imageHeight + dotLineOffset + dotLineOffset;
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2, descriptionLabelY, imageWidth, descriptionLabelSize.height)];
    [descriptionLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setText:[recipeEntity commentRecipe]];
    [scrollView addSubview:descriptionLabel];
    [descriptionLabel release];
    
    // おすすめテーブルの設定
    CGFloat tableViewY = descriptionLabelY + descriptionLabelSize.height + inset;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, tableViewY, kDisplayWidth, cellHeight * setRecipeCount + 22.f)];
    [tableView setSeparatorColor:kTableSeparatorColor];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setScrollEnabled:NO];
    [scrollView addSubview:tableView];
    [tableView release];
	
    return scrollView;
}

@end