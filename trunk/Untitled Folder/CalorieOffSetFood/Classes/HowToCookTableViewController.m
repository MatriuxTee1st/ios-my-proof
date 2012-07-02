//
//  HowToCookTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/20.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "HowToCookTableViewController.h"
#import "Utility.h"
#import "NSData+Base64.h"
#import "MedicinalCarbOffAppDelegate.h"

#define kSectionFontSize 18
#define kSubSectionFontSize 15
#define kTextFontSize 14

static NSInteger sampleLabelTag = 100;

@implementation HowToCookTableViewController
@synthesize delegate;
@synthesize recipeEntity;
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init{
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
    float offsetHeight = 88.0f - 9.0f;
    float sizeHeight = kDisplayHeight - kTabBarHeight - kStatusBarHeight - offsetHeight;
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, offsetHeight, kDisplayWidth, sizeHeight)] autorelease];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, sizeHeight)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollView];
    
    // 点線
    UIImageView *mainIngredientUpperDotLineImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, kDisplayWidth, 1)];
    [mainIngredientUpperDotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:mainIngredientUpperDotLineImageView];
    [mainIngredientUpperDotLineImageView release];
    
    y = 12 + [mainIngredientUpperDotLineImageView frame].origin.y + [mainIngredientUpperDotLineImageView frame].size.height;
    
    // 材料見出し
    UILabel *mainIngredientTitleLabel = [[UILabel alloc] init];
    NSString *mainIngredientTitle = [NSString stringWithFormat:@"材料（%d人分）", [recipeEntity person]];
    UIFont *mainIngredientTitleFont = [UIFont boldSystemFontOfSize:kSectionFontSize];
    CGSize mainIngredientTitleLabelSize = [mainIngredientTitle sizeWithFont:mainIngredientTitleFont
                                                          constrainedToSize:CGSizeMake(290, 800)];
    [mainIngredientTitleLabel setFrame:CGRectMake(20,
                                                  y,
                                                  mainIngredientTitleLabelSize.width,
                                                  mainIngredientTitleLabelSize.height)];
    [mainIngredientTitleLabel setText:mainIngredientTitle];
    [mainIngredientTitleLabel setFont:mainIngredientTitleFont];
    [mainIngredientTitleLabel setTextColor:kHowToCookSectionFontColor];
    [scrollView addSubview:mainIngredientTitleLabel];
    [mainIngredientTitleLabel release];
    
    // 材料
    y = 6 + [mainIngredientTitleLabel frame].origin.y + [mainIngredientTitleLabel frame].size.height;
    for (MainIngredientEntity *mainIngredientEntity in [recipeEntity mainIngredientEntityArray]) {
        UILabel *mainIngredientLabel = [[UILabel alloc] init];
        NSString *mainIngredient = [NSString stringWithFormat:@"%@  %@", [mainIngredientEntity mainIngredientName], [mainIngredientEntity mainIngredientQty]];
        UIFont *mainIngredientFont = [UIFont systemFontOfSize:kTextFontSize];
        CGSize mainIngredientLabelSize = [mainIngredient sizeWithFont:mainIngredientFont
                                                    constrainedToSize:CGSizeMake(270, 800)];
        [mainIngredientLabel setFrame:CGRectMake(40,
                                                 y, 
                                                 mainIngredientLabelSize.width,
                                                 mainIngredientLabelSize.height)];
        [mainIngredientLabel setNumberOfLines:0];
        [mainIngredientLabel setText:mainIngredient];
        [mainIngredientLabel setFont:mainIngredientFont];
        [mainIngredientLabel sizeThatFits:mainIngredientLabelSize];
        [scrollView addSubview:mainIngredientLabel];
        [mainIngredientLabel release];

        // 点
        UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 20, 20)];
        [elementLabel setFont:mainIngredientFont];
        [elementLabel setText:@"・"];
        [scrollView addSubview:elementLabel];
        [elementLabel release];
        
        y = [mainIngredientLabel frame].origin.y + [mainIngredientLabel frame].size.height;
    }
    
    // 調味料
    if ([[recipeEntity sauceAEntityArray] count] > 0) {
        [self setupSauceWithSauceArray:[recipeEntity sauceAEntityArray] title:@"A"];
    }
    if ([[recipeEntity sauceBEntityArray] count] > 0) {
        [self setupSauceWithSauceArray:[recipeEntity sauceBEntityArray] title:@"B"];
    }
    if ([[recipeEntity sauceCEntityArray] count] > 0) {
        [self setupSauceWithSauceArray:[recipeEntity sauceCEntityArray] title:@"C"];
    }
    
    // 点線
    UIImageView *processTitleUpperDotLineImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12+y, kDisplayWidth, 1)];
    [processTitleUpperDotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:processTitleUpperDotLineImageView];
    [processTitleUpperDotLineImageView release];
    
    y = 12 + [processTitleUpperDotLineImageView frame].origin.y + [processTitleUpperDotLineImageView frame].size.height;
    
    

    // 作り方見出し
    UILabel *processTitleLabel = [[UILabel alloc] init];
    NSString *processTitle = [NSString stringWithFormat:@"作り方"];
    UIFont *processTitleFont = [UIFont boldSystemFontOfSize:kSectionFontSize];
    CGSize processTitleLabelSize = [processTitle sizeWithFont:processTitleFont
                                            constrainedToSize:CGSizeMake(290, 800)];
    [processTitleLabel setFrame:CGRectMake(20,
                                           y,
                                           processTitleLabelSize.width,
                                           processTitleLabelSize.height)];
    [processTitleLabel setText:processTitle];
    [processTitleLabel setFont:processTitleFont];
    [processTitleLabel setTextColor:kHowToCookSectionFontColor];
    [scrollView addSubview:processTitleLabel];
    [processTitleLabel release];
    
    
    // 作り方
    y = 6 + [processTitleLabel frame].origin.y + [processTitleLabel frame].size.height;
    int index = 0;
    for (NSString *processText in [recipeEntity processArray]) {
        index++;
        NSString *process = [NSString stringWithFormat:@"%@", processText];
        UILabel *processLabel = [[UILabel alloc] init];
        UIFont *processFont = [UIFont systemFontOfSize:kTextFontSize];
        CGSize processLabelSize = [process sizeWithFont:processFont
                                      constrainedToSize:CGSizeMake(270, 800)];
        [processLabel setFrame:CGRectMake(40,
                                          y, 
                                          processLabelSize.width,
                                          processLabelSize.height)];
        [processLabel setNumberOfLines:0];
        [processLabel setText:process];
        [processLabel setFont:processFont];
        [processLabel sizeThatFits:processLabelSize];
        [scrollView addSubview:processLabel];
        [processLabel release];
        
        // 点
        UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 20, 20)];
        [elementLabel setFont:processFont];
        [elementLabel setText:[NSString stringWithFormat:@"%d.", index]];
        [scrollView addSubview:elementLabel];
        [elementLabel release];
        
        y = [processLabel frame].origin.y + [processLabel frame].size.height + 10;
        
    }     
    
    // 点線
    UIImageView *commentTitleUpperDotLineImageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2+y, kDisplayWidth, 1)];
    [commentTitleUpperDotLineImageView setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:commentTitleUpperDotLineImageView];
    [commentTitleUpperDotLineImageView release];
    
    y = 12 + [commentTitleUpperDotLineImageView frame].origin.y + [commentTitleUpperDotLineImageView frame].size.height;

    
    // 効能見出し
    UILabel *commentTitleLabel = [[UILabel alloc] init];
    NSString *commentTitle = [NSString stringWithFormat:@"効能"];
    UIFont *commentTitleFont = [UIFont boldSystemFontOfSize:kSectionFontSize];
    CGSize commentTitleLabelSize = [commentTitle sizeWithFont:commentTitleFont
                                            constrainedToSize:CGSizeMake(290, 800)];
    [commentTitleLabel setFrame:CGRectMake(20,
                                           y,
                                           commentTitleLabelSize.width,
                                           commentTitleLabelSize.height)];
    [commentTitleLabel setText:commentTitle];
    [commentTitleLabel setFont:commentTitleFont];
    [commentTitleLabel setTextColor:kHowToCookSectionFontColor];
    [scrollView addSubview:commentTitleLabel];
    [commentTitleLabel release];
    
    y = 12 + [commentTitleLabel frame].origin.y + [commentTitleLabel frame].size.height;
    
    // 効能
    UILabel *commentLabel = [[UILabel alloc] init];
    NSString *comment = [recipeEntity commentRecipe];
    UIFont *commentFont = [UIFont systemFontOfSize:kTextFontSize];
    CGSize commentLabelSize = [comment sizeWithFont:commentFont
                                       constrainedToSize:CGSizeMake(290, 800)];
    [commentLabel setFrame:CGRectMake(20,
                                      y,
                                      commentLabelSize.width,
                                      commentLabelSize.height)];
    [commentLabel setNumberOfLines:0];
    [commentLabel setText:comment];
    [commentLabel setFont:commentFont];
    [commentLabel setTextColor:[UIColor blackColor]];
    [commentLabel sizeThatFits:commentLabelSize];
    [scrollView addSubview:commentLabel];
    [commentLabel release];

    y = [commentLabel frame].origin.y + [commentLabel frame].size.height + 10;
    
    // 関連レシピ
    [self setupRelationalRecipeTable];
    
    [scrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
    
    [scrollView release];
}

