//
//  GozenViewController.m
//  MedicinalCarbOff
//
//  Created by Nolan Warner on 11/10/26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GozenViewController.h"

static CGFloat imageHeight = 150.f;
static CGFloat inset = 10.f;

@implementation GozenViewController


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    PrintLog(@"[loadView] {");
    
    [self navigationBarSetting];
    
    NSString *tmp = [NSString stringWithFormat:@"Sample String"];
    
    // Get lead text size.
    CGSize leadTextSize = [tmp sizeWithFont:[UIFont systemFontOfSize:18.f]
                                   forWidth:300.f
                              lineBreakMode:UILineBreakModeCharacterWrap];
    
    // Set lead text.
    UILabel *leadText = [[UILabel alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight, leadTextSize.width, leadTextSize.height)];
    [leadText setText:tmp];
    [self.view addSubview:leadText];
    [leadText release];
    
    // Top of table separator.
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, kNavigationBarHeight + leadTextSize.height, kDisplayWidth, 1)];
    [lineView setBackgroundColor:kTableSeparatorColor];
    [self.view addSubview:lineView];
    [lineView release];
    
    // Set table view.
    CGFloat tableViewY = kNavigationBarHeight + leadTextSize.height + 1;
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0.f, tableViewY, kDisplayWidth, 412.f - tableViewY)];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [self.view addSubview:tableView_];
    [tableView_ release];
    PrintLog(@"[loadView] }");
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

#pragma mark -
#pragma mark Table view data source
/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    
    // Set cell image.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDisplayWidth - imageHeight * 4.f / 3.f) / 2, inset, imageHeight * 4.f / 3.f, imageHeight)];
    [imageView setBackgroundColor:[UIColor redColor]];
    [[cell contentView] addSubview:imageView];
    [imageView release];
    
    // Set cell title under image.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.f, inset + imageHeight, 250.f, 31.f)];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setText:NSLocalizedString(@"生薬ご膳", @"生薬ご膳")];
    [[cell contentView] addSubview:titleLabel];
    [titleLabel release];
    
    // Set cell explanation with proper height.
    NSString *tmp = [NSString stringWithFormat:@"ご膳の説明リードテキスト"];
    CGSize leadTextSize = [tmp sizeWithFont:[UIFont systemFontOfSize:18.f] forWidth:300.f lineBreakMode:UILineBreakModeCharacterWrap];
    CGFloat leadTextHeight = 2 * inset + imageHeight + leadTextSize.height;
    UILabel *leadText = [[UILabel alloc] initWithFrame:CGRectMake(inset, leadTextHeight, kDisplayWidth - 2 * inset, leadTextSize.height)];
    [leadText setText:tmp];
    [[cell contentView] addSubview:leadText];
    [leadText release];
        
    return cell;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tmp = [NSString stringWithFormat:@"ご膳の説明リードテキスト"];
    CGSize leadTextSize = [tmp sizeWithFont:[UIFont systemFontOfSize:18.f] forWidth:300.f lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGFloat cellHeight = 2 * inset + imageHeight + leadTextSize.height + 31.f;
    
    return cellHeight;
}


#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GozenDetailViewController *gozenDetailViewController = [[GozenDetailViewController alloc] init];
    [self.navigationController pushViewController:gozenDetailViewController animated:YES];
    [gozenDetailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
