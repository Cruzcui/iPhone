//
//  HKHomeTableViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHomeTableViewController.h"
#import "HHHomeAdCell.h"
#import "UIViewController+MMDrawerController.h"
#import "HKGuidListViewController.h"
#import "HKMyCommonsViewController.h"
#import "HKMyPosterViewController.h"
#import "HKMyVideosViewController.h"
#import "HKMyPPTsViewController.h"
#import "HKHisToolsViewController.h"
#import "HKHomeButtonCell.h"
#import "MyZhiNanMoreViewController.h"
#import "MyZhiNanViewController.h"
#import "MyNoteMoreViewController.h"
#import "MyNoteViewController.h"
#import "MyBiBaoViewController.h"
#import "HKMySelectedPPTViewController.h"
#import "HKMySelectedVideoViewController.h"
#import "HKReviewVideoViewController.h"
#import "HKReviewBiBaoViewController.h"
#import "HKReviewPPTViewController.h"
#import "SBJsonParser.h"
#import "HKMySelectedToolsViewController.h"
#import "HKReviewToolsViewController.h"
@interface HKHomeTableViewController ()

@property (nonatomic,retain) HHHomeAdCell* adCell;

@end

@implementation HKHomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.tabBarItem.image = [UIImage imageNamed:@"tab01.png"];
        self.tabBarItem.title = @"重点推荐";
        _share = [ShareInstance instance];
        _profile = [MyProfile myProfile];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人收藏";
    
    
    //广告行
