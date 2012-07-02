//
//  DiagnosisTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/07.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "DiagnosisTableViewController.h"
#import "DiagnosisResultViewController.h"


@implementation DiagnosisTableViewController


#pragma mark -
#pragma mark Initialization
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        checkSum[0] = 0;
        checkSum[1] = 0;
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
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    [self navigationBarSetting];
            
    questionArray = [[Utility getConstitutionDiagnosisQuestionDictionary] retain];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, 307)];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setBackgroundColor:[UIColor whiteColor]];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [self.view addSubview:tableView_];
    [tableView_ release];

    // 次へボタン
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(0, 351, kDisplayWidth, 60)];
    [nextButton setImage:[UIImage imageNamed:kNextButtonImageName] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    // スイッチの状態配列
    switchStatusArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [questionArray count]; i++) {
        [switchStatusArray addObject:[NSNumber numberWithBool:NO]];
    }
    
}



#pragma mark -
#pragma mark View lifecycle
/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    checkSum[0] = 0;
    checkSum[1] = 0;
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
    return 2;
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [questionArray count];
}


/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Header";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setText:NSLocalizedString(@" 当てはまるものを１つ以上選んでください", @" 当てはまるものを１つ以上選んでください")];
        [cell.textLabel setTextColor:kConstitutionDiagnosisMessageFontColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    } 
    static NSString *CellIdentifier = @"Cell";
    
    ConstitutionDiagnosisCell *cell = (ConstitutionDiagnosisCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ConstitutionDiagnosisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.questionLabel setText:[[questionArray objectAtIndex:[indexPath row]] valueForKey:kKeyText]];    
    [cell.selectButton setTag:indexPath.row];
    [cell.selectButton setCheck:[[switchStatusArray objectAtIndex:indexPath.row] boolValue]];
    [Utility setSelectButtonImage:cell.selectButton];
    
    return cell;
}


/***************************************************************
 * セル選択時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        ConstitutionDiagnosisCell *cell = (ConstitutionDiagnosisCell *)[tableView cellForRowAtIndexPath:indexPath];
        SwitchingButton *selectButton = cell.selectButton;
        if ([selectButton check]) {
            [selectButton setCheck:NO];
        } else {
            [selectButton setCheck:YES];
        }
        [Utility setSelectButtonImage:selectButton];
        
        [switchStatusArray removeObjectAtIndex:[selectButton tag]];
        [switchStatusArray insertObject:[NSNumber numberWithBool:[selectButton check]] atIndex:[selectButton tag]];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kConstitutionDiagnosisMessageCellHeight;
    }
    return kConstitutionDiagnosisCellHeight;
}


#pragma mark -
#pragma mark UIView Controller
/***************************************************************
 * 次へボタン押下時
 ***************************************************************/
- (void)nextButtonPushed {
    int boolSum = 0;
    for (int i = 0; i < [switchStatusArray count]; i++) {
        BOOL switchStatus = [[switchStatusArray objectAtIndex:i] boolValue];
        boolSum += switchStatus;
        
        // 点数配列
        if (switchStatus) {
            int type = [[[questionArray objectAtIndex:i] valueForKey:kKeyType] intValue];
            checkSum[type]++;
        }
    }
    
    if (boolSum != 0) {
        int type;
        if (checkSum[0] < checkSum[1]) {
            type = 1;
        } else {
            type = 0;
        }

        DiagnosisResultViewController *diagnosisResultViewController
        = [[DiagnosisResultViewController alloc] initWithType:type];
        [self.navigationController pushViewController:diagnosisResultViewController animated:YES];
        [diagnosisResultViewController release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当てはまるものを１つ以上選択してください"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];        
    }
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
    [navigationBarTitleLabel setText:kNavigationBarTitleTaishituName];
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
    [switchStatusArray release];
    [questionArray release];
    [super dealloc];
 }



@end

