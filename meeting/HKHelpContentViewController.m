//
//  HKHelpContentViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHelpContentViewController.h"
#import "UIImageView+WebCache.h"
#import "PostHelperViewController.h"
@interface HKHelpContentViewController ()

@end

@implementation HKHelpContentViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _paramDic = [[NSMutableDictionary alloc] init];
        _NumberOfPage = 1;
        _dataSourceArray = [[NSMutableArray alloc] init];
        self.title = @"求助";
    }
    return self;
}
- (void)dealloc
{
    [_domain release];
    [_paramDic release];
    [_dataSourceArray release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }

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
//    参数：
//    helpkey=1  互助key
//    pageNumber=1
//    pageSize=10
    [_paramDic setObject:[self.ContentDic objectForKey:@"pkey"] forKey:@"helpkey"];
    [_paramDic setObject:@"10" forKey:@"pageSize"];
    [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
    [_domain getHelperContent:_paramDic];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [_dataSourceArray removeAllObjects];
    _NumberOfPage = 1;

    [_paramDic setObject:[self.ContentDic objectForKey:@"pkey"] forKey:@"helpkey"];
    [_paramDic setObject:@"10" forKey:@"pageSize"];
    [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
    [_domain getHelperContent:_paramDic];

}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [_dataSourceArray removeAllObjects];
        _NumberOfPage = 1;
        [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
        [_domain getHelperContent:_paramDic];

    }
}
-(void)loadMore {
    _NumberOfPage ++;
     [_paramDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
     [_domain getHelperContent:_paramDic];
}
//获取网络数据
-(void)didParsDatas:(HHDomainBase *)domainData {
    NSArray * array = [domainData dataDetails];
    for (NSDictionary * dic in array) {
        [_dataSourceArray addObject:dic];
    }
    [self.tableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];

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
        HelpContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HelpContentCell" owner:self options:nil] lastObject];
        }
        cell.helpTitle.text = [NSString stringWithFormat:@"[讨论中]%@",[self.ContentDic objectForKey:@"subject"]];
        cell.helpContent.text =[NSString stringWithFormat:@"  %@",[self.ContentDic objectForKey:@"content"]];
        [cell.huiFuBtn addTarget:self action:@selector(Huisfu) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    if (indexPath.section !=0 && indexPath.row == 0) {
        static NSString *CellIdentifiers = @"HelpContents";
        DrHuiFuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DrHuiFuCell" owner:self options:nil] lastObject];
        }
        if ([_dataSourceArray count] > 0) {
            NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section - 1];
            NSDictionary * userDic = [dic dictionaryForKey:@"user"];
            cell.level.text = [NSString stringWithFormat:@"%d楼",indexPath.section];
            cell.userName.text = [userDic objectForKey:@"username"];
            [cell.TouxiangImage setImageWithURL:[NSURL URLWithString:[userDic stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"user.png"]];
            cell.content.text = [dic objectForKey:@"content"];
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic stringForKey:@"modifydt"] doubleValue] / 1000];
            //时间戳转时间的方法:
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            [formatter release];
            cell.time.text =confromTimespStr;
            cell.InFoDic = dic;
            cell.delegate = self;
       

        }
       
        return cell;

    }if (indexPath.section !=0 && indexPath.row !=0) {
        static NSString *CellIdentifierss = @"HelpContentss";
        HuiFuHuiFuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierss];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HuiFuForHuiFuCell" owner:self options:nil] lastObject];
        }
        if ([_dataSourceArray count] > 0) {
              NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section - 1];
          
            NSArray * reArray = [dic objectForKey:@"replays"];
            if ([reArray count] >0) {
                NSDictionary * reDic = [reArray objectAtIndex:indexPath.row - 1];
                NSDictionary *userDic = [reDic objectForKey:@"user"];
                cell.userName.text =[NSString stringWithFormat:@"%@:",[userDic stringForKey:@"username"]] ;
                cell.content.text = [reDic stringForKey:@"content"];
                
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[reDic objectForKey:@"modifydt"] doubleValue] / 1000];
                //时间戳转时间的方法:
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
                [formatter release];
                cell.time.text =confromTimespStr;
            }
        }
        return  cell;
    }
    
    

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *cellText =[self.ContentDic objectForKey:@"content"];
        UIFont *cellFont = [UIFont systemFontOfSize:14];;
        CGSize constraintSize = CGSizeMake(304.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize titleContrainSize = CGSizeMake(310.0f, 90);
        CGSize titleSize = [[self.ContentDic objectForKey:@"subject"] sizeWithFont:[UIFont boldSystemFontOfSize:23.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
        if (labelSize.height + titleSize.height + 80 > 120) {
            return labelSize.height + titleSize.height + 80;
        } else {
            return 120;
        }
    }
    if (indexPath.section != 0) {
        if (indexPath.row == 0) {
            CGSize titleContrainSize = CGSizeMake(310.0f, MAXFLOAT);
            if ([_dataSourceArray count] > 0) {
                NSDictionary * dic = [_dataSourceArray objectAtIndex:indexPath.section - 1];
                CGSize titleSize = [[dic stringForKey:@"content"] sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
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
                CGSize titleSize = [[redic stringForKey:@"content"] sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
                return  titleSize.height + 60;
            }
        }
    }
    return  140;
}
-(void)Huifu:(NSDictionary *)InfoDic {
    PostHelperViewController *post = [[[PostHelperViewController alloc] init] autorelease];
    post.InfoDic = InfoDic;
    post.flag = YES;
    [self.navigationController pushViewController:post animated:YES];

}
-(void)Huisfu {
    PostHelperViewController *post = [[[PostHelperViewController alloc] init] autorelease];
    post.InfoDic = self.ContentDic;
    post.flag = NO;
    [self.navigationController pushViewController:post animated:YES];

}
@end