//    self.adCell = [[[NSBundle mainBundle]loadNibNamed:@"HHHomeAdCell"owner:self options:nil] lastObject];
//    
//    [self.adCell loadImages:@""];
//    
//    self.tableView.tableHeaderView = self.adCell;
    
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    [self.mm_drawerController setOpenDrawerGestureModeMask:0];//开启滚动效果

    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=nil; // = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    static NSString *HomeButtonCellIdentifier = @"HomeButtonCell";
    cell = [tableView dequeueReusableCellWithIdentifier:HomeButtonCellIdentifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HKHomeButtonCell"owner:self options:nil] lastObject];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    
    
    
    HKHomeButtonCell* homeCell = (HKHomeButtonCell*)cell;
    
    homeCell.ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_btn_%d.png",indexPath.row]];
    
    switch (indexPath.row) {
        case 0:
            homeCell.TitleLabel.text = @"我的指南";
//            if ([_profile indexOfFaved:Fav_Type_MedGuid key:[_share.MyZhiNanDic stringForKey:@"pkey"]] != -1)
        if(_share.MyZhiNanDic )
        {
                homeCell.SubTitleLabel.text = [_share.MyZhiNanDic stringForKey:@"title"];
            }else {
                homeCell.SubTitleLabel.text = @"暂无浏览内容";
            }
           
            [homeCell.moreButton addTarget:self action:@selector(moreForZhiNan) forControlEvents:UIControlEventTouchUpInside];
             homeCell.ImageView.image = [UIImage imageNamed:@"fav_guid.png"];
            break;
        case 1:
            homeCell.TitleLabel.text = @"我的笔记";
            if (_share.MyNoteDic) {
                NSEnumerator *enumerator = [_share.MyNoteDic keyEnumerator];
                
                id keys;
                while ((keys = [enumerator nextObject]))
                {
                    NSData * JSON =  [self WriteLocalFile:(NSString *)keys andsavefile:@"index"];
                    SBJsonParser * parser = [[SBJsonParser alloc]init];
                    NSDictionary * dic = [parser objectWithData:JSON];
                    [parser release];
                    if (dic == nil) {
                        homeCell.SubTitleLabel.text = @"暂无浏览内容";
                    }else
                        homeCell.SubTitleLabel.text = [dic stringForKey:@"title"];
                }

                
            }else {
                homeCell.SubTitleLabel.text = @"暂无浏览内容";
            }

            [homeCell.moreButton addTarget:self action:@selector(moreForNote) forControlEvents:UIControlEventTouchUpInside];
             homeCell.ImageView.image = [UIImage imageNamed:@"fav_note.png"];
            break;
        case 3:
            homeCell.TitleLabel.text = @"我的视频";
            if (_share.MyVideoDic) {
                homeCell.SubTitleLabel.text = [_share.MyVideoDic stringForKey:@"title"];
            }else {
                homeCell.SubTitleLabel.text = @"暂无浏览内容";
            }

            [homeCell.moreButton addTarget:self action:@selector(moreForVideo) forControlEvents:UIControlEventTouchUpInside];
             homeCell.ImageView.image = [UIImage imageNamed:@"fav_video.png"];
            break;
//        case 2:
//            homeCell.TitleLabel.text = @"我的壁报";
//            if (_share.MyBiBaoDic) {
//                homeCell.SubTitleLabel.text = [_share.MyBiBaoDic stringForKey:@"title"];
//            }else {
//                homeCell.SubTitleLabel.text = @"暂无浏览内容";
//            }
//            [homeCell.moreButton addTarget:self action:@selector(moreForBibao) forControlEvents:UIControlEventTouchUpInside];
//             homeCell.ImageView.image = [UIImage imageNamed:@"home_bibao.png"];
//            break;
        case 2:
            homeCell.TitleLabel.text = @"我的幻灯";
            if (_share.MyPPTDic) {
                homeCell.SubTitleLabel.text = [_share.MyPPTDic stringForKey:@"title"];
            }else {
                homeCell.SubTitleLabel.text = @"暂无浏览内容";
            }

            [homeCell.moreButton addTarget:self action:@selector(moreForPPT) forControlEvents:UIControlEventTouchUpInside];
            homeCell.ImageView.image = [UIImage imageNamed:@"fav_ppt.png"];
            
            break;
        case 4:
            homeCell.TitleLabel.text = @"我的工具";
            if (_share.MyToolsDic) {
                homeCell.SubTitleLabel.text = [_share.MyToolsDic stringForKey:@"title"];
            }else {
                homeCell.SubTitleLabel.text = @"暂无浏览内容";
            }

            [homeCell.moreButton addTarget:self action:@selector(moreForTools) forControlEvents:UIControlEventTouchUpInside];
             homeCell.ImageView.image = [UIImage imageNamed:@"fav_tool.png"];

            break;
        default:
            break;
    }
    
    
    return cell;
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)moreForZhiNan {

    MyZhiNanMoreViewController * ExplainList = [[[MyZhiNanMoreViewController alloc] init] autorelease];
    [self.navigationController pushViewController:ExplainList animated:YES];
}
-(void) moreForNote {
    MyNoteMoreViewController * NoteList = [[[MyNoteMoreViewController alloc] init] autorelease];
    [self.navigationController pushViewController:NoteList animated:YES];
}
-(void) moreForBibao {
    MyBiBaoViewController * NoteList = [[[MyBiBaoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:NoteList animated:YES];
}
-(void) moreForPPT {
    HKMySelectedPPTViewController * NoteList = [[[HKMySelectedPPTViewController alloc] init] autorelease];
    [self.navigationController pushViewController:NoteList animated:YES];
}
-(void) moreForVideo {
    HKMySelectedVideoViewController * NoteList = [[[HKMySelectedVideoViewController alloc] init] autorelease];
    [self.navigationController pushViewController:NoteList animated:YES];
}
-(void) moreForTools {
    HKMySelectedToolsViewController * NoteList = [[[HKMySelectedToolsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:NoteList animated:YES];

}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_share.MyZhiNanDic == nil) {
            MyZhiNanMoreViewController * ExplainList = [[[MyZhiNanMoreViewController alloc] init] autorelease];
            [self.navigationController pushViewController:ExplainList animated:YES];

        }
        else {
            MyZhiNanViewController * MyZhiNan = [[[MyZhiNanViewController alloc] init] autorelease];
            [self.navigationController pushViewController:MyZhiNan animated:YES];

        }
    }
    if (indexPath.row == 1) {
        if (_share.MyNoteDic == nil) {
            MyNoteMoreViewController * notemore = [[MyNoteMoreViewController new] autorelease];
            [self.navigationController pushViewController:notemore animated:YES];
        }else {
            MyNoteViewController * myNote = [[[MyNoteViewController alloc] init] autorelease];
            [self.navigationController pushViewController:myNote animated:YES];
        }
    }
    //video
    if (indexPath.row == 3) {
        if (_share.MyVideoDic == nil) {
            HKMySelectedVideoViewController * video = [[HKMySelectedVideoViewController new] autorelease];
            [self.navigationController pushViewController:video animated:YES];
        }
        else {
            HKReviewVideoViewController * myNote = [[[HKReviewVideoViewController alloc] init] autorelease];
            [self.navigationController pushViewController:myNote animated:YES];
        }
    }
    //poster
//    if (indexPath.row == 2) {
//        HKReviewBiBaoViewController * myNote = [[[HKReviewBiBaoViewController alloc] init] autorelease];
//        [self.navigationController pushViewController:myNote animated:YES];
//    }
    //ppt
    if (indexPath.row == 2) {
        if (_share.MyPPTDic == nil) {
            HKMySelectedPPTViewController * ppt = [[HKMySelectedPPTViewController new] autorelease];
            [self.navigationController pushViewController:ppt animated:YES];
        }
        else {
            HKReviewPPTViewController * myNote = [[[HKReviewPPTViewController alloc] init] autorelease];
            [self.navigationController pushViewController:myNote animated:YES];
        }
    }
    if (indexPath.row == 4) {
        if (_share.MyToolsDic == nil) {
            HKMySelectedToolsViewController * tool = [[HKMySelectedToolsViewController new] autorelease];
            [self.navigationController pushViewController:tool animated:YES];
        }else {
            HKReviewToolsViewController * myNote = [[[HKReviewToolsViewController alloc] init] autorelease];
            [self.navigationController pushViewController:myNote animated:YES];
        }
    }



}


#pragma mark - left button and tap

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.parentViewController.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}

