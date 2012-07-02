//
//  ConstitutionDiagnosisTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/13.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "ConstitutionDiagnosisTableViewController.h"
#import "DiagnosisResultViewController.h"


@implementation ConstitutionDiagnosisTableViewController

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
    
    self.view = [[[UIView alloc] init] autorelease];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self navigationBarSetting];
    
    UILabel *leadLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(16, kNavigationBarHeight+16,
                                                                   kDisplayWidth-32, 37)];
    [leadLabel1 setContentScaleFactor:5.0f];
    [leadLabel1 setNumberOfLines:0];
    [leadLabel1 setFont:[UIFont systemFontOfSize:13]];
    [leadLabel1 setText:kLeadConstitutionDiagnosis1];
    [self.view addSubview:leadLabel1];
    [leadLabel1 release];
    
    UILabel *leadLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(16, kNavigationBarHeight+50,
                                                                   kDisplayWidth-32, 55)];
    [leadLabel2 setContentScaleFactor:5.0f];
    [leadLabel2 setNumberOfLines:0];
    [leadLabel2 setFont:[UIFont systemFontOfSize:13]];
    [leadLabel2 setText:kLeadConstitutionDiagnosis2];
    [self.view addSubview:leadLabel2];
    [leadLabel2 release];
    
    UILabel *leadSupervisor1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 154, 60, 22)];
    [leadSupervisor1Label setNumberOfLines:0];
    [leadSupervisor1Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor1Label setTextColor:[UIColor redColor]];
    [leadSupervisor1Label setText:kLeadConstitutionDiagnosisSupervisor1];
    [self.view addSubview:leadSupervisor1Label];
    [leadSupervisor1Label release];    

    UILabel *leadSupervisor2Label = [[UILabel alloc] initWithFrame:CGRectMake(58, 154, 140, 22)];
    [leadSupervisor2Label setNumberOfLines:0];
    [leadSupervisor2Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor2Label setTextColor:[UIColor blackColor]];
    [leadSupervisor2Label setText:kLeadConstitutionDiagnosisSupervisor2];
    [self.view addSubview:leadSupervisor2Label];
    [leadSupervisor2Label release];    

    UILabel *leadSupervisor3Label = [[UILabel alloc] initWithFrame:CGRectMake(16, 172, 282, 22)];
    [leadSupervisor3Label setNumberOfLines:0];
    [leadSupervisor3Label setFont:[UIFont systemFontOfSize:13]];
    [leadSupervisor3Label setTextColor:[UIColor colorWithRed:0.463f green:0.463f blue:0.463f alpha:1.0f]];
    [leadSupervisor3Label setText:kLeadConstitutionDiagnosisSupervisor3];
    [self.view addSubview:leadSupervisor3Label];
    [leadSupervisor3Label release];    
    
    UIButton *startDiagnosisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startDiagnosisButton setFrame:CGRectMake(20, 195, 280, 70)];
    [startDiagnosisButton setImage:[UIImage imageNamed:kBodyTypeStartBtnImageName] forState:UIControlStateNormal];
    [startDiagnosisButton addTarget:self action:@selector(startDiagnosisButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startDiagnosisButton];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 283, kDisplayWidth, 30)];
//    [lineView setBackgroundColor:kTableSeparatorColor];
//    [self.view addSubview:lineView];
//    [lineView release];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 283, kDisplayWidth, 130)];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setScrollEnabled:NO];
    [tableView_ setBackgroundColor:[UIColor whiteColor]];
    [tableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView_];
    [tableView_ release];
    
//    UIButton *typeAButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [typeAButton setFrame:CGRectMake(10, 330, 145, 60)];
//    [typeAButton setTag:kBodyTypeA];
//    [typeAButton setTitle:@"Type A" forState:UIControlStateNormal];
//    [typeAButton addTarget:self action:@selector(typeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:typeAButton];
//    
//    UIButton *typeBButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [typeBButton setTag:kBodyTypeB];
//    [typeBButton setFrame:CGRectMake(165, 330, 145, 60)];
//    [typeBButton setTitle:@"Type B" forState:UIControlStateNormal];
//    [typeBButton addTarget:self action:@selector(typeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:typeBButton];
}

#pragma mark -
#pragma mark View lifecycle

/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

/***************************************************************
 * 体質別検索に遷移
 ***************************************************************/
- (void)typeButtonPressed:(UIButton *)button {
    int type = [button tag];
    
    DiagnosisResultViewController *diagnosisResultViewController
    = [[DiagnosisResultViewController alloc] initWithType:type];
    [self.navigationController pushViewController:diagnosisResultViewController animated:YES];
    [diagnosisResultViewController release];
}

/***************************************************************
 * 診断開始
 ***************************************************************/
- (void)startDiagnosisButtonPressed:(UIButton *)button {
    DiagnosisTableViewController *controller = [[DiagnosisTableViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Table view data source

/***************************************************************
 * 
 ***************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/***************************************************************
 * 
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        [cell setBackgroundView:cellImageView];
        [cellImageView release];
        
        UIImageView *cellSelectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
        [cell setSelectedBackgroundView:cellSelectedImageView];
        [cellSelectedImageView release];
        
        if (indexPath.row == 0) {
            [cellImageView setImage:[UIImage imageNamed:kCellPuyo1ImageName]];
            [cellSelectedImageView setImage:[UIImage imageNamed:kCellPuyo2ImageName]];
        } else if (indexPath.row == 1) {
            [cellImageView setImage:[UIImage imageNamed:kCellKachi1ImageName]];
            [cellSelectedImageView setImage:[UIImage imageNamed:kCellKachi2ImageName]];
        }
    }
    
    return cell;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        DiagnosisResultViewController *diagnosisResultViewController
        = [[DiagnosisResultViewController alloc] initWithType:kBodyTypeB];
        [self.navigationController pushViewController:diagnosisResultViewController animated:YES];
        [diagnosisResultViewController release];
    } else if (indexPath.row == 1) {
        DiagnosisResultViewController *diagnosisResultViewController
        = [[DiagnosisResultViewController alloc] initWithType:kBodyTypeA];
        [self.navigationController pushViewController:diagnosisResultViewController animated:YES];
        [diagnosisResultViewController release];
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
    [super dealloc];

}

@end