- (void)setupRelationalRecipeTable {
    // 関連レシピ
    if (!tableView_) {
        if ([[recipeEntity relationalRecipeCellEntityArray] count] > 0) {
            tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kDisplayWidth, 22 + 88*[[recipeEntity relationalRecipeCellEntityArray] count])];
            [tableView_ setDelegate:self];
            [tableView_ setDataSource:self];
            [tableView_ setBackgroundColor:[UIColor clearColor]];
            [tableView_ setSeparatorColor:kTableSeparatorColor];
            [tableView_ setScrollEnabled:NO];
            [self.view addSubview:tableView_];
            [tableView_ release];
            
            [scrollView addSubview:tableView_];
            
            y = [tableView_ frame].origin.y + [tableView_ frame].size.height;        
            
            [scrollView setContentSize:CGSizeMake(kDisplayWidth, y)];
        }
    } else {
        [tableView_ reloadData];
    }
}

/*****************************************************************************
 * プロダクト詳細ページに遷移
 *****************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            MedicinalCarbOffAppDelegate *appDelegate = (MedicinalCarbOffAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate goToProduct:newProductId];
            PrintLog(@"TheProductId: %d", newProductId);
            break;
        }
        default:
            break;
    }
}

/***************************************************************
 * 調味料
 ***************************************************************/
