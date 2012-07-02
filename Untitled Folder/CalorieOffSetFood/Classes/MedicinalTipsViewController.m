//
//  MedicinalTipsViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/06.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "MedicinalTipsViewController.h"

@implementation MedicinalTipsViewController

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
    PrintLog(@"[%@] {", CMD_STR);
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navigationBarSetting];
    
    CGSize headerSize = [kLeadTecho sizeWithFont:[UIFont systemFontOfSize:13]
                                                 constrainedToSize:CGSizeMake(kDisplayWidth - 32, 3000.f)
                                                     lineBreakMode:UILineBreakModeCharacterWrap];
    // Create header based on text size.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, kNavigationBarHeight + 12, kDisplayWidth - 32, headerSize.height)];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    [headerLabel setText:kLeadTecho];
    [headerLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [headerLabel setNumberOfLines:0];
    [self.view addSubview:headerLabel];
    [headerLabel release];
    
    // Top of table separator.
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight + headerSize.height + 24 - 1, kDisplayWidth, 1)];
    [lineView setBackgroundColor:kTableSeparatorColor];
    [self.view addSubview:lineView];
    [lineView release];
    
    cellHeight = ceilf((368.f -  headerSize.height - 24) / MedicinalTipsTableRowNum);
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight + headerSize.height + 24, kDisplayWidth, 368.f -  headerSize.height - 24) style:UITableViewStylePlain];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [self.view addSubview:tableView_];
    [tableView_ release];
        
    PrintLog(@"[%@] }", CMD_STR);
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
    [navigationBarTitleLabel setText:kNavigationBarTitleTipsName];
    [navigationBarTitleLabel setTextAlignment:UITextAlignmentCenter];
    [navigationBarTitleLabel setTextColor:kColorRedNavigationTitle];
    [self.view addSubview:navigationBarTitleLabel];
    [navigationBarTitleLabel release];
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
    return MedicinalTipsTableRowNum;
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

    switch ([indexPath row]) {
        case MedicinalTipsTableRowMedicalCookingColumn:
            [[cell textLabel] setText:NSLocalizedString(@"薬膳コラム", @"薬膳コラム")];
            break;
        case MedicinalTipsTableRowFoodDictionary:
            [[cell textLabel] setText:NSLocalizedString(@"食材辞典", @"食材辞典")];
            break;
        case MedicinalTipsTableRowMedicalCookingDictionary:
            [[cell textLabel] setText:NSLocalizedString(@"薬膳辞典", @"薬膳辞典")];
            break;
        case MedicinalTipsTableRowSlideshow:
            [[cell textLabel] setText:NSLocalizedString(@"スライドショー", @"スライドショー")];
            break;
        case MedicinalTipsTableRowGozen:
            [[cell textLabel] setText:NSLocalizedString(@"ご膳", @"ご膳")];
            break;
        case MedicinalTipsTableRowAppIntro:
            [[cell textLabel] setText:NSLocalizedString(@"薬膳アプリシリーズ", @"薬膳アプリシリーズ")];
            break;
        case MedicinalTipsTableRowCarbCount:
            [[cell textLabel] setText:NSLocalizedString(@"糖質量一覧表", @"糖質量一覧表")];
            break;
        case MedicinalTipsTableRowAboutThisApp:
            [[cell textLabel] setText:NSLocalizedString(@"アプリINFO", @"アプリINFO")];
            break;
        case MedicinalTipsTableRowEditorIntroduction:
            [[cell textLabel] setText:NSLocalizedString(@"監修者紹介", @"監修者紹介")];
            break;
        default:
            break;
    }
    
    [[cell textLabel] setFont:[UIFont systemFontOfSize:17.f]];
    [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
    
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

#pragma mark - Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath row]) {
        case MedicinalTipsTableRowMedicalCookingColumn: {
            // Push MedicinalCarbOffColumnTableViewController
            MedicinalCarbOffColumnViewController *medicinalCarbOffColumnTableViewController 
            = [[MedicinalCarbOffColumnViewController alloc] init];
            [self.navigationController pushViewController:medicinalCarbOffColumnTableViewController animated:YES];
            [medicinalCarbOffColumnTableViewController release];
            break;
        }
        case MedicinalTipsTableRowFoodDictionary: {
            // Push FoodDictionaryTableViewController
            FoodDictionaryViewController *foodDictionaryTableViewController = [[FoodDictionaryViewController alloc] init];
            [self.navigationController pushViewController:foodDictionaryTableViewController animated:YES];
            [foodDictionaryTableViewController release];
            break;
        }
        case MedicinalTipsTableRowMedicalCookingDictionary: {
            // Push MedicinalCarbOffDictionaryTableViewController
            MedicinalCarbOffDictionaryViewController *medicinalCarbOffDictionaryTableViewController 
            = [[MedicinalCarbOffDictionaryViewController alloc] init];
            [self.navigationController pushViewController:medicinalCarbOffDictionaryTableViewController animated:YES];
            [medicinalCarbOffDictionaryTableViewController release];
            break;
        }
        case MedicinalTipsTableRowSlideshow: {
            // Push SlideshowViewController
            SlideshowViewController *slideshowViewController 
            = [[SlideshowViewController alloc] init];
            [self.navigationController pushViewController:slideshowViewController animated:YES];
            [slideshowViewController release];
            break;
        }
        case MedicinalTipsTableRowGozen: {
            // Push GozenViewController
            GozenViewController *gozenViewController
            = [[GozenViewController alloc] init];
            [self.navigationController pushViewController:gozenViewController animated:YES];
            [gozenViewController release];
            break;
        }
        case MedicinalTipsTableRowAppIntro: {
            // Push AboutThisApp
            AppIntroViewController *appIntroViewController
            = [[AppIntroViewController alloc] init];
            [self.navigationController pushViewController:appIntroViewController animated:YES];
            [appIntroViewController release];
            break;
        }
        case MedicinalTipsTableRowCarbCount: {
            // Push AboutThisApp
            CarbCountViewController *carbCountViewController
            = [[CarbCountViewController alloc] init];
            [self.navigationController pushViewController:carbCountViewController animated:YES];
            [carbCountViewController release];
            break;
        }
        case MedicinalTipsTableRowAboutThisApp: {
            // Push AboutThisApp
            AboutThisAppViewController *aboutThisAppViewController
            = [[AboutThisAppViewController alloc] init];
            [self.navigationController pushViewController:aboutThisAppViewController animated:YES];
            [aboutThisAppViewController release];
            break;
        }
        case MedicinalTipsTableRowEditorIntroduction: {
            // Push EditorIntroduction
            EditorIntroductionViewController *editorIntroductionViewController
            = [[EditorIntroductionViewController alloc] init];
            [self.navigationController pushViewController:editorIntroductionViewController animated:YES];
            [editorIntroductionViewController release];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
