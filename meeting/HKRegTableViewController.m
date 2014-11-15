//
//  HKRegTableViewController.m
//  HisGuidline
//
//  Created by kimi on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKRegTableViewController.h"
#import "UserInfoCell1.h"
#import "HKRegButtonCell.h"
#import "UIImageView+WebCache.h"

@interface HKRegTableViewController ()


@property (nonatomic,retain) NSString* validCode;
@property (nonatomic,retain) NSMutableArray* cellArray;

@end

@implementation HKRegTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _domain = [[HKLoginDomain alloc] init];
        [_domain setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSMutableString* tempStr = [[[NSMutableString alloc] init] autorelease];
    for (int i=0; i<4; i++) {
        [tempStr appendFormat:@"%d",arc4random() % 10];
    }
    
    self.validCode = tempStr;

    
    [super viewDidLoad];
    
    self.title = @"用户注册";
    
    self.cellArray = [NSMutableArray arrayWithCapacity:5];
    
    for (int i=0; i<7; i++) {
        [self.cellArray addObject:[self getCell:i]];
    }
    
    
    self.tableView.separatorStyle = NO;
    UIImageView * imgback = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.png"]];
    [self.tableView setBackgroundView:imgback];
 
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.opaque = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 6) {
        return 100;
    }else{
        return 54;
    }
}


-(UITableViewCell*) getCell:(int) row{
    
    
    
    if (row == 6) {
        HKRegButtonCell* btnCell = [[[NSBundle mainBundle] loadNibNamed:@"HKRegButtonCell" owner:self options:nil] lastObject];
        [btnCell.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnCell.btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnCell.btnSubmit addTarget:self action:@selector(btnSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
         [btnCell.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return btnCell;

    }
    
    
    UserInfoCell1 *cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell1" owner:self options:nil] lastObject];
    cell.name.textColor = [UIColor whiteColor];
    cell.name.font = [UIFont systemFontOfSize:14];
    cell.name.textAlignment = NSTextAlignmentLeft;
    cell.properties.font =[UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.notLayoutSubView = YES;
    [cell.spliView setHidden:NO];
    
    if (row == 0) { //用户名
        
        cell.name.text = @"登陆名";
        cell.properties.placeholder = @"请输入登陆名";
        
        
    }else if(row == 1){
        
        cell.name.text = @"真实姓名";
        cell.properties.placeholder = @"请输入真实姓名";
        
    }else if(row == 2){ //密码
        
        cell.name.text = @"密码设置";
        cell.properties.placeholder = @"6-12个字符，英文字母或数字";
        [cell.properties setSecureTextEntry:YES];
        
    }else if(row == 3){ //重复密码
        
        cell.name.text = @"确认密码";
        cell.properties.placeholder = @"请再次输入您的密码";
        [cell.properties setSecureTextEntry:YES];
        
    }else if(row ==4){ //验证码
        cell.name.text = @"验证码";
        cell.properties.placeholder = @"请输入验证码";
        [cell.rightImage setHidden:NO];
        
        //UIImageView* imgView = [[[UIImageView alloc] init] autorelease];
        
        NSString* strUrl = [NSString stringWithFormat:@"http://121.199.26.12:8080/mguid/validate_%@.do",self.validCode];
        
        [cell.rightImage setImageWithURL:[NSURL URLWithString:strUrl]];
        
        //cell.accessoryView = imgView;
    }
    else if (row == 5 ) {
        cell.name.text = @"手机号码";
        cell.properties.placeholder = @"手机号码";

    }
    return cell;
    
}

-(NSMutableDictionary*) getParmas{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:5];
    
    
    //用户名
    UserInfoCell1* userIdCell = [self.cellArray objectAtIndex:0];
    NSString* userId = userIdCell.properties.text;
    if (userId==nil || userId.length<1) {
        [self showAlertMessage:@"请填写登陆名"];
        return nil;
    }
    
    [params setObject:userId forKey:@"pkey"];
    
    
    //用户名
    UserInfoCell1* userNameCell = [self.cellArray objectAtIndex:1];
    NSString* username = userNameCell.properties.text;
    if (username==nil || username.length<1) {
        [self showAlertMessage:@"请填写真实姓名"];
        return nil;
    }
    
    [params setObject:username forKey:@"username"];
    
    
    //重复密码
    UserInfoCell1* passCell = [self.cellArray objectAtIndex:2];
    NSString* pass = passCell.properties.text;
    if (pass==nil || pass.length<1) {
        [self showAlertMessage:@"请输入密码"];
        return nil;
    }
    
    UserInfoCell1* passCell2 = [self.cellArray objectAtIndex:3];
    NSString* pass2 = passCell2.properties.text;
    if (pass2==nil || ![pass isEqualToString:pass2] ) {
        [self showAlertMessage:@"两次密码不同，请重新输入"];
        
        passCell.properties.text = @"";
        passCell2.properties.text = @"";
        
        return nil;
    }
    
    [params setObject:pass forKey:@"password"];
    
    UserInfoCell1* valCell = [self.cellArray objectAtIndex:4];
    NSString* val = valCell.properties.text;
    if (val == nil || ![self.validCode isEqualToString:val]) {
        [self showAlertMessage:@"校验码不正确，请重新输入校验码！"];
        valCell.properties.text = @"";
        
        return nil;
    }
    UserInfoCell1* telCell = [self.cellArray objectAtIndex:5];
    NSString* tel = telCell.properties.text;
    if (tel == nil || tel.length < 1) {
        [self showAlertMessage:@"电话号码不能为空！"];
        telCell.properties.text = @"";
        
        return nil;
    }
    [params setObject:tel forKey:@"phone"];
    return params;
    
}


-(void) showAlertMessage:(NSString*) message{
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil] autorelease];
    
    [alert show];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellArray objectAtIndex:indexPath.row];
}


-(void) btnSubmitClick:(id) sender{
    NSDictionary* para = [self getParmas];
    
    if (para!=nil) {
        [_domain registerUser:para];
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = @"loading";

    }
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        

        UIAlertView * aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        [aler release];
    }else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        NSString * msg = [domainData.responseDictionary stringForKey:@"resultMsg"];
        UIAlertView * aler = [[UIAlertView alloc] initWithTitle:@"警告" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        [aler release];

    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [[NSUserDefaults standardUserDefaults] setObject:[[self getParmas] stringForKey:@"pkey"] forKey:@"username"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[self getParmas] stringForKey:@"password"] forKey:@"password"];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];

}
-(void) btnCancelClick:(id) sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}


-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //return UIInterfaceOrientationMaskLandscape
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
}
@end
