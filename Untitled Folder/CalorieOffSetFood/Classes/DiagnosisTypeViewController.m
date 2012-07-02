//
//  DiagnosisTypeViewController.m
//  MedicinalCarbOff
//
//  体質タイプのプロパティを１つ受け取り、
//  体質タイプを１つに関する情報を表示する
//
//  Created by 近藤 雅人 on 11/10/11.
//  Copyright 2011 レッドフォックス株式会社. All rights reserved.
//

#import "DiagnosisTypeViewController.h"

static CGFloat headerFontSize = 16;
static CGFloat mainFontSize = 14;
static CGFloat textWidth = 285;
static CGFloat inset = 22;
static CGFloat dotLineOffset = 12;


@implementation DiagnosisTypeViewController
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithType:(NSString *)type {
    self = [super init];
    if (self) {
        
        resultDictionary = [[[Utility getConstitutionDiagnosisResultDictionary] valueForKey:type] retain];
        
    }
    return self;
}

/***************************************************************
 * 読み込み時
 * ・UI配置
 ***************************************************************/
- (void)loadView {
    [super loadView];
    PrintLog(@"[loadView] {");
    
    self.view = [[[UIView alloc] init] autorelease];
    
    [self setTitle:@"診断結果"];
    [self navigationBarSetting];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kDisplayWidth, kDisplayMinHeight)];
    
    PrintLog(@"[loadView] frame height = %f %f", [scrollView frame].origin.y,[scrollView frame].size.height);
  
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollView];
    
    // 体質
    UILabel *constitutionLabel = [[UILabel alloc] init];
    NSString *constitution = [resultDictionary valueForKey:kKeyConstitution];
    UIFont *constitutionFont = [UIFont boldSystemFontOfSize:24];
    CGSize constitutionLabelSize = [constitution sizeWithFont:constitutionFont 
                                    constrainedToSize:CGSizeMake(textWidth, 800)];
    [constitutionLabel setFrame:CGRectMake(inset, 
                                           10,
                                           constitutionLabelSize.width,
                                           constitutionLabelSize.height)];
    [constitutionLabel setText:constitution];
    [constitutionLabel setFont:constitutionFont];
    [constitutionLabel setTextColor:kColorGrayText];
    [scrollView addSubview:constitutionLabel];
    
    // 体質よみがな
    UILabel *constitutionRubyLabel = [[UILabel alloc] init];
    NSString *constitutionRuby = [NSString stringWithFormat:@"（%@）", [resultDictionary valueForKey:kKeyConstitutionRuby]];
    UIFont *constitutionRubyFont = [UIFont systemFontOfSize:16];
    CGSize constitutionRubyLabelSize = [constitutionRuby sizeWithFont:constitutionRubyFont 
                                                    constrainedToSize:CGSizeMake(textWidth, 800)];
    [constitutionRubyLabel setFrame:CGRectMake([constitutionLabel frame].origin.x + [constitutionLabel frame].size.width, 
                                               [constitutionLabel frame].origin.y,
                                               constitutionRubyLabelSize.width,
                                               constitutionLabelSize.height)];
    [constitutionRubyLabel setText:constitutionRuby];
    [constitutionRubyLabel setFont:constitutionRubyFont];
    [scrollView addSubview:constitutionRubyLabel];
    
    // 状態
    UILabel *statusLabel = [[UILabel alloc] init];
    NSString *status = [resultDictionary valueForKey:kKeyStatus];
    UIFont *statusFont = [UIFont systemFontOfSize:headerFontSize];
    CGSize statusLabelSize = [status sizeWithFont:statusFont 
                                constrainedToSize:CGSizeMake(textWidth, 800)];
    [statusLabel setFrame:CGRectMake(inset, 
                                    [constitutionRubyLabel frame].origin.y + [constitutionRubyLabel frame].size.height,
                                    statusLabelSize.width,
                                    statusLabelSize.height)];
    [statusLabel setText:status];
    [statusLabel setFont:statusFont];
    [statusLabel setTextColor:kColorCyanText];
    [statusLabel setNumberOfLines:0];
    [scrollView addSubview:statusLabel];
    
    // 水平区切り線    
    UIImageView *dotLineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                   dotLineOffset + [statusLabel frame].origin.y + [statusLabel frame].size.height,
                                                                                   kDisplayWidth,
                                                                                   1)];
    [dotLineImageView1 setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:dotLineImageView1];
    [dotLineImageView1 release];
    
    // 診断結果
    UILabel *diagnosisLabel = [[UILabel alloc] init];
    NSString *diagnosis = [resultDictionary valueForKey:kKeyDiagnosis];
    UIFont *diagnosisFont = [UIFont systemFontOfSize:mainFontSize];
    CGSize diagnosisLabelSize = [diagnosis sizeWithFont:diagnosisFont
                                      constrainedToSize:CGSizeMake(textWidth, 800)];
    [diagnosisLabel setFrame:CGRectMake(inset, 
                                        2 * dotLineOffset + [statusLabel frame].origin.y + [statusLabel frame].size.height,
                                        diagnosisLabelSize.width,
                                        diagnosisLabelSize.height)];
    
    [diagnosisLabel setNumberOfLines:0];
    [diagnosisLabel setFont:diagnosisFont];
    [diagnosisLabel setText:diagnosis];
    [scrollView addSubview:diagnosisLabel];
    
    // 水平区切り線    
    UIImageView *dotLineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                   dotLineOffset + [diagnosisLabel frame].origin.y + [diagnosisLabel frame].size.height,
                                                                                   kDisplayWidth,
                                                                                   1)];
    [dotLineImageView2 setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:dotLineImageView2];
    [dotLineImageView2 release];
    
    // 気をつけたい習慣（見出し）
    UILabel *causeTitleLabel = [[UILabel alloc] init];
    NSString *causeTitle = @"【気をつけたい習慣】";
    UIFont *causeTitleFont = [UIFont boldSystemFontOfSize:headerFontSize];
    CGSize causeTitleLabelSize = [causeTitle sizeWithFont:causeTitleFont
                                        constrainedToSize:CGSizeMake(textWidth, 800)];
    [causeTitleLabel setFrame:CGRectMake(inset - 8, 
                                         2 * dotLineOffset + [diagnosisLabel frame].origin.y + [diagnosisLabel frame].size.height,
                                         causeTitleLabelSize.width,
                                         causeTitleLabelSize.height)];
    
    [causeTitleLabel setFont:causeTitleFont];
    [causeTitleLabel setText:causeTitle];
    [causeTitleLabel setTextColor:kColorRedTitle];
    [scrollView addSubview:causeTitleLabel];
    
    // 気をつけたい習慣
    UILabel *causeLabel = [[UILabel alloc] init];
    NSString *cause = [resultDictionary valueForKey:kKeyCause];
    UIFont *causeFont = [UIFont systemFontOfSize:mainFontSize];
    CGSize causeLabelSize = [cause sizeWithFont:causeFont
                              constrainedToSize:CGSizeMake(textWidth, 800)];
    [causeLabel setFrame:CGRectMake(inset, 
                                    5 + [causeTitleLabel frame].origin.y + [causeTitleLabel frame].size.height,
                                    causeLabelSize.width,
                                    causeLabelSize.height)];
    
    [causeLabel setNumberOfLines:0];
    [causeLabel setFont:causeFont];
    [causeLabel setText:cause];
    [scrollView addSubview:causeLabel];
    
    // 水平区切り線    
    UIImageView *dotLineImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                   dotLineOffset + [causeLabel frame].origin.y + [causeLabel frame].size.height,
                                                                                   kDisplayWidth,
                                                                                   1)];
    [dotLineImageView3 setImage:[UIImage imageNamed:kLineDotImageName]];
    [scrollView addSubview:dotLineImageView3];
    [dotLineImageView3 release];
    
    // ダイエットのための対策（見出し）
    UILabel *solutionTitleLabel = [[UILabel alloc] init];
    NSString *solutionTitle = @"【ダイエットのための対策】";
    UIFont *solutionTitleFont = [UIFont boldSystemFontOfSize:headerFontSize];
    CGSize solutionTitleLabelSize = [solutionTitle sizeWithFont:solutionTitleFont
                                              constrainedToSize:CGSizeMake(textWidth, 800)];
    [solutionTitleLabel setFrame:CGRectMake(inset - 8, 
                                            2 * dotLineOffset + [causeLabel frame].origin.y + [causeLabel frame].size.height,
                                            solutionTitleLabelSize.width,
                                            solutionTitleLabelSize.height)];
    
    [solutionTitleLabel setFont:solutionTitleFont];
    [solutionTitleLabel setText:solutionTitle];
    [solutionTitleLabel setTextColor:kColorRedTitle];
    [scrollView addSubview:solutionTitleLabel];
    
    // ダイエットのための対策
    UILabel *solutionLabel = [[UILabel alloc] init];
    NSString *solution = [resultDictionary valueForKey:kKeySolution];
    UIFont *solutionFont = [UIFont systemFontOfSize:mainFontSize];
    CGSize solutionLabelSize = [solution sizeWithFont:solutionFont
                                    constrainedToSize:CGSizeMake(textWidth, 800)];
   [solutionLabel setFrame:CGRectMake(inset, 
                                      5 + [solutionTitleLabel frame].origin.y + [solutionTitleLabel frame].size.height,
                                      solutionLabelSize.width,
                                      solutionLabelSize.height)];
    [solutionLabel setNumberOfLines:0];
    [solutionLabel setFont:solutionFont];
    [solutionLabel setText:solution];
    
    [scrollView addSubview:solutionLabel];
    
    
    [scrollView setContentSize:CGSizeMake(320, 10 + [solutionLabel frame].origin.y + [solutionLabel frame].size.height)];
   
    
    PrintLog(@"[loadView] y = %f", [solutionLabel frame].origin.y);
    PrintLog(@"[loadView] h = %f", [solutionLabel frame].size.height);

    PrintLog(@"[loadView] contentSize = %f", [scrollView contentSize].height);

                                  
    [constitutionLabel release];
    [constitutionRubyLabel release];
    [statusLabel release];
    [diagnosisLabel release];
    [causeTitleLabel release];
    [causeLabel release];
    [solutionTitleLabel release];
    [solutionLabel release];
    
                       
                       
                                  
    [scrollView release];
    
    
    
    
    PrintLog(@"[loadView] }");
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
    [navigationBarTitleLabel setText:kNavigationBarTitleKakutaishitsuName];
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
    [resultDictionary release];
    [super dealloc];
    
}


@end
