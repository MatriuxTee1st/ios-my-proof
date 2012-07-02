//
//  PhotoListTableViewController.m
//  MedicinalCarbOff
//
//  Created by 近藤 雅人 on 11/10/19.
//  Copyright (c) 2011 レッドフォックス株式会社. All rights reserved.
//

#import "PhotoListTableViewController.h"
#import "DatabaseUtility.h"
#import "ImageUtil.h"

@implementation PhotoListTableViewController
@synthesize delegate;
@synthesize recipeArray;

#pragma mark -
#pragma mark Initialization
/***************************************************************
 * 初期化
 ***************************************************************/
- (id)init {//WithRecipeArray:(NSMutableArray *)array {
    
    self = [super init];
    if (self) {
//        recipeArray = array;
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
    [self.view setFrame:CGRectMake(kDisplayWidth, 44 + 480, kDisplayWidth, 368)];
    
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDisplayWidth, kDisplayMinHeight)];
    [tableView_ setDelegate:self];
    [tableView_ setDataSource:self];
    [tableView_ setBackgroundColor:[UIColor whiteColor]];
    [tableView_ setSeparatorColor:kTableSeparatorColor];
    [self.view addSubview:tableView_];
    [tableView_ release];
    
}
#pragma mark -
#pragma mark View lifecycle
/***************************************************************
 * ビュー表示前
 ***************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tableView_ reloadData];
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
    return 1;
}

/***************************************************************
 * セクション内のセル数
 ***************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipeArray count];
}


/***************************************************************
 * セル表示時
 ***************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    RecipeCell *cell = (RecipeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RecipeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    RecipeEntity *recipeEntity = [recipeArray objectAtIndex:indexPath.row];
    
    if (recipeEntity.recipeNo <= kRecipeCount) {
        [cell.photoImageView setImage:[UIImage imageNamed:[recipeEntity thumbnailPhotoNo]]];
    } else {
        [cell.photoImageView setImage:[ImageUtil loadImage:[recipeEntity thumbnailPhotoNo]]];
    }
    [cell.costLabel setText:[NSString stringWithFormat:@"%.2fg", [recipeEntity carbQty]]];
    [cell.timeLabel setText:[NSString stringWithFormat:@"%dmin", [recipeEntity time]]];
    [cell.calorieLabel setText:[NSString stringWithFormat:@"%dkcal", [recipeEntity calorie]]];
    
    NSString *recipeName = [recipeEntity recipeName];
    UIFont *recipeNameFont = [UIFont boldSystemFontOfSize:kRecipeCellRecipeNameFontSize];
    [cell.recipeNameLabel setText:recipeName];   
    [cell.recipeNameLabel setFont:recipeNameFont];
    [cell.recipeNameLabel setNeedsDisplay];
    
    if (recipeEntity.recipeNo > kRecipeCount) {
        NSDate *recipeDate = [DatabaseUtility selectDownloadDate:recipeEntity.recipeNo];
        
        // 1週間以内に購入した場合
        if ([[NSDate date] timeIntervalSinceDate:recipeDate] < 60 * 60 * 24 * 7) {
            [cell.addonImageView setHidden:NO];
        } else {
            [cell.addonImageView setHidden:YES];
        }
    } else {
        [cell.addonImageView setHidden:YES];
    }

    return cell;
}

/***************************************************************
 * セルの高さ
 ***************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


#pragma mark -
#pragma mark Table view delegate

/***************************************************************
 * セルタップ時
 ***************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate transitionToRecipeViewWithRecipeNo:[[recipeArray objectAtIndex:indexPath.row] recipeNo]];
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
    [recipeArray release], recipeArray = nil;
    [delegate release];
    [super dealloc];
}


@end
