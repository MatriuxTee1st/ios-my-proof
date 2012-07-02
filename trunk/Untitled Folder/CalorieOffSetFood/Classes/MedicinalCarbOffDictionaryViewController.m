//
//  MedicinalCarbOffDictionaryViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "MedicinalCarbOffDictionaryViewController.h"

static CGFloat inset = 16.f;
static CGFloat cellHeight = 62.f;
static CGFloat leadTextHeight = 40.f;

@implementation MedicinalCarbOffDictionaryViewController


#pragma mark -
#pragma mark Initialization
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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navigationBarSetting];    
    
    // Create header based on text size.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, kNavigationBarHeight + inset, kDisplayWidth - 2 * inset, leadTextHeight)];
    [headerLabel setFont:[UIFont systemFontOfSize:13.f]];
    [headerLabel setText:kLeadMedicinalCarbOffDictionary];
    [headerLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [headerLabel setNumberOfLines:0];
    [self.view addSubview:headerLabel];
    [headerLabel release];
    
    // Get cooking dictionary array from plist.
    medicinalCarbOffDictionaryArray = [[NSArray alloc] initWithArray:[Utility getMedicinalCarbOffDictionaryArray]];
    
    // Set table view.
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 2 * inset + leadTextHeight, kDisplayWidth, 368.f - 2 * inset - leadTextHeight)];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tableView_];
    [tableView_ release];
    
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
    [navigationBarTitleLabel setText:kNavigationBarTitleYakuzenjitenName];
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


#pragma mark -
#pragma mark Table view data source

/***************************************************************
 * セクション数
 ***************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [medicinalCarbOffDictionaryArray count];
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[medicinalCarbOffDictionaryArray objectAtIndex:section] valueForKey:@"CELL"] count];
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
    [label setText:[NSString stringWithFormat:@"  %@", [[medicinalCarbOffDictionaryArray objectAtIndex:section] valueForKey:@"SECTION"]]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    [label release];
    
    return sectionView;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *dictionary = [[[medicinalCarbOffDictionaryArray objectAtIndex:indexPath.section] valueForKey:@"CELL"] objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"  %@%@", [dictionary valueForKey:@"TITLE"], [dictionary valueForKey:@"RUBY"]]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.f]];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kArrowIconOffsetX, 
                                                                                floorf((cellHeight - kArrowIconSizeHeight) / 2.f),
                                                                                kArrowIconSizeWidth, 
                                                                                kArrowIconSizeHeight)];
    [arrowImageView setImage:[UIImage imageNamed:kTopArrowImageName]];
    [[cell contentView] addSubview:arrowImageView];
    [arrowImageView release];
    
    return cell;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicinalCarbOffDictionaryDetailViewController *medicinalCarbOffDictionaryDetailViewController = 
    [[MedicinalCarbOffDictionaryDetailViewController alloc] init];
    [medicinalCarbOffDictionaryDetailViewController setCurrentRow:[indexPath row]];
    [medicinalCarbOffDictionaryDetailViewController setCurrentSection:[indexPath section]];
    [medicinalCarbOffDictionaryDetailViewController setMedicinalCarbOffDictionaryArray:medicinalCarbOffDictionaryArray];
    [self.navigationController pushViewController:medicinalCarbOffDictionaryDetailViewController animated:YES];
    [medicinalCarbOffDictionaryDetailViewController release];
    
    [tableView_ deselectRowAtIndexPath:indexPath animated:NO];
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
    [medicinalCarbOffDictionaryArray release], medicinalCarbOffDictionaryArray = nil;
    [super dealloc];
}


@end

