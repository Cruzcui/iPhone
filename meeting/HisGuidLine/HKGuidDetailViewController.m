//
//  HKGuidDetailViewController.m
//  HisGuidline
//
//  Created by kimi on 13-9-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKGuidDetailViewController.h"
#import "HHDomainBase.h"
#import "MeetingConst.h"
#import "HKWebViewController.h"
#import "SBJson.h"
#import "GuidDetailHeaderView.h"
#import "PingLunViewController.h"
#import "DafenCell.h"
#import "PostLPingLunView.h"
#import "SocreView.h"
#import "HKExplainDetailViewController.h"
#import "HKMyVideosViewController.h"
#import "MyNoteMoreViewController.h"
#import "MyProfile.h"
#import "ShareInstance.h"
#define  cellhight 70
@interface HKGuidDetailViewController ()

@property (nonatomic,assign) NSDictionary* guidData;
@property (nonatomic,assign) NSArray* sections;
@property (nonatomic,retain) NSMutableDictionary* selectedSectionsIndex;
@property (nonatomic,retain) GuidDetailHeaderView *headerView;
@property (nonatomic,retain) NSDictionary * titleDic;


@property (nonatomic,retain) NSIndexPath* currentIndexPath;

@end

@implementation HKGuidDetailViewController

@synthesize guidline;
@synthesize guidData;
@synthesize sections;
@synthesize selectedSectionsIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

-(id) initWithStyle:(UITableViewStyle)style GuidLine:(NSArray *)guidl andPkey:(NSString *)pkey andtitleDic:(NSDictionary *)titleDic andAllNodes:(NSMutableArray *)allNodes{
    self = [self initWithStyle:style];
    
    if (self) {
        _domainPingLun = [[HKCategorySearchDomain alloc] init];
        [_domainPingLun setDelegate:self];
        _domainScore = [[HKCategorySearchDomain alloc] init];
        [_domainScore setDelegate:self];
        self.allNodes = [[[NSMutableArray alloc] init] autorelease];
        self.childrenNodes = [[[NSMutableArray alloc] init] autorelease];
        _ScoreData = [[NSArray alloc] init];
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:guidl];
        _PingLunArray = [[NSArray alloc] init];
        self.pkey = pkey;
        self.titleDic = titleDic;
        _flag = 0;
        _btnFlag = 0;
//        self.guidData = [[guidl dictionaryForKey:Json_GuidData] dictionaryForKey:JsonHead_data];
        
//        self.title = [self.guidData stringForKey:Json_Guid_Name];
//        
//        self.sections = [self.guidline arrayForKey:Json_Guid_Section];
//        
        self.selectedSectionsIndex = [NSMutableDictionary dictionaryWithCapacity:self.sections.count];
        
        self.tableView.backgroundColor = [UIColor colorWithRed: 240.0/255 green: 240.0/255 blue: 240.0/255 alpha: 1.0];
        self.title = [self.titleDic stringForKey:@"title"];
        _share = [ShareInstance instance];
        [_share.ZhiNanMuLu removeAllObjects];
        [self searchAllNodes:_dataSourceArray];
        //每个节点设置属性，展开与否，加减号与否，缩进与否
        for (NSString * node in self.allNodes) {
            NSDictionary * nodesdic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Zhankai",@"0",@"suojin", nil];
            [_share.ZhiNanMuLu setObject:nodesdic forKey:node];
        }

    }
    
    return self;
}

