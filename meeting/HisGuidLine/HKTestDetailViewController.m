  //
//  HKTestDetailViewController.m
//  HisGuidline
//
//  Created by kimi on 13-9-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKTestDetailViewController.h"
#import "HHDomainBase.h"
#import "MeetingConst.h"
#import "RTLabel.h"
#import "GRAlertView.h"	
#import "HKWebViewController.h"
#import <AVFoundation/AVFoundation.h> 

@interface HKTestDetailViewController (){
    int currentQuestions;
    //定义一个声音的播放器
    AVAudioPlayer *player;
    HKCategorySearchDomain * _domain;
    NSMutableSet *  set;
    NSMutableSet * set1;
    
}


@property (nonatomic,retain) NSArray* testData;
@property (nonatomic,assign) NSArray* questions;
@property (nonatomic,retain) NSMutableDictionary* userAnswers;

@end

@implementation HKTestDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithStyle:(UITableViewStyle)style TestData:(NSDictionary *)testDic{
    
    self = [self initWithStyle:style];
    if (self) {
        self.testDictionary = testDic;
        self.testData = [[[NSArray alloc] init] autorelease];
        _domain = [[HKCategorySearchDomain alloc] init];
        set = [[NSMutableSet alloc] init];
        set1 = [[NSMutableSet alloc] init];
        _dicforRow = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) dealloc{
    
    self.testData = nil;
    self.userAnswers = nil;
    [_domain release];
    [set release];
    [set1 release];
    [_testData release];
    [_testDictionary  release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.testData = [[self.testDictionary dictionaryForKey:Json_GuidData] dictionaryForKey:JsonHead_data];
//    
//    self.questions = [self.testData arrayForKey:Json_Test_Questions];
//    
//    self.userAnswers = [NSMutableDictionary dictionaryWithCapacity:self.questions.count];
//    
//    self.title = [self.testData stringForKey:Json_Test_Title];
    NSMutableDictionary * dicParams = [NSMutableDictionary dictionary];
    [dicParams setObject:[self.testDictionary stringForKey:@"pkey"] forKey:@"medkey"];
    [_domain setDelegate:self];
   
    [_domain getTestData:dicParams];
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed: 240.0/255 green: 240.0/255 blue: 240.0/255 alpha: 1.0];
    //self.tableView.separatorColor = [UIColor clearColor];
    
    currentQuestions = 0;
    
    NSString* path = [self.testDictionary stringForKey:Json_GuidFolder];
//    NSString* filePath = [path stringByAppendingString:@"/case.html"];
//    
   
    
    
    
    //UILabel* header = [[UILabel alloc] initWithFrame:<#(CGRect)#>]
    
    
   // self.tableView.tableHeaderView
    
    
    NSString *soundpath = [[NSBundle mainBundle] pathForResource:@"Brave" ofType:@"mp3"];
    //在这里判断以下是否能找到这个音乐文件
    if (path) {
        //从path路径中 加载播放器
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:soundpath]error:nil];
        //初始化播放器
        [player prepareToPlay];
        
        //设置播放循环次数，如果numberOfLoops为负数 音频文件就会一直循环播放下去
        //player.numberOfLoops = 1;
        
        //设置音频音量 volume的取值范围在 0.0为最小 0.1为最大 可以根据自己的情况而设置
        player.volume = 0.5f;
        
        NSLog(@"播放加载");
    }

    self.title = [self.testDictionary stringForKey:@"title"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//接收网络返回数据
-(void) didParsDatas:(HHDomainBase *)domainData {
    self.testData = [domainData dataDetails];
    if ([self.testData count] > 0) {
        NSDictionary * dicData = [self.testData  objectAtIndex:0];
        NSString* headContent = [[self.testData objectAtIndex:0] objectForKey:@"casecontent"];
        
        RTLabel *label = [[[RTLabel alloc] initWithFrame:CGRectMake(10,10,300,100)] autorelease];
        
        [label setText:headContent];
        CGSize optimumSize = [label optimumSize];
        
        [label setFrame:CGRectMake(10,10,optimumSize.width,optimumSize.height)];
        [label setTextAlignment:RTTextAlignmentLeft];
        
        
        self.tableView.tableHeaderView =label;
        
        self.questions = [dicData arrayForKey:@"questions"];
        
        self.userAnswers = [NSMutableDictionary dictionaryWithCapacity:self.questions.count];
        
        [self.tableView reloadData];

    }
}


-(void) putUserAnswer:(int)index Answer:(NSString*) answer{
    //用户所选答案的Key
    NSString* userAnswerKey = [NSString stringWithFormat:@"userAnswer_%d",index];
    
    [self.userAnswers setValue:answer forKey:userAnswerKey];
    
}

-(NSString*) getUserAnswer:(int) index{
    //用户所选答案的Key
    NSString* userAnswerKey = [NSString stringWithFormat:@"userAnswer_%d",index];
    
    //用户选择的答案，如果为nil者用户没有选择
    
    return [self.userAnswers objectForKey:userAnswerKey];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //return currentQuestions+1;
    return MIN(currentQuestions+1, self.questions.count) ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* question = [self.questions objectAtIndex:section];
    
    NSArray* anwers = [question arrayForKey:@"answers"];
    
    NSString* userAnswer = [_dicforRow objectForKey:[NSString stringWithFormat:@"index%ld",(long)section]];
    
    if (userAnswer) {
        return anwers.count+1;
    }else{
        return anwers.count;
    }
  
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *AnswerCellIdentifier = @"AnswerCell";
    
    
    NSDictionary* question = [self.questions objectAtIndex:indexPath.section];
    
    NSArray* anwers = [question arrayForKey:@"answers"];
    

    
    
    UITableViewCell *cell = nil;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:AnswerCellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AnswerCellIdentifier] autorelease];
    }
    
    if (indexPath.row < [anwers count]) { //答案单元格
        NSString* userAnswer = [[anwers objectAtIndex:indexPath.row] stringForKey:@"anumber"];
        
        NSDictionary* answer = [anwers objectAtIndex:indexPath.row];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.text =  [NSString stringWithFormat:@"  %@",[answer stringForKey:@"atitle"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (userAnswer!=nil && [self getUserAnswer:[[answer stringForKey:@"pkey"] intValue]]) {
            cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_checkbox.png"]] autorelease];
        }else{
            cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked_checkbox.png"]] autorelease];
        }
        
        cell.textLabel.numberOfLines = 0;
        
        
    }else{
        
        cell.textLabel.text = @"指南参看";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
        
    }
    
    
    return cell;
    
    
}




-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    NSDictionary* question = [self.questions objectAtIndex:section];
    if ([[NSString stringWithFormat:@"%@",[question objectForKey:@"qtype"]] isEqualToString:@"1"]) {
        return [question stringForKey:@"qtitle"];
    }else {
        return [NSString stringWithFormat:@"%@(多选)",[question stringForKey:@"qtitle"]];
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    NSDictionary* question = [self.questions objectAtIndex:indexPath.section];
    
    NSArray* anwers = [question arrayForKey:@"answers"];
    //NSString * qtype =[NSString stringWithFormat:@"%@",[question objectForKey:@"qtype"]];
    
    if (indexPath.row < anwers.count) {  //选择答案
        
        if (currentQuestions!=indexPath.section) {
            return;
        }
        
        NSDictionary* answer = [anwers objectAtIndex:indexPath.row];
        
        NSString* answerId = [answer stringForKey:@"anumber"];
        [set1 addObject:answerId];
        //check the answer is correct or not
        NSString* correctId = [question stringForKey:@"correctanswer"];
        NSArray * answsersList =  [correctId componentsSeparatedByString:@","];//答案数组
        for (NSString * answersss in answsersList) {
            [set addObject:answersss];
            if ([answerId isEqualToString:answersss]) {
                [self putUserAnswer:[[answer stringForKey:@"pkey"] intValue] Answer:answerId];
            }
        }
        
        GRAlertView *alert;
        if ([set isEqualToSet:set1] && [set count] == [set1 count]) {
           
            currentQuestions++;
            
            if (currentQuestions<self.questions.count) {
                
                alert = [[GRAlertView alloc] initWithTitle:@""
                                                   message:@"恭喜你答对了！请继续答题。"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil] ;
                alert.style = GRAlertStyleSuccess;
                [alert setImage:@"accept.png"];
                alert.animation = GRAlertAnimationLines;
                [alert show];
                [set removeAllObjects];
                [set1 removeAllObjects];
                }else{
                alert = [[GRAlertView alloc] initWithTitle:@""
                                                   message:@"恭喜您,闯关成功！"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil] ;
                alert.style = GRAlertStyleSuccess;
                [alert setImage:@"succ.png"];
                alert.animation = GRAlertAnimationLines;
                [alert show];

                
                //播放声音
                [player play]; 
                            }
            
            [_dicforRow setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section] forKey:[NSString stringWithFormat:@"index%ld",(long)indexPath.section]];
            
        }
        if(![set isEqualToSet:set1] && [set count] == [set1 count]) {
            alert = [[GRAlertView alloc] initWithTitle:@""
                                               message:@"你答错了，继续努力!"
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK", nil] ;
            alert.style = GRAlertStyleAlert;
            [alert setImage:@"alert.png"];
            alert.animation = GRAlertAnimationLines;
            [alert show];
            [set1 removeAllObjects];
        }
        [self.tableView reloadData];
        
    }else{  //查看参考指南
        
        NSString* path = [self.testDictionary stringForKey:Json_GuidFolder];
        
        NSString* file = [question stringForKey:@"refGuidUrl"];
        
        
        NSString* fullPaht = [path stringByAppendingFormat:@"/%@",file];
        
        NSLog(@"fullPaht:%@",fullPaht);
        
        //NSURL* url = [NSURL URLWithString:@""];
        
        HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                    bundle:nil
                                                                                     Title:@"参考资料"
                                                                                       URL:[NSURL fileURLWithPath:fullPaht]] autorelease];
        
        [self.navigationController pushViewController:webController animated:YES];
        
    }
    }


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}


@end
