//
//  FoodDictionaryViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "FoodDictionaryViewController.h"

static CGFloat inset = 15.f;
static CGFloat cellHeight = 62.f;

@interface FoodDictionaryViewController ()

- (UIView *)addFooter;

@end

@implementation FoodDictionaryViewController

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
    
    // Create header title.
    UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset,  kNavigationBarHeight + 10.f, kDisplayWidth - 2 * inset, 20.f)];
    [headerTitleLabel setFont:[UIFont boldSystemFontOfSize:13.f]];
    [headerTitleLabel setTextColor:kColorRedTitle];
    [headerTitleLabel setText:kLeadFoodDictionaryTitle];
    [headerTitleLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [headerTitleLabel setNumberOfLines:0];
    [self.view addSubview:headerTitleLabel];
    [headerTitleLabel release];
    
    // Create header content.
    UILabel *headerContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset,  kNavigationBarHeight + 30.f, kDisplayWidth - 2 * inset, 80.f)];
    [headerContentLabel setFont:[UIFont systemFontOfSize:13.f]];
    [headerContentLabel setText:kLeadFoodDictionaryContent];
    [headerContentLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [headerContentLabel setNumberOfLines:0];
    [self.view addSubview:headerContentLabel];
    [headerContentLabel release];
    
    // Get food dictionary array from plist.
    foodDictionaryArray = [[NSArray alloc] initWithArray:[Utility getFoodDictionaryArray]];
    
    // Set table view.
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight + 116.f, kDisplayWidth, 252.f)];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setTableFooterView:[self addFooter]];
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
    [navigationBarTitleLabel setText:kNavigationBarTitleShokuzaijitenName];
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
 * nameでラベルを返す
 ***************************************************************/
- (UILabel *)textLabelWithY:(CGFloat *)y font:(UIFont *)font forName:(NSString *)name {
    CGSize size = [[NSString stringWithFormat:@"%@", name]
                   sizeWithFont:font
                   constrainedToSize:CGSizeMake(285.f, 4000.f)
                   lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(inset, *y, size.width, size.height)] autorelease];
    [label setText:[NSString stringWithFormat:@"%@", name]];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeCharacterWrap];
    
    *y += size.height;
    
    return label;
}

/***************************************************************
 * フッターついか
 ***************************************************************/
- (UIView *)addFooter {
    
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kDisplayWidth, 112)] autorelease];
    
    CGFloat y = 10;
    
    // Set leadSupervisor4 label
    UILabel *leadSupervisor4Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor4];
    [leadSupervisor4Label setCenter:CGPointMake(leadSupervisor4Label.center.x - 6, leadSupervisor4Label.center.y)];
    [leadSupervisor4Label setTextColor:[UIColor redColor]];
    [footerView addSubview:leadSupervisor4Label];
    
    // Old start
    //    y += 6;
    //    
    //    // Set leadSupervisor5 label
    //    UILabel *leadSupervisor5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor5];
    //    [leadSupervisor5Label setTextColor:[UIColor blackColor]];
    //    [footerView addSubview:leadSupervisor5Label];
    //    
    //    // Set leadSupervisor6 label
    //    UILabel *leadSupervisor6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor6];
    //    [leadSupervisor6Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    //    [footerView addSubview:leadSupervisor6Label];
    //    
    //    // Set leadSupervisor7 label
    //    UILabel *leadSupervisor7Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor7];
    //    [leadSupervisor7Label setCenter:CGPointMake(leadSupervisor7Label.center.x + 8, leadSupervisor7Label.center.y)];
    //    [leadSupervisor7Label setTextColor:[UIColor redColor]];
    //    [footerView addSubview:leadSupervisor7Label];
    //    
    //    y += 6;
    //    
    //    // Set leadSupervisor8 label
    //    UILabel *leadSupervisor8Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor8];
    //    [leadSupervisor8Label setTextColor:[UIColor blackColor]];
    //    [footerView addSubview:leadSupervisor8Label];
    //    
    //    // Set leadSupervisor9 label
    //    UILabel *leadSupervisor9Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor9];
    //    [leadSupervisor9Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    //    [footerView addSubview:leadSupervisor9Label];
    //    
    //    // Set leadSupervisor10 label
    //    UILabel *leadSupervisor10Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor10];
    //    [leadSupervisor10Label setCenter:CGPointMake(leadSupervisor10Label.center.x + 8, leadSupervisor10Label.center.y)];
    //    [leadSupervisor10Label setTextColor:[UIColor redColor]];
    //    [footerView addSubview:leadSupervisor10Label];
    // Old end
    
    // New start
    y += 6;
    
    // Set leadSupervisor7 label
    CGSize size7 = [kLeadConstitutionDiagnosisSupervisor7 sizeWithFont:[UIFont systemFontOfSize:13]];
    UILabel *leadSupervisor7Label = [[UILabel alloc] initWithFrame:CGRectMake(kDisplayWidth - inset - size7.width, y, size7.width, size7.height)];
    [leadSupervisor7Label setNumberOfLines:0];
    [leadSupervisor7Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor7Label setTextColor:[UIColor blackColor]];
    [leadSupervisor7Label setText:kLeadConstitutionDiagnosisSupervisor7];
    [footerView addSubview:leadSupervisor7Label];
    [leadSupervisor7Label release];
    
    // Set leadSupervisor5 label
    UILabel *leadSupervisor5Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor5];
    [leadSupervisor5Label setTextColor:[UIColor blackColor]];
    [footerView addSubview:leadSupervisor5Label];
    
    // Set leadSupervisor6 label
    UILabel *leadSupervisor6Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor6];
    [leadSupervisor6Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    [footerView addSubview:leadSupervisor6Label];
    
    y += 6;
    
    // Set leadSupervisor10 label
    CGSize size10 = [kLeadConstitutionDiagnosisSupervisor10 sizeWithFont:[UIFont systemFontOfSize:13]];
    UILabel *leadSupervisor10Label = [[UILabel alloc] initWithFrame:CGRectMake(kDisplayWidth - inset - size10.width, y, size10.width, size10.height)];
    [leadSupervisor10Label setNumberOfLines:0];
    [leadSupervisor10Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor10Label setTextColor:[UIColor blackColor]];
    [leadSupervisor10Label setText:kLeadConstitutionDiagnosisSupervisor10];
    [footerView addSubview:leadSupervisor10Label];
    [leadSupervisor10Label release];
    
    // Set leadSupervisor8 label
    UILabel *leadSupervisor8Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor8];
    [leadSupervisor8Label setTextColor:[UIColor blackColor]];
    [footerView addSubview:leadSupervisor8Label];
    
    // Set leadSupervisor9 label
    UILabel *leadSupervisor9Label = [self textLabelWithY:&y font:[UIFont systemFontOfSize:13] forName:kLeadConstitutionDiagnosisSupervisor9];
    [leadSupervisor9Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    [footerView addSubview:leadSupervisor9Label];
    
    PrintLog(@"y: %f", y);
    // New end
    
    return footerView;
}

