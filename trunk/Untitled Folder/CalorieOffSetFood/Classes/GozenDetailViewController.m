//
//  GozenDetailViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GozenDetailViewController.h"

static CGFloat imageHeight = 150.f;
static CGFloat inset = 10.f;
static CGFloat cellHeight = 88.f;

@implementation GozenDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    PrintLog(@"[%@] {", CMD_STR);
    gozenRecipeCount = 2;

    [self navigationBarSetting];
    [[self view] setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];

    // Set gozen image.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageHeight * 4.f / 3.f) / 2,
                                                                           inset + kNavigationBarHeight,
                                                                           imageHeight * 4.f / 3.f,
                                                                           imageHeight)];
    [imageView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:imageView];
    [imageView release];

    // Set gozen explanation with proper height.
    NSString *tmp = [NSString stringWithFormat:@"ご膳の説明リードテキスト"];
    CGSize textSize = [tmp sizeWithFont:[UIFont systemFontOfSize:18.f] forWidth:300.f lineBreakMode:UILineBreakModeCharacterWrap];
    CGFloat textY = 2 * inset + kNavigationBarHeight + imageHeight;
    UILabel *leadText = [[UILabel alloc] initWithFrame:CGRectMake(inset, textY, kDisplayWidth - 2 * inset, textSize.height)];
    [leadText setText:tmp];
    [self.view addSubview:leadText];
    [leadText release];
    
    // Set table view.
    CGFloat tableViewY = 3 * inset + kNavigationBarHeight + imageHeight + textSize.height;
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0.f, tableViewY, kDisplayWidth, 412.f - tableViewY)];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [self.view addSubview:tableView_];
    [tableView_ release];
 
    PrintLog(@"[%@] }", CMD_STR);
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
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:kNavigationBarTitleGozenName];
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
    return gozenRecipeCount;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecipeCell";
    
    // Create new related recipe cell.
    RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
//    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    
    RecipeEntity *recipeEntity = [DatabaseUtility selectRecipeDataWithRecipeNo:1];
    [cell.photoImageView setImage:[UIImage imageNamed:[recipeEntity thumbnailPhotoNo]]];
    [cell.costLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeEntity carbQty]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeEntity time]]];
    [cell.calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeEntity calorie]]];
    [cell.recipeNameLabel setText:[recipeEntity recipeName]];   
    [cell.recipeNameLabel setFont:[UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize]];
    [cell.recipeNameLabel setNeedsDisplay];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    
    // Jump to related recipe setting delegate for transition method.
    RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:1];
    [recipeViewController setDelegate:self];
    [self.navigationController pushViewController:recipeViewController animated:YES];
    [recipeViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
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
    [label setText:[NSString stringWithFormat:@"＜ご膳レシピ＞"]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    [label release];
    
    return sectionView;
}

@end