- (void)setupSauceWithSauceArray:(NSArray *)array title:(NSString *)title {
    // 調味料見出し
    UILabel *sauceTitleLabel = [[UILabel alloc] init];
    NSString *sauceTitle = [NSString stringWithFormat:@"【調味料%@】", title];
    UIFont *sauceTitleFont = [UIFont systemFontOfSize:kSubSectionFontSize];
    CGSize sauceTitleLabelSize = [sauceTitle sizeWithFont:sauceTitleFont
                                          constrainedToSize:CGSizeMake(290, 800)];
    [sauceTitleLabel setFrame:CGRectMake(20,
                                         8 + y,
                                         sauceTitleLabelSize.width,
                                         sauceTitleLabelSize.height)];
    [sauceTitleLabel setText:sauceTitle];
    [sauceTitleLabel setFont:sauceTitleFont];
    [sauceTitleLabel setTextColor:kHowToCookSubSectionFontColor];
    [scrollView addSubview:sauceTitleLabel];
    [sauceTitleLabel release];
    
    // 調味料
    y = 6 + [sauceTitleLabel frame].origin.y + [sauceTitleLabel frame].size.height;
    for (SauceEntity *sauceEntity in array) {
        UILabel *sauceLabel = [[UILabel alloc] init];
        NSString *sauce = [NSString stringWithFormat:@"%@  %@", [sauceEntity sauceName], [sauceEntity sauceQty]];
        UIFont *sauceFont = [UIFont systemFontOfSize:kTextFontSize];
        CGSize sauceLabelSize = [sauce sizeWithFont:sauceFont
                                  constrainedToSize:CGSizeMake(270, 800)];
        [sauceLabel setFrame:CGRectMake(40,
                                        y, 
                                        sauceLabelSize.width,
                                        sauceLabelSize.height)];
        [sauceLabel setNumberOfLines:0];
        [sauceLabel setText:sauce];
        [sauceLabel setFont:sauceFont];
        [sauceLabel sizeThatFits:sauceLabelSize];
        [scrollView addSubview:sauceLabel];
        [sauceLabel release];

        // 点
        UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 20, 20)];
        [elementLabel setFont:sauceFont];
        [elementLabel setText:@"・"];
        [scrollView addSubview:elementLabel];
        [elementLabel release];
        
        y = [sauceLabel frame].origin.y + [sauceLabel frame].size.height;
        
    }     
}

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
    return [[recipeEntity relationalRecipeCellEntityArray] count];
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
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
    
    RecipeCellEntity *recipeCellEntity = [[recipeEntity relationalRecipeCellEntityArray] objectAtIndex:indexPath.row];
    
    // FIXME!!!
    UILabel *sampleLabel= (UILabel *)[cell viewWithTag:sampleLabelTag];
    if ([recipeCellEntity recipeNo] > kRecipeCount) {
        [sampleLabel setHidden:[DatabaseUtility checkDoesRecipeExist:[recipeCellEntity recipeNo]]];
    } else {
        [sampleLabel setHidden:YES];
    }
    
    // サムネイル画像設定
    if ([recipeCellEntity recipeNo] > kRecipeCount) {
        if (![[recipeCellEntity thumbnailPhotoNo] isEqualToString:@""]) {
            UIImage *recipeImage = [UIImage imageWithData:[NSData dataWithBase64EncodedString:[recipeCellEntity thumbnailPhotoNo]]];
            [cell.photoImageView setImage:recipeImage];
        }
    } else {
        [cell.photoImageView setImage:[UIImage imageNamed:[recipeCellEntity thumbnailPhotoNo]]];
        PrintLog(@"[セル表示] thumbnail = %@", [recipeCellEntity thumbnailPhotoNo]);
    }
    
    // Set addon label
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
    
    [cell.costLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeCellEntity carbQty]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeCellEntity time]]];
    [cell.calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeCellEntity calorie]]];
    
    NSString *recipeName = [recipeCellEntity recipeName];
    UIFont *recipeNameFont = [UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize];
    [cell.recipeNameLabel setText:recipeName];   
    [cell.recipeNameLabel setFont:recipeNameFont];
    [cell.recipeNameLabel setNeedsDisplay];
    
    return cell;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
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
    [label setText:NSLocalizedString(@"【関連レシピ】", @"【関連レシピ】")];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecipeCellEntity *entity = [[recipeEntity relationalRecipeCellEntityArray] objectAtIndex:indexPath.row];
    UILabel *sampleLabel= (UILabel *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:sampleLabelTag];
    if ([entity recipeNo] > kRecipeCount && ![sampleLabel isHidden]) {
        newProductId = [entity productId];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新レシピ購入"
                                                            message:@"このレシピはレシピストアで購入できます。今すぐレシピストアに移動しますか？"
                                                           delegate:self
                                                  cancelButtonTitle:@"いいえ"
                                                  otherButtonTitles:@"レシピストア", nil];
        [alertView show];
        [alertView release];
    } else {
        [self.delegate selectedRelativeRecipeCellWithRecipeNo:[entity recipeNo]];
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
    PrintLog(@"");
    [recipeEntity release];
    [delegate release];
    [super dealloc];
}

@end
