//
//  FoodDictionaryDetailViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/21.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FoodDictionaryDetailViewController.h"
#import "ImageUtil.h"

static CGFloat imageWidth = 280.f;
static CGFloat imageHeight = 187.f;
static CGFloat cellHeight = 88.0f;
static CGFloat inset = 10.f;
static CGFloat fontSize = 14.f;
static CGFloat dotLineOffset = 12.f;

@implementation FoodDictionaryDetailViewController

@synthesize foodDictionaryArray;
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
    [foodDictionaryArray release], foodDictionaryArray = nil;
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
    
    maxSection = [foodDictionaryArray count] -1;
    maxRow = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
    
    // Initialize backgroud view for transition animations.
    backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, kDisplayWidth, 368.f)];
    
    scrollView_ = [self setScrollViewContents];
    [backgroundView_ addSubview:scrollView_];
    
    [self.view addSubview:backgroundView_];
    [backgroundView_ release];
    
    CGFloat buttonWidth = 44.f;
    
    // Set next button properties.
    nextIngredientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextIngredientButton setExclusiveTouch:YES];
    [nextIngredientButton setFrame:CGRectMake(kDisplayWidth - buttonWidth, 0, buttonWidth, kNavigationBarHeight)];
    [nextIngredientButton setImage:[UIImage imageNamed:kIconRightArrowImageName] forState:UIControlStateNormal];
    [nextIngredientButton addTarget:self
                         action:@selector(nextIngredient)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextIngredientButton];
    
    // Set previous button properties.
    previousIngredientButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousIngredientButton setExclusiveTouch:YES];
    [previousIngredientButton setFrame:CGRectMake(kDisplayWidth - 2 * buttonWidth, 0, buttonWidth, kNavigationBarHeight)];
    [previousIngredientButton setImage:[UIImage imageNamed:kIconLeftArrowImageName] forState:UIControlStateNormal];
    [previousIngredientButton addTarget:self
                         action:@selector(previousIngredient)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousIngredientButton];
    
    // Disable left button if first ingredient in the list
    if (currentRow == 0 && currentSection == 0) {
        [previousIngredientButton setEnabled:NO];
    }
    
    // Disable right button if last ingredient in the list
    if (currentRow == maxRow && currentSection == maxSection) {
        [nextIngredientButton setEnabled:NO];
    }
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
    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.f, 0.f, kDisplayWidth - 160.f, kNavigationBarHeight)];
    [navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navigationBarTitleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [navigationBarTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [navigationBarTitleLabel setNumberOfLines:0];
    [navigationBarTitleLabel setShadowColor:[UIColor colorWithWhite:.7 alpha:1]];
    [navigationBarTitleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
    [navigationBarTitleLabel setText:[dictionary objectForKey:@"TITLE"]];
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
    return relatedRecipeCount;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FoodDictionaryCell";
    
    // Create new related recipe cell.
    RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        
    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    
    RecipeEntity *recipeEntity = [DatabaseUtility selectRecipeDataWithRecipeNo:[[[dictionary objectForKey:@"RELATED"] objectAtIndex:[indexPath row]] intValue]];
    if (recipeEntity.recipeNo <= kRecipeCount) {
        [cell.photoImageView setImage:[UIImage imageNamed:[recipeEntity thumbnailPhotoNo]]];
    } else {
        [cell.photoImageView setImage:[ImageUtil loadImage:[recipeEntity thumbnailPhotoNo]]];
    }
    [cell.costLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeEntity carbQty]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeEntity time]]];
    [cell.calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeEntity calorie]]];
    [cell.recipeNameLabel setText:[recipeEntity recipeName]];   
    [cell.recipeNameLabel setFont:[UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize]];
    [cell.recipeNameLabel setNeedsDisplay];
        
    return cell;
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
    [label setText:NSLocalizedString(@"【この食材を使ったおすすめレシピ】", @"【この食材を使ったおすすめレシピ】")];
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
    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];

    // Jump to related recipe setting delegate for transition method.
    RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithRecipeNo:[[[dictionary objectForKey:@"RELATED"] objectAtIndex:[indexPath row]] intValue]];
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
 * スクロールビューの設定
 ***************************************************************/