#pragma mark -
#pragma mark Table view data source

/***************************************************************
 * セクション数
 ***************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [foodDictionaryArray count];
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[foodDictionaryArray objectAtIndex:section] valueForKey:@"CELL"] count];
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
    [label setText:[NSString stringWithFormat:@"  %@", [[foodDictionaryArray objectAtIndex:section] valueForKey:@"SECTION"]]];
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
    
    static NSString *CellIdentifier = @"FoodCell";
    NSInteger titleLabelTag = 1111;
    NSInteger photoImageTag = 1112;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 0, kDisplayWidth-100, 62)] autorelease];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [titleLabel setTag:titleLabelTag];
        [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [[cell contentView] addSubview:titleLabel];
        
        UIImageView *photoImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 81, 54)] autorelease];
        [photoImageView setTag:photoImageTag];
        [[cell contentView] addSubview:photoImageView];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kArrowIconOffsetX, 
                                                                                    floorf((cellHeight - kArrowIconSizeHeight) / 2.f),
                                                                                    kArrowIconSizeWidth, 
                                                                                    kArrowIconSizeHeight)];
        [arrowImageView setImage:[UIImage imageNamed:kTopArrowImageName]];
        [[cell contentView] addSubview:arrowImageView];
        [arrowImageView release];
    }
    
    NSDictionary *dictionary = [[[foodDictionaryArray objectAtIndex:indexPath.section] valueForKey:@"CELL"] objectAtIndex:indexPath.row];

    UILabel *titleLabel = (UILabel *)[cell viewWithTag:titleLabelTag];
    [titleLabel setText:[NSString stringWithFormat:@"%@%@", [dictionary valueForKey:@"TITLE"], [dictionary valueForKey:@"RUBY"]]];
//    [cell.textLabel setFont:[UIFont systemFontOfSize:14.f]];
//    [cell.textLabel setText:[NSString stringWithFormat:@"%@%@", [dictionary valueForKey:@"TITLE"], [dictionary valueForKey:@"RUBY"]]];

    
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:photoImageTag];
    [photoImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"thumb_%@",[dictionary valueForKey:@"PHOTO"]]]];
    
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
    // Push food dictionary detail view controller.
    FoodDictionaryDetailViewController *foodDictionaryDetailViewController = [[FoodDictionaryDetailViewController alloc] init];
    [foodDictionaryDetailViewController setFoodDictionaryArray:foodDictionaryArray];
    [foodDictionaryDetailViewController setCurrentRow:[indexPath row]];
    [foodDictionaryDetailViewController setCurrentSection:[indexPath section]];
    [[self navigationController] pushViewController:foodDictionaryDetailViewController animated:YES];
    [foodDictionaryDetailViewController release];
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
    [foodDictionaryArray release], foodDictionaryArray = nil;
    [super dealloc];
}



@end

