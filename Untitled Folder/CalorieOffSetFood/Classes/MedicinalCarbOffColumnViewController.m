//
//  MedicinalCarbOffColumnViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/12.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "MedicinalCarbOffColumnViewController.h"

static CGFloat inset = 16.f;
static CGFloat headerFontSize = 13.f;

@implementation MedicinalCarbOffColumnViewController

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
    
    CGSize headerSize = [kLeadMedicinalCarbOffColumn sizeWithFont:[UIFont systemFontOfSize:headerFontSize]
                                                constrainedToSize:CGSizeMake(kDisplayWidth - 2 * inset, 3000.f)
                                                    lineBreakMode:UILineBreakModeCharacterWrap];
    // Create header based on text size.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, kNavigationBarHeight + 0.5 * inset, kDisplayWidth - 2 * inset, headerSize.height + 1.5 * inset)];
    [headerLabel setFont:[UIFont systemFontOfSize:headerFontSize]];
    [headerLabel setText:kLeadMedicinalCarbOffColumn];
    [headerLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [headerLabel setNumberOfLines:0];
    [self.view addSubview:headerLabel];
    [headerLabel release];
    
    // Top of table separator.
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight + headerSize.height + 2 * inset - 1, kDisplayWidth, 1)];
    [lineView setBackgroundColor:kTableSeparatorColor];
    [self.view addSubview:lineView];
    [lineView release];
    
    columnArray = [[NSArray alloc] initWithArray:[Utility getColumnArray]];
    cellHeight = ceilf((368.f - headerSize.height - 2 * inset) / 6.f);
    
    // Create table view based on text size offset.
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight + headerSize.height + 2 * inset, kDisplayWidth, 368.f - headerSize.height - 2 * inset)];
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
    [navigationBarTitleLabel setText:kNavigationBarTitleOshieteName];
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
    return 1;
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [columnArray count];
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

    CGFloat fontSize = 15.f;
    
    switch ([indexPath row]) {
        case MSOTableColumn1: {
            NSDictionary *dictionary = [columnArray objectAtIndex:0];
            [[cell textLabel] setText:[NSString stringWithFormat:@" %@", [dictionary valueForKey:@"TITLE"]]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
            [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
            break;
        }
        case MSOTableColumn2: {
            NSDictionary *dictionary = [columnArray objectAtIndex:1];
            [[cell textLabel] setText:[NSString stringWithFormat:@" %@", [dictionary valueForKey:@"TITLE"]]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
            [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
            break;
        }
        case MSOTableColumn3: {
            NSDictionary *dictionary = [columnArray objectAtIndex:2];
            [[cell textLabel] setText:[NSString stringWithFormat:@" %@", [dictionary valueForKey:@"TITLE"]]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
            [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
            break;
        }
        case MSOTableColumn4: {
            NSDictionary *dictionary = [columnArray objectAtIndex:3];
            [[cell textLabel] setText:[NSString stringWithFormat:@" %@", [dictionary valueForKey:@"TITLE"]]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
            [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
            break;
        }
        case MSOTableColumn5: {
            NSDictionary *dictionary = [columnArray objectAtIndex:4];
            [[cell textLabel] setText:[NSString stringWithFormat:@" %@", [dictionary valueForKey:@"TITLE"]]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
            [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
            break;
        }
        case MSOTableColumn6: {
            NSDictionary *dictionary = [columnArray objectAtIndex:5];
            [[cell textLabel] setText:[NSString stringWithFormat:@" %@", [dictionary valueForKey:@"TITLE"]]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:fontSize]];
            [[cell textLabel] setTextColor:kMedicinalCarbOffColumnSubTitleFontColor];
            break;
        }
        default:
            break;
    }
    
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
    
    MedicinalCarbOffColumnDetailViewController *medicinalCarbOffDetailViewController = [[MedicinalCarbOffColumnDetailViewController alloc] init];
    
    switch ([indexPath row]) {
        case MSOTableColumn1: {
            NSDictionary *dictionary = [columnArray objectAtIndex:0];
            [medicinalCarbOffDetailViewController setColumnDictionary:dictionary];
            [medicinalCarbOffDetailViewController setIndexNumber:0];
            break;
        }
        case MSOTableColumn2: {
            NSDictionary *dictionary = [columnArray objectAtIndex:1];
            [medicinalCarbOffDetailViewController setColumnDictionary:dictionary];
            [medicinalCarbOffDetailViewController setIndexNumber:1];
            break;
        }
        case MSOTableColumn3: {
            NSDictionary *dictionary = [columnArray objectAtIndex:2];
            [medicinalCarbOffDetailViewController setColumnDictionary:dictionary];
            [medicinalCarbOffDetailViewController setIndexNumber:2];
            break;
        }
        case MSOTableColumn4: {
            NSDictionary *dictionary = [columnArray objectAtIndex:3];
            [medicinalCarbOffDetailViewController setColumnDictionary:dictionary];
            [medicinalCarbOffDetailViewController setIndexNumber:3];
            break;
        }
        case MSOTableColumn5: {
            NSDictionary *dictionary = [columnArray objectAtIndex:4];
            [medicinalCarbOffDetailViewController setColumnDictionary:dictionary];
            [medicinalCarbOffDetailViewController setIndexNumber:4];
            break;
        }
        case MSOTableColumn6: {
            NSDictionary *dictionary = [columnArray objectAtIndex:5];
            [medicinalCarbOffDetailViewController setColumnDictionary:dictionary];
            [medicinalCarbOffDetailViewController setIndexNumber:5];
            break;
        }
        default:
            break;
    }
    
    [self.navigationController pushViewController:medicinalCarbOffDetailViewController animated:YES];
    [medicinalCarbOffDetailViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [columnArray release], columnArray = nil;
    [super dealloc];
}


@end