#pragma mark button click
-(void) btnClick:(id) sender{
    UIButton *curButton = (UIButton*)sender;
    
    UIAlertView *msg;
    UIViewController* sub;
    
    
    switch (curButton.tag) {
            
        case 100:
            sub = [[[HKGuidListViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            sub.title =@"我的指南";
            [self.navigationController pushViewController:sub animated:true];
            
            
            break;
        case 101:{
            sub = [[[HKMyCommonsViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            sub.title =@"我的笔记";
            [self.navigationController pushViewController:sub animated:true];
            
        }
            break;
            
        case 102:{
            
            sub = [[[HKMyPosterViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            [self.navigationController pushViewController:sub animated:YES];
            
            //HKMyVideosViewController
            
        }
            break;
            
        case 103:{
            
            sub = [[[HKMyVideosViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            [self.navigationController pushViewController:sub animated:YES];
            //HKMyPPTsViewController
            
        }
            break;
        case 104:{
            
            sub = [[[HKMyPPTsViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            [self.navigationController pushViewController:sub animated:YES];
            //HKMyPPTsViewController
            
        }
            break;
            
        case 105:{
            
            sub = [[[HKHisToolsViewController alloc] initWithNibName:@"HKHisToolsViewController" bundle:nil] autorelease];
            sub.title = @"我的工具";
            [self.navigationController pushViewController:sub animated:YES];
            
        }
            break;
            
            
        default:
            msg = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"敬请期待 ^_^" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            
            [msg show];
            
            [msg release];
            
            break;
    }
}
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放JSON的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[[NSData alloc] initWithContentsOfFile:realPath] autorelease];
    return dataInfile;
}
@end
