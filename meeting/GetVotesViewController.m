//
//  GetVoteViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-12.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "GetVotesViewController.h"
#import "VoteDescriptionCell.h"
#import "SelectedCell.h"
#import "PostBtnCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PostVoteVIewController.h"
#import "HKWebViewController.h"
#import "MeetingConst.h"
@interface GetVotesViewController ()

@end

@implementation GetVotesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

        _questionArray = [[NSArray alloc] init];
        _questionDic = [[NSMutableDictionary alloc] init];
        _domain  = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _domains  = [[HKCommunicateDomain alloc] init];
        [_domains setDelegate:self];
        self.title = @"投票";

    }
    return self;
}
- (void)dealloc
{
    [_questionArray release];
    [_questionDic release];
    [_domain release];
    [_domains release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _questionArray = [self.dataSorce objectForKey:@"questions"];
    for (NSDictionary * qes in _questionArray) {
        NSString * qid = [qes objectForKey:@"qid"];
        [_questionDic setObject:@"0" forKey:qid];
    }
//    sectionkey=2  科室ID
//    pageNumber=1
//    pageSize=10
//    
//    userId =abc  登陆用户ID
//    pkey= VOT201312000048  投票key（如果传入这个参数将返
    profile = [MyProfile myProfile];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[self.dataSorce stringForKey:@"pkey"]  forKey:@"pkey"];
    [params setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userId"];
    [_domains getDomainForVotes:params];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
       return [_questionArray count];
    }
    if (section == 2) {
       return 1;
    }
    if (section == 3) {
        return 1;
    }

 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   
    //投票题目
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifierTitle = @"CellTitle";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierTitle];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierTitle]autorelease];

                          }
            cell.textLabel.text = [self.dataSorce objectForKey:@"votetitle"];
            //[cell.textView setFrame:CGRectMake(0, 0, 320, 30)];
//            cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
//            cell.contentView.layer.borderWidth =1.0;
//            cell.contentView.layer.cornerRadius =5.0;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
        //投票内容
        if (indexPath.row == 1) {
            static NSString *CellDescription = @"CellDescription";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellDescription];

            if (!cell) {
                 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellDescription]autorelease];
            }
            cell.textLabel.text = [self.dataSorce objectForKey:@"votecontent"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.textLabel.layer.borderWidth =1.0;
            cell.textLabel.layer.cornerRadius =5.0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        }
    }
 
    //投票按钮和分享和发布投票
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            static NSString * cell1 = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell1] autorelease];
            }
            cell.textLabel.text = @"投票";
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell.textLabel setBackgroundColor:getUIColor(Color_NavBarBackColor)];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView setBackgroundColor:[UIColor lightTextColor]];
            return  cell;
        }