-(void) dealloc{
    
    self.guidData = nil;
    self.sections = nil;
    self.guidline = nil;
    _ScoreData = nil;
   _PingLunArray = nil;
    [_domainScore release];
    self.selectedSectionsIndex = nil;
    [_dataSourceArray release];
    [_domainPingLun release];
    [_flagBool release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //headerView
    _headerView = [[GuidDetailHeaderView alloc] init];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GuidDetailHeaderView" owner:self options:nil];
    
    _headerView = [array objectAtIndex:0];
    [_headerView setFrame:CGRectMake(0, 0, 320, 150)];
        _headerView.titlelabel.text = [self.titleDic stringForKey:@"title"];
    _headerView.publisherlabel.text = [self.titleDic stringForKey:@"publisher"];
    [_headerView.btnPingLun addTarget:self action:@selector(Pinglun) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.btnDaFen addTarget:self action:@selector(DaFen) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.tableViewheader setDataSource:self];
    [_headerView.tableViewheader setDelegate:self];
   
    
    
    self.tableView.tableHeaderView = _headerView;
    
    if ([self SelectedFav]) {
          [_headerView.btnselected setBackgroundImage:[UIImage imageNamed:@"guid_fav.png"] forState:UIControlStateNormal];
    } else {
          [_headerView.btnselected setBackgroundImage:[UIImage imageNamed:@"guid_unfav.png"] forState:UIControlStateNormal];
    }
    
    //ppt
    [_headerView.btnppt addTarget:self action:@selector(goPPT) forControlEvents:UIControlEventTouchUpInside];
    //video
     [_headerView.btnvideo addTarget:self action:@selector(goVideo) forControlEvents:UIControlEventTouchUpInside];
    //selected
     [_headerView.btnselected addTarget:self action:@selector(goSelected) forControlEvents:UIControlEventTouchUpInside];
    //pizhu
     [_headerView.btnpizhu addTarget:self action:@selector(goPizhu) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //评论数据请求
    //打分数据请求
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sectionChange:) name:Notifaction_Change_Section object:nil];
    
    
    UIView * viewfooter = [[[UIView alloc] init] autorelease];
    self.tableView.tableFooterView = viewfooter;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _headerView.btnppt.hidden = self.pptflag;
    _headerView.btnvideo.hidden = self.videoflag;
    if (self.pptflag && self.pptflag) {
        [_headerView.btnselected setFrame:CGRectMake(85, 115, 69, 27)];
        [_headerView.btnpizhu setFrame:CGRectMake(165, 115, 69, 27)];

    } else {
        [_headerView.btnppt setFrame:CGRectMake(46, 115, 69, 27)];
        [_headerView.btnvideo setFrame:CGRectMake(46, 115, 69, 27)];
        [_headerView.btnselected setFrame:CGRectMake(125, 115, 69, 27)];
        [_headerView.btnpizhu setFrame:CGRectMake(205, 115, 69, 27)];
    }
    
}


-(void) goPPT {
 
    NSData * data = [self WriteLocalFile:self.pkey andsavefile:@"index"];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary * dic = [parser objectWithData:data];
    [parser release];
    HKExplainDetailViewController *detail = [[HKExplainDetailViewController alloc] initWithStyle:UITableViewStylePlain ExplainData:dic];
        
        detail.displayType = 0;
        
        [self.navigationController pushViewController:detail animated:YES];

}
-(void) goVideo {
    NSData * data = [self WriteLocalFile:self.pkey andsavefile:@"index"];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary * dic = [parser objectWithData:data];
    [parser release];
    HKMyVideosViewController * video = [[[HKMyVideosViewController alloc] init] autorelease];
    video.flag = YES;
    video.titleDic = dic;
    [video getDataFromVidio:dic];
    [self.navigationController pushViewController:video animated:YES];

}
-(void) goSelected {
    MyProfile * profile = [MyProfile myProfile];
    if ([profile indexOfFaved:Fav_Type_MedGuid key:self.pkey] == -1) {
        [profile saveFavFor:Fav_Type_MedGuid data:self.titleDic key:self.pkey];
        [_headerView.btnselected setBackgroundImage:[UIImage imageNamed:@"guid_fav.png"] forState:UIControlStateNormal];
    }else {
        [profile deleteFavFor:Fav_Type_MedGuid key:self.pkey];
        ShareInstance * share = [ShareInstance instance];
        if ([[share.MyZhiNanDic stringForKey:@"pkey"] isEqualToString:self.pkey]) {
             share.MyZhiNanDic = nil;
        }
         [_headerView.btnselected setBackgroundImage:[UIImage imageNamed:@"guid_unfav.png"] forState:UIControlStateNormal];
    }
}