- (UIScrollView *)setScrollViewContents {
    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
    relatedRecipeCount = [[dictionary objectForKey:@"RELATED"] count];
    descriptionLabelSize = [[dictionary objectForKey:@"CONTENTS"] sizeWithFont:[UIFont systemFontOfSize:fontSize]
                                                             constrainedToSize:CGSizeMake(imageWidth, 3000.f)
                                                                 lineBreakMode:UILineBreakModeCharacterWrap];
    
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDisplayWidth, 368.f)] autorelease];
    [scrollView setContentSize:CGSizeMake(kDisplayWidth, inset * 3 + imageHeight + descriptionLabelSize.height + dotLineOffset + cellHeight * relatedRecipeCount + 22.f)];
    
    // 画像の設定
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2, inset, imageWidth, imageHeight)];
    [imageView setImage:[UIImage imageNamed:[dictionary objectForKey:@"PHOTO"]]];
    [imageView setBackgroundColor:[UIColor blackColor]];
    [scrollView addSubview:imageView];
    [imageView release];
    
    // 水平区切り線    
    UIImageView *dotLineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageHeight + inset * 2, kDisplayWidth, 1)];
    [dotLineImageView1 setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:dotLineImageView1];
    [dotLineImageView1 release];
    
    // 説明テキストの設定
    CGFloat descriptionLabelY = imageHeight + inset * 2 + dotLineOffset;
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDisplayWidth - imageWidth) / 2, descriptionLabelY, imageWidth, descriptionLabelSize.height)];
    [descriptionLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [descriptionLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setText:[dictionary objectForKey:@"CONTENTS"]];
    [scrollView addSubview:descriptionLabel];
    [descriptionLabel release];
    
    // おすすめテーブルの設定
    CGFloat tableViewY = descriptionLabelY + descriptionLabelSize.height + inset;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, tableViewY, kDisplayWidth, cellHeight * relatedRecipeCount + 22.f)];
    [tableView setSeparatorColor:kTableSeparatorColor];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setScrollEnabled:NO];
    [scrollView addSubview:tableView];
    [tableView release];

    return scrollView;
}
                                
#pragma mark - Private Methods

/***************************************************************
 * 前の食材に進む
 ***************************************************************/
- (void)previousIngredient {
    // If the current ingredient is not the first ingredient in the list, go to previous with animation.
    if (!(currentRow == 0 && currentSection == 0)) {
        // Update current row and section accordingly.
        if (currentRow == 0) {
            currentSection--;
            maxRow = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
            currentRow = maxRow;
        } else {
            currentRow--;
        }
        
        // Set navigation bar title
        NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
        [navigationBarTitleLabel setText:[dictionary objectForKey:@"TITLE"]];
    
        // Reload view data
        [scrollView_ removeFromSuperview];
        scrollView_ = [self setScrollViewContents];
        [backgroundView_ addSubview:scrollView_];
        
        // Perform animation
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromLeft];
        [transition setTimingFunction:UIViewAnimationCurveEaseInOut];
        [transition setDuration:0.3];
        
        [[backgroundView_ layer] addAnimation:transition forKey:@"newScrollView"];
    }
    
    // Disable left button if first ingredient in the list
    if (currentRow == 0 && currentSection == 0) {
        [previousIngredientButton setEnabled:NO];
    } else {
        [previousIngredientButton setEnabled:YES];
    }
    
    // Disable right button if last ingredient in the list
    if (currentRow == maxRow && currentSection == maxSection) {
        [nextIngredientButton setEnabled:NO];
    } else {
        [nextIngredientButton setEnabled:YES];
    }
}

/***************************************************************
 * 次の食材に進む
 ***************************************************************/
- (void)nextIngredient {
    // If the current ingredient is not the last ingredient in the list, go to next with animation.
    if (!(currentRow == maxRow && currentSection == maxSection)) {
        // Update current row and section accordingly.
        if (currentRow == maxRow) {
            currentRow = 0;
            currentSection++;
            maxRow = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] count] - 1;
        } else {
            currentRow++;
        }
        
        // Set navigation bar title
        NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:currentSection] valueForKey:@"CELL"] objectAtIndex:currentRow];
        [navigationBarTitleLabel setText:[dictionary objectForKey:@"TITLE"]];
        
        // Reload view data
        [scrollView_ removeFromSuperview];
        scrollView_ = [self setScrollViewContents];
        [backgroundView_ addSubview:scrollView_];
        
        // Perform animation
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
        [transition setTimingFunction:UIViewAnimationCurveEaseInOut];
        [transition setDuration:0.3];
        
        [[backgroundView_ layer] addAnimation:transition forKey:@"newScrollView"];
    }
    
    // Disable left button if first ingredient in the list
    if (currentRow == 0 && currentSection == 0) {
        [previousIngredientButton setEnabled:NO];
    } else {
        [previousIngredientButton setEnabled:YES];
    }
    
    // Disable right button if last ingredient in the list
    if (currentRow == maxRow && currentSection == maxSection) {
        [nextIngredientButton setEnabled:NO];
    } else {
        [nextIngredientButton setEnabled:YES];
    }
}

@end