//        if (indexPath.row == 1) {
//            static NSString * cell2 = @"cell2";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell2];
//            if (!cell) {
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell2]autorelease];
//            }
//            cell.textLabel.text = @"发起投票";
//            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//            [cell.contentView setBackgroundColor:[UIColor lightTextColor]];
//
//            return  cell;
//            
//            
//        }
           }
    if (indexPath.section == 3) {
        static NSString * cell3 = @"cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell3];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell3]autorelease];
        }
        cell.textLabel.text = @"查看投票结果";
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setBackgroundColor:getUIColor(Color_NavBarBackColor)];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView setBackgroundColor:[UIColor lightTextColor]];
        return  cell;
        
        
    }


    if (indexPath.section == 1) {
        
            static NSString *CellQuestion = @"CellQuestion";
            SelectedCell * cell = [tableView dequeueReusableCellWithIdentifier:CellQuestion];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SelectedCell" owner:self options:nil];
                
                cell = [array objectAtIndex:0];
            }
            NSDictionary * qdic =   [_questionArray objectAtIndex:indexPath.row];
            cell.qid.text =[NSString stringWithFormat:@"%@:",[qdic objectForKey:@"qid"]];
            cell.qtitle.text = [qdic objectForKey:@"qtitle"];
        cell.qselected.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.qselected.layer.borderWidth = 0.6;
        cell.qselected.layer.cornerRadius = 4;
        
        if ([[_questionDic objectForKey:[qdic objectForKey:@"qid"]] isEqualToString:@"1"]) {
//            cell.qselected.text = @"✔";
            [cell.image setImage:[UIImage imageNamed:@"checked_checkbox.png"]];
        }else {
//            cell.qselected.text = @"";
            [cell.image setImage:[UIImage imageNamed:@"unchecked_checkbox.png"]];
        }
            return cell;
    }
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString * typeString ;
//    NSString * voteSumCount;
//    int  count = 0;
//    if (section == 1) {
//        if ([[self.dataSorce stringForKey:@"votetype"] isEqualToString:@"1"]) {
//            typeString = @"单选投票";
//        }
//        if ([[self.dataSorce stringForKey:@"votetype"] isEqualToString:@"2"]) {
//            typeString = @"多选投票";
//        }
//        //_questionArray = [self.dataSorce objectForKey:@"questions"];
//        for (NSDictionary * qes in _questionArray) {
//             count += [[qes stringForKey:@"ancout"] intValue];
//            
//        }
//        voteSumCount = [NSString stringWithFormat:@"%d",count];
//       return [NSString stringWithFormat:@"%@:已收到%@票,投票后可见结果",typeString,voteSumCount];
//       
//       
//    }
//    return @"";
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString * typeString ;
    NSString * voteSumCount;
    int  count = 0;
    if (section == 1) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 25)];
        
        
        
        if ([[self.dataSorce stringForKey:@"votetype"] isEqualToString:@"1"]) {
            typeString = @"单选投票";
        }
        if ([[self.dataSorce stringForKey:@"votetype"] isEqualToString:@"2"]) {
            typeString = @"多选投票";
        }
        //_questionArray = [self.dataSorce objectForKey:@"questions"];
        for (NSDictionary * qes in _questionArray) {
            count += [[qes stringForKey:@"ancout"] intValue];
            
        }
        voteSumCount = [NSString stringWithFormat:@"%d",count];
        label.text  = [NSString stringWithFormat:@"%@:已收到%@票,投票后可见结果",typeString,voteSumCount];
        label.textColor = getUIColor(Color_NavBarBackColor);//[UIColor blueColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        return [label autorelease];

    }
  
    return nil;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 25;
    }if (section == 3) {
        return 10;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *cellText = [self.dataSorce objectForKey:@"votetitle"];
            UIFont *cellFont = [UIFont systemFontOfSize:17];
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            if (labelSize.height + 20 > 40) {
                return labelSize.height + 20;
            } else {
                return 40;
            }
        }
        if (indexPath.row == 1) {
            NSString *cellText = [self.dataSorce objectForKey:@"votecontent"];
            UIFont *cellFont = [UIFont systemFontOfSize:14];
            CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
            if (labelSize.height + 20 > 40) {
                return labelSize.height + 20;
            } else {
                return 40;
            }

        }

    }
    if (indexPath.section == 1) {
        NSDictionary * qdic =   [_questionArray objectAtIndex:indexPath.row];
       [qdic stringForKey:@"qtitle"];
        
        
        NSString *cellText = [qdic stringForKey:@"qtitle"];

        UIFont *cellFont = [UIFont systemFontOfSize:14];
        CGSize constraintSize = CGSizeMake(205.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 56) {
            return 56;
        }else {
            return labelSize.height;
            }
    }
    if (indexPath.section == 2) {
        return  40;
    }
    if (indexPath.section == 3) {
        return  40;
    }

}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //多选
        if ([[self.dataSorce objectForKey:@"votetype"] intValue] == 2) {
            NSDictionary * dic = [_questionArray objectAtIndex:indexPath.row];
            NSString * qid = [dic objectForKey:@"qid"];
            if ([[_questionDic objectForKey:qid] isEqualToString:@"0"]) {
                [_questionDic setObject:@"1" forKey:qid];
            }
            else if ([[_questionDic objectForKey:qid] isEqualToString:@"1"]) {
                [_questionDic setObject:@"0" forKey:qid];
            }
            [self.tableView reloadData];
        }
        
     //单选
        if ([[self.dataSorce objectForKey:@"votetype"] intValue] == 1) {
            NSDictionary * dic = [_questionArray objectAtIndex:indexPath.row];
            NSString * qid = [dic objectForKey:@"qid"];
            [self cancelAllSelected:qid];
            [self.tableView reloadData];
            
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self PostAnswers];
        }