-(BOOL) SelectedFav {
     MyProfile * profile = [MyProfile myProfile];
    if ([profile indexOfFaved:Fav_Type_MedGuid key:self.pkey] == -1) {
        return NO;
    }else {
        return  YES;
    }
}
-(void) goPizhu {
    MyNoteMoreViewController * pizhu = [[MyNoteMoreViewController new] autorelease];
    pizhu.jingduFlag = YES;
    pizhu.pkey = self.pkey;
    [self.navigationController pushViewController:pizhu animated:YES];
    
}
-(void) Pinglun {
    _btnFlag = 1;
      NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[self.titleDic stringForKey:@"pkey"] forKey:@"medguidekey"];
    [params setObject:@"1" forKey:@"pageNumber"];
    [params setObject:@"3" forKey:@"pageSize"];
    [_domainPingLun getDOmainPingLun:params];
    window = [UIApplication sharedApplication].keyWindow;
    _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

    self.tableView.tableHeaderView = _headerView;
    [_headerView.tableViewheader reloadData];
}
-(void)DaFen {
    _btnFlag = 2;
    NSMutableDictionary * paramsScore = [NSMutableDictionary dictionary];
    [paramsScore setObject:[self.titleDic stringForKey:@"pkey"] forKey:@"medguidekey"];
    [_domainScore getScore:paramsScore];
    window = [UIApplication sharedApplication].keyWindow;
    _hud1 = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _hud1.mode = MBProgressHUDModeCustomView;
    _hud1.labelText = @"loading";

    [_headerView setFrame:CGRectMake(0, 0, 320, 150 + 170)];
    self.tableView.tableHeaderView = _headerView;
    [_headerView.tableViewheader reloadData];
}
//接收网络返回数据
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domainPingLun) {
        _PingLunArray = [domainData dataDetails];
        [_headerView.tableViewheader reloadData];
        [self.tableView reloadData];
        if ([_PingLunArray count] >= 3) {
            [_headerView setFrame:CGRectMake(0, 0, 320, 150 + cellhight*2 + 30)];
        }else {
            [_headerView setFrame:CGRectMake(0, 0, 320, 150 + cellhight*[_PingLunArray count] + 30)];
        }

        self.tableView.tableHeaderView = _headerView;

        [MBProgressHUD hideHUDForView:window animated:YES];
    }
    if (domainData == _domainScore) {
        _ScoreData = [domainData dataDetails];
        [MBProgressHUD hideHUDForView:window animated:YES];
        [_headerView.tableViewheader reloadData];

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView == _headerView.tableViewheader) {
//        
//        return 1;
//        
//    }
//    if (tableView == self.tableView) {
//         return [_dataSourceArray count];
//    }
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _headerView.tableViewheader) {
        if (_btnFlag == 1) {
            if ([_PingLunArray count] >= 2) {
                _flag = 1;
                return 3;
            }
            else if ([_PingLunArray count] == 0) {
                _flag = 0;
                return 1;
            } else {
                _flag = 2;
                return [_PingLunArray count] + 1;
            }

        }
        if (_btnFlag == 2) {
            return  1;
        }
        
    }
    
    return [_dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _headerView.tableViewheader) {
        if (_btnFlag == 1) {
            if (_flag == 0) {
                //只显示按钮
                
                if (indexPath.row == 0) {
                    static NSString *CellIdentifiersbtn = @"Cellsbtn";
                    PingLunBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersbtn];
                    
                    if (cell==nil) {
                        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PingLuBtnCell" owner:self options:nil];
                        
                        cell = [array objectAtIndex:0];
                        [cell.btnPinglunList addTarget:self action:@selector(getPingLunList) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnPinglunPost addTarget:self action:@selector(postList) forControlEvents:UIControlEventTouchUpInside];
                    }
                    //cell.contentView.backgroundColor = [UIColor whiteColor];
                    return  cell;
                }
                
                
            }
            if (_flag == 1) {
                //显示3行，最后一行为anniu
                if (indexPath.row != 2) {
                    static NSString *CellIdentifiers = @"Cells";
                    PingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                    
                    if (cell==nil) {
                        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PingLunCell" owner:self options:nil];
                        
                        cell = [array objectAtIndex:0];
                    }
                    NSDictionary * dic = [_PingLunArray objectAtIndex:indexPath.row];
                    cell.labelName.text = [dic stringForKey:@"userid"];
                    cell.labelContent.text = [dic stringForKey:@"comments"];
                    //Time处理
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic stringForKey:@"ratingdt"] doubleValue] / 1000];
                    //时间戳转时间的方法:
                    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                    
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    cell.time.text = confromTimespStr;
                    [formatter release];

                    cell.contentView.backgroundColor = [UIColor whiteColor];

                    return  cell;
                }else {
                    static NSString *CellIdentifiersbtns = @"Cellsbtns";
                    PingLunBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersbtns];
                    
                    if (cell==nil) {
                        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PingLuBtnCell" owner:self options:nil];
                        
                        cell = [array objectAtIndex:0];
                        [cell.btnPinglunList addTarget:self action:@selector(getPingLunList) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnPinglunPost addTarget:self action:@selector(postList) forControlEvents:UIControlEventTouchUpInside];
                    }
                    //cell.contentView.backgroundColor = [UIColor whiteColor];

                    return  cell;
                }
                
                
            }
            if (_flag == 2) {
                //显示2行。最后一行为按钮
                if (indexPath.row == 0) {
                    static NSString *CellIdentifierss = @"Cellss";
                    PingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierss];
                    
                    if (cell==nil) {
                        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PingLunCell" owner:self options:nil];
                        
                        cell = [array objectAtIndex:0];
                    }
                    NSDictionary * dic = [_PingLunArray objectAtIndex:indexPath.row];
                    cell.labelName.text = [dic stringForKey:@"userid"];
                    cell.labelContent.text = [dic stringForKey:@"comments"];
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic stringForKey:@"ratingdt"] doubleValue] / 1000];
                    //时间戳转时间的方法:
                    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                    
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                    cell.time.text = confromTimespStr;
                    [formatter release];

                  

                   //cell.contentView.backgroundColor = [UIColor whiteColor];

                    return  cell;
                }
                else {
                    static NSString *CellIdentifiersbtnss = @"Cellsbtnss";
                    PingLunBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersbtnss];
                    
                    if (cell==nil) {
                        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PingLuBtnCell" owner:self options:nil];
                        
                        cell = [array objectAtIndex:0];
                        [cell.btnPinglunList addTarget:self action:@selector(getPingLunList) forControlEvents:UIControlEventTouchUpInside];
                        [cell.btnPinglunPost addTarget:self action:@selector(postList) forControlEvents:UIControlEventTouchUpInside];
                    }
                    return  cell;
                    
                }
            }

        }
        if (_btnFlag == 2) {
            static NSString *CellIdentifiersbtnDafen = @"CellsbtnDafen";
            DafenCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersbtnDafen];
            
            if (cell==nil) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DaFenCell" owner:self options:nil];
                
                cell = [array objectAtIndex:0];
            }
            int count = 0;
            int people = 0;
            int max = 0;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            for (NSDictionary * dic in _ScoreData) {
                
                
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"rating"]] isEqualToString:@"5"]) {
                    cell.fiveStar.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ratingCount"]];
                    count = count + 5*[[dic objectForKey:@"ratingCount"] intValue];
                    people = people + [[dic objectForKey:@"ratingCount"] intValue];
                    if (max < [[dic objectForKey:@"ratingCount"] intValue]) {
                        max = [[dic objectForKey:@"ratingCount"] intValue];
                    }
                }
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"rating"]] isEqualToString:@"4"]) {
                    cell.fourStrar.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ratingCount"]];
                    count = count + 4*[[dic objectForKey:@"ratingCount"] intValue];
                    people = people + [[dic objectForKey:@"ratingCount"] intValue];
                    if (max < [[dic objectForKey:@"ratingCount"] intValue]) {
                        max = [[dic objectForKey:@"ratingCount"] intValue];
                    }
                }
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"rating"]] isEqualToString:@"3"]) {
                    cell.threeStar.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ratingCount"]];
                    count = count + 3*[[dic objectForKey:@"ratingCount"] intValue];
                    people = people + [[dic objectForKey:@"ratingCount"] intValue];
                    if (max < [[dic objectForKey:@"ratingCount"] intValue]) {
                        max = [[dic objectForKey:@"ratingCount"] intValue];
                    }
                }
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"rating"]] isEqualToString:@"2"]) {
                    cell.twoStar.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ratingCount"]];
                    count = count + 2*[[dic objectForKey:@"ratingCount"] intValue];
                    people = people + [[dic objectForKey:@"ratingCount"] intValue];
                    if (max < [[dic objectForKey:@"ratingCount"] intValue]) {
                        max = [[dic objectForKey:@"ratingCount"] intValue];
                    }
                }
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"rating"]] isEqualToString:@"1"]) {
                    cell.oneStar.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ratingCount"]];
                    count = count + [[dic objectForKey:@"ratingCount"] intValue];
                    people = people + [[dic objectForKey:@"ratingCount"] intValue];
                    if (max < [[dic objectForKey:@"ratingCount"] intValue]) {
                        max = [[dic objectForKey:@"ratingCount"] intValue];
                    }
                }

            }
            if (count !=0 && people !=0 && max !=0) {
                CGRect rect5 = cell.fiveLine.bounds;
                rect5.size.width = (87 / max)*([cell.fiveStar.text intValue]);
                //[cell.fourLine setFrame:rect5];
                [cell setFrameToLine5:rect5];
                CGRect rect4 = cell.fourLine.bounds;
                rect4.size.width = (87 / max)*([cell.fourStrar.text intValue]);
                //[cell.fourLine setFrame:rect4];
                [cell setFrameToLine4:rect4];
                
                CGRect rect3 = cell.threeLine.bounds;
                rect3.size.width = (87 / max)*([cell.threeStar.text intValue]);
                //[cell.threeLine setFrame:rect3];
                [cell setFrameToLine3:rect3];
                
                CGRect rect2 = cell.twoLine.bounds;
                rect2.size.width = (87 / max)*([cell.twoStar.text intValue]);
                NSLog(@"%d",[cell.twoLine.text intValue]);
                //[cell.twoLine setFrame:rect2];
                [cell setFrameToLine2:rect2];
                
                CGRect rect = cell.oneLine.bounds;
                rect.size.width = (87 / max)*([cell.oneStar.text intValue]);
                //[cell.oneLine setFrame:rect];
                
                [cell setFrameToLine1:rect];
                
                if (count / people == 5) {
                    cell.averageStar.text = @"★★★★★";
                }
                if (count / people == 4) {
                    cell.averageStar.text = @"★★★★☆";
                }
                if (count / people == 3) {
                    cell.averageStar.text = @"★★★☆☆";
                }
                if (count / people == 2) {
                    cell.averageStar.text = @"★★☆☆☆";
                }
                if (count / people == 1) {
                    cell.averageStar.text = @"★☆☆☆☆";
                }
                if (count / people == 0) {
                    cell.averageStar.text = @"☆☆☆☆☆";
                }
                cell.totalCount.text = [NSString stringWithFormat:@"总评分人数%d人，平均评分%d",people,(count / people)];

            }
                       [cell.btnDaFen addTarget:self action:@selector(MyScore) forControlEvents:UIControlEventTouchUpInside];
            return  cell;

        }

    }
    
    static NSString *CellIdentifier = @"Cell";
    ZhiNanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZhiNanViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
    }
    [cell setCellDelegate:self];
    cell.PkeyinCell = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"pkey"];
    if ([[[_dataSourceArray objectAtIndex:indexPath.row]arrayForKey:@"children"] count] == 0) {
        [cell.btnExplain setImage:nil forState:UIControlStateNormal];
    }else {
        if ( [[[_share.ZhiNanMuLu objectForKey:cell.PkeyinCell] objectForKey:@"Zhankai"] isEqualToString:@"0"]) {
              [cell.btnExplain setImage:nil forState:UIControlStateNormal];
            [cell.btnExplain setImage:[UIImage imageNamed:@"icon_guid_more.png"] forState:UIControlStateNormal];

        }
        if ( [[[_share.ZhiNanMuLu objectForKey:cell.PkeyinCell] objectForKey:@"Zhankai"] isEqualToString:@"1"]) {
            [cell.btnExplain setImage:nil forState:UIControlStateNormal];
            [cell.btnExplain setImage:[UIImage imageNamed:@"icon_guid_less.png"] forState:UIControlStateNormal];
            
        }

    }
    NSDictionary * nodedic = [_share.ZhiNanMuLu objectForKey:cell.PkeyinCell];
    int SpaceNumber = [[nodedic objectForKey:@"suojin"] intValue];

    NSMutableString * space = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i < SpaceNumber; i ++) {
        [space appendString:@"   "];
    }
    cell.contentLabel.text =[NSString stringWithFormat:@"%@%@",space,[[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"sectionname"]] ;
    
    cell.RowNumber = indexPath.row;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    

    
    
    
    return cell;
}

//- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
//{
//    cell.backgroundColor =  indexPath.row==0?[UIColor colorWithRed: 240.0/255 green: 240.0/255 blue: 240.0/255 alpha: 1.0]: [UIColor whiteColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//}


#pragma mark - Table view delegate


-(NSString*) getHTMLContent:(NSIndexPath*) indexPath{
    
    if ([[[_dataSourceArray objectAtIndex:indexPath.row] arrayForKey:@"children"] count] > 0) {
        //点击根目录，显示所有子节点
        NSArray * nodeArray = [[_dataSourceArray objectAtIndex:indexPath.row] arrayForKey:@"children"];
        [self.childrenNodes removeAllObjects];
        [self searchChildrenlNodes:nodeArray];
        NSMutableString * strHTML = [[NSMutableString new] autorelease];
        for (NSDictionary * node in self.childrenNodes) {
            NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,node]];
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * dicdata = [parser objectWithData:data];
            [parser release];
            NSString* filePaht = [dicdata stringForKey:@"content"];
            [strHTML appendString:filePaht];
        }
        
        //NSString* title = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"sectionname"];
        NSLog(@"%@",strHTML);
        
        return strHTML;
        //[self showHTMLWebView:strHTML Title:title];
        
    }
    else {
        NSString * pkey = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"pkey"];
        NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,pkey]];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * dicdata = [parser objectWithData:data];
        [parser release];
        NSString* filePaht = [dicdata stringForKey:@"content"];
        
        return filePaht;
        
        //NSString* title = [dicdata stringForKey:@"sectionname"];
        //[self showHTMLWebView:filePaht Title:title];
        
    }
    
}

