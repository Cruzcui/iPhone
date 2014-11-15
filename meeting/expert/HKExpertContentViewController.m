//
//  HKHelpContentViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKExpertContentViewController.h"
#import "UIImageView+WebCache.h"

@interface HKExpertContentViewController ()

@end

@implementation HKExpertContentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKExpertDomain alloc] init];
        [_domain setDelegate:self];
        _domainForList = [[HKExpertDomain alloc] init];
        [_domainForList setDelegate:self];

        _paramDic = [[NSMutableDictionary alloc] init];
        _NumberOfPage = 1;
        _dataSourceArray = [[NSMutableArray alloc] init];
        self.title = @"对话权威";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   Expertheader = [[[NSBundle mainBundle] loadNibNamed:@"ExpertHeader" owner:self options:nil] objectAtIndex:0];
  
    self.tableView.tableHeaderView = Expertheader;

    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self loadMore];
    };
//初始化页面加载数据
//获取专家介绍
    NSMutableDictionary * expertContent = [NSMutableDictionary dictionary];
    if ([self.ContentDic stringForKey:@"userid"] == NULL) {
        [expertContent setObject:[self.ContentDic stringForKey:@"userid"] forKey:@"authorId"];
        [_domain getExpertContent:_paramDic];
    }
    
//获取问题及回复内容
//    medguidekey=1   指南ID
//    pageNumber=1 第几页
//    pageSize=10
    
    [_paramDic setObject:[self.ContentDic stringForKey:@"pkey"] forKey:@"medguidekey"];
    [_paramDic setObject:@"10" forKey:@"pageSize"];
    [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
    [_domainForList getQuestionAndReplayList:_paramDic];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [_dataSourceArray removeAllObjects];
        _NumberOfPage = 1;
        [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
        [_domainForList getQuestionAndReplayList:_paramDic];

    }
}
-(void)loadMore {
    _NumberOfPage ++;
     [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
     [_domainForList getQuestionAndReplayList:_paramDic];
}
//获取网络数据
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        NSDictionary * expertDic = [domainData dataDictionary];
        [Expertheader.TouXiang setImageWithURL:[NSURL URLWithString:[expertDic stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"alert.png"]];
        Expertheader.expertName.text = [expertDic stringForKey:@"username"];
        Expertheader.expertDetails.text = [expertDic stringForKey:@"userdesc"];
    }
    if (domainData == _domainForList) {
        NSArray * array = [domainData dataDetails];
        for (NSDictionary * dic in array) {
            [_dataSourceArray addObject:dic];
        }
        [self.tableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%d",[_dataSourceArray count] + 1);
    return [_dataSourceArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section != 0) {
            NSDictionary * requestDic = [_dataSourceArray objectAtIndex:section - 1];
            NSArray * reArray = [requestDic objectForKey:@"replays"];
            NSLog(@"%d",[reArray count]);
            return [reArray count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"HelpContent";
        ExpertContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpertContentCell" owner:self options:nil] lastObject];
        }
//        cell.helpTitle.text = [NSString stringWithFormat:@"[讨论中]%@",[self.ContentDic objectForKey:@"subject"]];
//        cell.helpContent.text =[NSString stringWithFormat:@"  %@",[self.ContentDic objectForKey:@"content"]];
//        [cell.huiFuBtn addTarget:self action:@selector(Huisfu) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    if (indexPath.section !=0 && indexPath.row == 0) {
        static NSString *CellIdentifiers = @"HelpContents";
        ExpertHuiFuCell *cells = [tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
        
        if (cells == nil) {
            cells = [[[NSBundle mainBundle] loadNibNamed:@"ExpertHuiFuCell" owner:self options:nil] lastObject];
        }
        if ([_dataSourceArray count] > 0) {
            NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section - 1];
            cells.level.text = [NSString stringWithFormat:@"%d楼",indexPath.section];

            NSDictionary * user = [dic objectForKey:@"user"];
            cells.userName.text = [user stringForKey:@"username"];
            cells.content.text = [dic stringForKey:@"commonts"];
            cells.keshilabel.text = [user stringForKey:@"deptname"];

            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic stringForKey:@"modifydt"] doubleValue] / 1000];
            //时间戳转时间的方法:
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            [formatter release];
            cells.time.text =confromTimespStr;
            cells.InFoDic = dic;
            cells.delegate = self;
       

        }
       
        return cells;

    }if (indexPath.section !=0 && indexPath.row !=0) {
        static NSString *CellIdentifierss = @"HelpContentss";
        ExpertHuiFuHuiFuCell *cellss = [tableView dequeueReusableCellWithIdentifier:CellIdentifierss];
        
        if (cellss == nil) {
            cellss = [[[NSBundle mainBundle] loadNibNamed:@"ExpertHuiFuForHuiFuCell" owner:self options:nil] lastObject];
        }
        if ([_dataSourceArray count] > 0) {
              NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section - 1];
            NSArray * reArray = [dic objectForKey:@"replays"];
            if ([reArray count] >0) {
                NSDictionary * reDic = [reArray objectAtIndex:indexPath.row - 1];
                NSDictionary *userDic = [reDic objectForKey:@"user"];
                cellss.userName.text =[NSString stringWithFormat:@"%@:",[userDic stringForKey:@"username"]] ;
                cellss.content.text = [reDic stringForKey:@"commonts"];
                
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[reDic objectForKey:@"modifydt"] doubleValue] / 1000];
                //时间戳转时间的方法:
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                [formatter release];
                cellss.time.text =confromTimespStr;
            }
        }
        return  cellss;
    }
    
    

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        NSString *cellText =[self.ContentDic objectForKey:@"content"];
//        UIFont *cellFont = [UIFont systemFontOfSize:14];;
//        CGSize constraintSize = CGSizeMake(304.0f, MAXFLOAT);
//        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
//        
//        CGSize titleContrainSize = CGSizeMake(310.0f, 90);
//        CGSize titleSize = [[self.ContentDic objectForKey:@"subject"] sizeWithFont:[UIFont boldSystemFontOfSize:23.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
//        if (labelSize.height + titleSize.height + 80 > 120) {
//            return labelSize.height + titleSize.height + 80;
//        } else {
//            return 120;
//        }
        return 218;
    }
    if (indexPath.section != 0) {
        if (indexPath.row == 0) {
            CGSize titleContrainSize = CGSizeMake(310.0f, MAXFLOAT);
            if ([_dataSourceArray count] > 0) {
                NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section - 1];
                CGSize titleSize = [[dic stringForKey:@"commonts"] sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
                if (140+titleSize.height > 140) {
                    return 140+titleSize.height;
                    
                } else
                    return  140;
                
            }

        }
        if (indexPath.row != 0) {
            CGSize titleContrainSize = CGSizeMake(241.0f, MAXFLOAT);
           NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section-1];
            NSArray * replay = [dic objectForKey:@"replays"];
            if ([replay count] >0) {
                NSDictionary *redic = [replay objectAtIndex:indexPath.row - 1];
                CGSize titleSize = [[redic stringForKey:@"commonts"] sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
                return  titleSize.height + 60;
            }
        }
    }
    return  140;
}
-(void)Huifu:(NSDictionary *)InfoDic {
 

}
-(void)Huisfu {
   }
@end