//        if (indexPath.row == 1) {
//            [self GoPostVotes];
//        }
           }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
             [self searchResult];
        }
       
    }

}
-(void) showHTMLWebView:(NSString*) filePaht Title:(NSString*) title{
    
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil Title:title URL:[NSURL URLWithString:filePaht]
                                           ] autorelease];
    webController.editFlag = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
    
}

-(void) searchResult {
    if ([[self.dataSorce stringForKey:@"voteCount"]  intValue] != 0) {
//        URL：
//        mguid/mvote/phone/vote/{pkey}.html
//        参数：
//        pkey = VOT201312000048  投票pkey
        NSString * url = [NSString stringWithFormat:@"http://121.199.26.12:8080/mguid/mvote/phone/vote/%@.html",[self.dataSorce stringForKey:@"pkey"]];
        
        [self showHTMLWebView:url Title:[self.dataSorce stringForKey:@"votetitle"]];
        
        
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"还未投票不能查看投票结果" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        return;

    }

}

-(void) GoPostVotes {
    PostVoteVIewController * post = [[[PostVoteVIewController alloc] init]autorelease];
    post.dataSorce = self.keshi;
    [self.navigationController pushViewController:post animated:YES];
    
}

//清空所选项
-(void) cancelAllSelected:(NSString *)qid {
    for (NSDictionary * qes in _questionArray) {
        NSString * qids = [qes objectForKey:@"qid"];
        if (![qids isEqualToString:qid]) {
            [_questionDic setObject:@"0" forKey:qids];
        }
        else {
            [_questionDic setObject:@"1" forKey:qids];
        }
    }
}
-(void) PostAnswers {

    //votekey=1 投票ID
    //qids=1,2 答案ID英文逗号分割
    //userid=1456 用户ID
    if ([[self.dataSorce stringForKey:@"voteCount"]  intValue] != 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"不能重复投票" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        return;
    }
    
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
    NSMutableArray * answerArray = [[NSMutableArray alloc] init];
    [paramDic setObject:[self.dataSorce stringForKey:@"pkey"] forKey:@"votekey"];
    for (NSDictionary * qes in _questionArray) {
        NSString * qid = [qes objectForKey:@"qid"];
        if ([[_questionDic objectForKey:qid] isEqualToString:@"1"]) {
            [answerArray addObject:qid];
        }
    }
    if ([answerArray count] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"选项不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];

        return;
        
    }
    NSString * paramsAnswer = @"";
    for (NSString * str in answerArray) {
        paramsAnswer = [paramsAnswer stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
    }
    NSMutableString *answerParams = [[NSMutableString  alloc] initWithString:paramsAnswer];
    [answerParams deleteCharactersInRange:NSMakeRange(0,1)];
    NSLog(@"%@",answerParams);
    //用户id
    
    
    [paramDic setObject:answerParams forKey:@"qids"];
    [paramDic setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userid"];
    
    
    
    [_domain getDomainForPostAnswer:paramDic];
    [answerParams release];
    [paramDic release];
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        if (domainData.status == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"投票成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setObject:[self.dataSorce stringForKey:@"pkey"]  forKey:@"pkey"];
            [params setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userId"];
            [_domains getDomainForVotes:params];
            
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"投票失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
        }
    }

    if (domainData == _domains) {
     
         self.dataSorce = [[domainData dataDetails] objectAtIndex:0];
        _questionArray = [ self.dataSorce objectForKey:@"questions"];
        [self.tableView reloadData];
        
    }
}
@end