-(NSString*) getHTMLTitle:(NSIndexPath*) indexPath{
    
    if ([[[_dataSourceArray objectAtIndex:indexPath.row] arrayForKey:@"children"] count] > 0) {
        
        
        NSString* title = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"sectionname"];
        
        return title;
        //[self showHTMLWebView:strHTML Title:title];
        
    }
    else {
        NSString * pkey = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"pkey"];
        NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,pkey]];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * dicdata = [parser objectWithData:data];
        [parser release];
        //NSString* filePaht = [dicdata stringForKey:@"content"];
        
        //return filePaht;
        
        return [dicdata stringForKey:@"sectionname"];
        //[self showHTMLWebView:filePaht Title:title];
        
    }
}


-(void) showHTMLWebView:(NSString*) filePaht Title:(NSString*) title{
    
    NSString* fullPaht = [[self.guidline stringForKey:Json_GuidFolder] stringByAppendingFormat:@"/%@",filePaht];
    
    NSLog(@"fullPaht:%@",fullPaht);
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                               bundle:nil
                                                                                Title:title
                                                                                  HTML:filePaht] autorelease];
    webController.ZhiNanflag = YES;
    webController.titleDics = self.titleDic;
    
    [self.navigationController pushViewController:webController animated:YES];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
        
        self.currentIndexPath = indexPath;
        
        NSString* htmlContent = [self getHTMLContent:indexPath];
        NSString* title = [self getHTMLTitle:indexPath];
        [self showHTMLWebView:htmlContent Title:title];
        
        /*
        if ([[[_dataSourceArray objectAtIndex:indexPath.row] arrayForKey:@"children"] count] > 0) {
            //点击根目录，显示所有子节点
            NSArray * nodeArray = [[_dataSourceArray objectAtIndex:indexPath.row] arrayForKey:@"children"];
            [self.childrenNodes removeAllObjects];
            [self searchChildrenlNodes:nodeArray];
            NSMutableString * strHTML = [[NSMutableString new] autorelease];
            for (NSDictionary * node in self.childrenNodes) {
                NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,node]];
                SBJsonParser * parser = [[SBJsonParser alloc]init];
                NSDictionary * dicdata = [parser objectWithData:data];
                [parser release];
                NSString* filePaht = [dicdata stringForKey:@"content"];
                [strHTML appendString:filePaht];
            }
            
            NSString* title = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"sectionname"];
            NSLog(@"%@",strHTML);
            [self showHTMLWebView:strHTML Title:title];
            
        }
        else {
            NSString * pkey = [[_dataSourceArray objectAtIndex:indexPath.row] stringForKey:@"pkey"];
            NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,pkey]];
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * dicdata = [parser objectWithData:data];
            [parser release];
            NSString* filePaht = [dicdata stringForKey:@"content"];
            NSString* title = [dicdata stringForKey:@"sectionname"];
            [self showHTMLWebView:filePaht Title:title];

        }
         */
        
    }
    
        
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _headerView.tableViewheader) {
        if (_btnFlag == 1) {
            if (_flag == 0) {
                return 30;
            }
            if (_flag == 1) {
                if (indexPath.row == 2) {
                    return 30;
                } else {
                    return cellhight;
                }
            }
            if (_flag == 2) {
                if (indexPath.row == 1) {
                    return 30;
                }
                else {
                    return cellhight;
                }
            }
        }
        if (_btnFlag == 2) {
            return 170;
        }
    }
    return 40;
}
//读取本地文件
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:realPath];
    return dataInfile;
}
-(void)getPingLunList {
    NSLog(@"list");
    PingLunViewController * pinglunList = [[[PingLunViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:self.titleDic andPkey:self.pkey] autorelease];
    [self.navigationController pushViewController:pinglunList animated:YES];
    
    
}
-(void)postList {
    NSLog(@"post");
    SocreView * scoreView = [[[SocreView alloc] initWithNibName:@"SocreView" bundle:nil andGuidLine:self.titleDic andPkey:self.pkey] autorelease];
    [self.navigationController pushViewController:scoreView animated:YES];
    
}
-(void)MyScore {
    SocreView * scoreView = [[[SocreView alloc] initWithNibName:@"SocreView" bundle:nil andGuidLine:self.titleDic andPkey:self.pkey] autorelease];
    [self.navigationController pushViewController:scoreView animated:YES];
}
-(void)addRows:(NSArray *)children andRowNumber:(int)row andParentsPkey:(NSString *)Parentspkey{
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i=row + 1; i<= row + [children count]; i++) {
        
       [_dataSourceArray insertObject:[children objectAtIndex:i-row - 1] atIndex:i];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [indexPaths addObject: indexPath];
        
    }
    //判断缩进宽度
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [mutableDictionary setDictionary:[_share.ZhiNanMuLu objectForKey:Parentspkey]];
    //取得父节点得缩进宽度
    NSString * suojin = [mutableDictionary objectForKey:@"suojin"];
       for (NSDictionary * dic in children) {
        NSString * chiledrenPeky = [dic stringForKey:@"pkey"];
        NSMutableDictionary * CDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
        [CDictionary setDictionary:[_share.ZhiNanMuLu objectForKey:chiledrenPeky]];
        //自节点缩进宽度位父节点缩进宽度＋1
        NSString * suojinC =[NSString stringWithFormat:@"%d",[suojin intValue] + 1] ;
        [CDictionary setObject:suojinC forKey:@"suojin"];
        [_share.ZhiNanMuLu setObject:CDictionary forKey:chiledrenPeky];

    }
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewScrollPositionNone];
    
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
}

-(void)delRows:(NSArray *)children andRowNumber:(int)row{
    
    if ([children count] > 0) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i=row + 1; i<= row + [children count]; i++) {
            
         
            [_dataSourceArray removeObjectAtIndex:row + 1];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [indexPaths addObject: indexPath];
            
        }
      
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView endUpdates];
        [self.tableView reloadData];

    }
  
    
}
-(void) change:(NSString *)pkey andRowNumber:(int)RowNumber{
      NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,pkey]];
      SBJsonParser * parser = [[SBJsonParser alloc]init];
      NSDictionary * dicdata = [parser objectWithData:data];
      [parser release];
      [self addRows:[dicdata arrayForKey:@"children"] andRowNumber:RowNumber andParentsPkey:pkey];
    
    
}
-(void) changeShouSuo:(NSString *)pkey andRowNumber:(int)RowNumber {
    NSData * data = [self WriteLocalFile:self.pkey andsavefile:[NSString stringWithFormat:@"%@with%@",self.pkey,pkey]];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary * dicdata = [parser objectWithData:data];
    [parser release];
    [self delRows:[dicdata arrayForKey:@"children"] andRowNumber:RowNumber];

}
//遍历所有目录
-(void) searchAllNodes:(NSArray * )Nodes {
    if ([Nodes count] > 0) {
        for (NSDictionary * dic in Nodes) {
            [self.allNodes addObject:[dic stringForKey:@"pkey"]];
            [self searchAllNodes:[dic arrayForKey:@"children"]];
        }
    }
    return;
}
//遍历所有目录
-(void) searchChildrenlNodes:(NSArray * )Nodes {
    if ([Nodes count] > 0) {
        for (NSDictionary * dic in Nodes) {
            [self.childrenNodes addObject:[dic stringForKey:@"pkey"]];
            [self searchChildrenlNodes:[dic arrayForKey:@"children"]];
        }
    }
    return;
}

#pragma notifaction
-(void) sectionChange:(NSNotification *) notify {
    NSDictionary * dic = [notify object];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    
    if ([[dic stringForKey:@"type"] isEqualToString:@"-1"]) { //上一章
        
        if (self.currentIndexPath.row >0) {
            self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row-1 inSection:0];
        }
        
    }else if([[dic stringForKey:@"type"] isEqualToString:@"1"]){ //下一章
        
        if (self.currentIndexPath.row < _dataSourceArray.count-1) {
            self.currentIndexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row+1 inSection:0];
        }
        
    }
    
    [params setObject:self.currentIndexPath forKey:@"indexPath"];
    [params setObject:[self getHTMLContent:self.currentIndexPath] forKey:@"HTMLContent"];
    [params setObject:[self getHTMLTitle:self.currentIndexPath] forKey:@"HTMLTitle"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_DidChange_Section object:params];
    
    
}

@end
