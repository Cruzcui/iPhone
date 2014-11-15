//
//  UserInfoController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-7.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "UserInfoController.h"
#import "MyProfile.h"
#import "UserInfoHeader.h"
#import "UserInfoCell1.h"
#import "HHDomainBase.h"
#import "FooterView.h"
#import "HKHomeNavigationController.h"
@interface UserInfoController ()

@property (nonatomic,retain) NSMutableArray* cellArray;

@end

@implementation UserInfoController
- (void)dealloc
{
    
    [super dealloc];
 }

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        MyProfile * profile = [MyProfile myProfile];
        self.userdic = profile.userInfo;
        self.title = @"个人信息";
        NumberOfRow = 0;
        
        self.cellArray = [NSMutableArray arrayWithCapacity:9];
        
        _domain  = [[HKUserDomain alloc] init];
        [_domain setDelegate:self];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    //设置headerview
    // UserInfoHeader * headerView = [[UserInfoHeader alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserInfoHeader" owner:self options:nil];
    UserInfoHeader * headerView  = [array lastObject];
    headerView.status.text  =  [self.userdic stringForKey:@"pkey"];
    self.tableView.tableHeaderView = headerView;
    [headerView.btn addTarget:self action:@selector(UpdateInfo) forControlEvents:UIControlEventTouchUpInside];
    //设置footerView
    NSArray *arrays = [[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:self options:nil];
    FooterView * footer  = [arrays lastObject];
    self.tableView.tableFooterView = footer;
    [footer.btn addTarget:self action:@selector(ZhuXiao) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.cellArray addObject:[self getCell:0]];
    [self.cellArray addObject:[self getCell:1]];
    [self.cellArray addObject:[self getCell:2]];
    [self.cellArray addObject:[self getCell:3]];
    [self.cellArray addObject:[self getCell:4]];
    [self.cellArray addObject:[self getCell:5]];
    [self.cellArray addObject:[self getCell:6]];
    [self.cellArray addObject:[self getCell:7]];
    [self.cellArray addObject:[self getCell:8]];
    //[headerView release];
    
    //键盘处理
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    
    [topView setItems:buttonsArray];

    UserInfoCell1 * cell0 = [self.cellArray objectAtIndex:0];
    UserInfoCell1 * cell1 = [self.cellArray objectAtIndex:1];
    UserInfoCell1 * cell2 = [self.cellArray objectAtIndex:2];
    UserInfoCell1 * cell3 = [self.cellArray objectAtIndex:3];
    UserInfoCell1 * cell4 = [self.cellArray objectAtIndex:4];
    UserInfoCell1 * cell5 = [self.cellArray objectAtIndex:5];
    UserInfoCell1 * cell6 = [self.cellArray objectAtIndex:6];
    UserInfoCell1 * cell7 = [self.cellArray objectAtIndex:7];
    UserInfoCell1 * cell8 = [self.cellArray objectAtIndex:8];
    [cell0.properties setInputAccessoryView:topView];
    [cell1.properties setInputAccessoryView:topView];
    [cell2.properties setInputAccessoryView:topView];
    [cell3.properties setInputAccessoryView:topView];
    [cell4.properties setInputAccessoryView:topView];
    [cell5.properties setInputAccessoryView:topView];
    [cell6.properties setInputAccessoryView:topView];
    [cell7.properties setInputAccessoryView:topView];
    [cell8.properties setInputAccessoryView:topView];

    [topView release];
    
    topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    Rootrect = topController.view.frame;
}
-(void)dismissKeyBoard
{
    //[self.textContent resignFirstResponder];
    UserInfoCell1 * cell0 = [self.cellArray objectAtIndex:0];
    UserInfoCell1 * cell1 = [self.cellArray objectAtIndex:1];
    UserInfoCell1 * cell2 = [self.cellArray objectAtIndex:2];
    UserInfoCell1 * cell3 = [self.cellArray objectAtIndex:3];
    UserInfoCell1 * cell4 = [self.cellArray objectAtIndex:4];
    UserInfoCell1 * cell5 = [self.cellArray objectAtIndex:5];
    UserInfoCell1 * cell6 = [self.cellArray objectAtIndex:6];
    UserInfoCell1 * cell7 = [self.cellArray objectAtIndex:7];
    UserInfoCell1 * cell8 = [self.cellArray objectAtIndex:8];
    [cell8.properties resignFirstResponder];
    [cell7.properties resignFirstResponder];
    [cell6.properties resignFirstResponder];
    [cell5.properties resignFirstResponder];
    [cell4.properties resignFirstResponder];
    [cell3.properties resignFirstResponder];
    [cell2.properties resignFirstResponder];
    [cell1.properties resignFirstResponder];
    [cell0.properties resignFirstResponder];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            return;
        }else {
            [self goUpdate];
        }
    }
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            return;
        }else {
            [self goZhuXiao];
        }
    }
}
-(void)goZhuXiao {
    MyProfile * pro = [MyProfile myProfile];
    pro.userInfo = nil;
    [[NSUserDefaults  standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults  standardUserDefaults] removeObjectForKey:@"password"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHUXIAO" object:nil];
}

-(void) goUpdate {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    UserInfoCell1 * cell0 = [self.cellArray objectAtIndex:0];
    UserInfoCell1 * cell1 = [self.cellArray objectAtIndex:1];
    UserInfoCell1 * cell2 = [self.cellArray objectAtIndex:2];
    UserInfoCell1 * cell3 = [self.cellArray objectAtIndex:3];
    UserInfoCell1 * cell4 = [self.cellArray objectAtIndex:4];
    UserInfoCell1 * cell5 = [self.cellArray objectAtIndex:5];
    UserInfoCell1 * cell6 = [self.cellArray objectAtIndex:6];
    UserInfoCell1 * cell7 = [self.cellArray objectAtIndex:7];
    UserInfoCell1 * cell8 = [self.cellArray objectAtIndex:8];
    [params setObject:cell0.properties.text forKey:@"phone"];
    [params setObject:cell1.properties.text forKey:@"email"];
    [params setObject:cell2.properties.text forKey:@"username"];
    [params setObject:cell3.properties.text forKey:@"company"];
    [params setObject:cell4.properties.text forKey:@"deptname"];
    [params setObject:cell5.properties.text forKey:@"title"];
    [params setObject:cell6.properties.text forKey:@"school"];
    [params setObject:cell7.properties.text forKey:@"skill"];
    [params setObject:cell8.properties.text forKey:@"certificate"];
    [params setObject:[self.userdic stringForKey:@"pkey"] forKey:@"pkey"];

//    pkey=kilxy
//    username=kilxy_update
    [_domain UpDateuserInfos:params];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        if (domainData.status == 0) {
            [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
            _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_alert show];
            [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
            //[alert release];
            MyProfile * pro = [MyProfile myProfile];
            pro.userInfo = [domainData dataDictionary];
        }
        else {
            [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
            _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_alert show];
            [self performSelector:@selector(hideAlert) withObject:nil
                       afterDelay:1.0];
            //[alert release];

        }
    }
}
-(void) hideAlert {

   [_alert dismissWithClickedButtonIndex:0 animated:NO];
    [_alert release];
    
}

-(void) UpdateInfo {
//    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定修改内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
//    [alert setTag:2];
//    [alert show];
     [self goUpdate];
}
-(void)ZhuXiao {
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定注销当前用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
    [alert setTag:3];
    [alert show];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  9 + NumberOfRow;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   return  [self.cellArray objectAtIndex:indexPath.row];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        KeshiListController *keshi = [[[KeshiListController alloc] init] autorelease];
        [keshi setDelegate:self];
        HKHomeNavigationController * nav = [[[HKHomeNavigationController alloc] initWithRootViewController:keshi] autorelease];
        nav.isPresentModel = YES;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41;
}
- (void)hkDLCategorytableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(NSDictionary * )dataSourceDic {
    UserInfoCell1 * cell = [self.cellArray objectAtIndex:4];
    cell.properties.text = [dataSourceDic objectForKey:@"sname"];
    [self.tableView reloadData];
}


-(UITableViewCell*) getCell:(int) row{
    
    if (row == 0 || row == 1 || row == 2 ||row == 3 ||row == 4) {
        //static NSString *CellIdentifier = @"Cell";
        UserInfoCell1 *cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell1" owner:self options:nil] lastObject];
        
        if (row == 0) {
            if ([[self.userdic stringForKey:@"phone"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
                
            } else {
                cell.properties.text =[self.userdic stringForKey:@"phone"];
            }
            cell.name.text = @"手机号:";
            
        }
        if (row == 1) {
            if ([[self.userdic stringForKey:@"email"]isEqualToString:@""])//[[NSString stringWithFormat:@"%@",[self.userdic stringForKey:@"email"]] isEqualToString:@"<null>"]
            {
                cell.properties.placeholder = @"请填写";
                
            } else {
                cell.properties.text =[self.userdic stringForKey:@"email"];
            }
            cell.name.text = @"邮箱:";
            
        }
        if (row == 2) {
            if ([[self.userdic stringForKey:@"username"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
            } else {
                cell.properties.text =[self.userdic stringForKey:@"username"];
            }
            
            cell.name.text = @"姓名:";
        }
        if (row == 3) {
            if ([[self.userdic stringForKey:@"company"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
                
            } else {
                cell.properties.text =[self.userdic stringForKey:@"company"];
            }
            
            cell.name.text = @"所在医院:";
            
        }
        if (row == 4) {
            if ([[self.userdic stringForKey:@"deptname"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请选择";
            } else {
                cell.properties.text =[self.userdic stringForKey:@"deptname"];
            }
            
            cell.name.text = @"科室:";
            [cell.properties endEditing:NO];
            cell.properties.enabled = NO;
        }
        return  cell;
        
    }
    if (row == 5 + NumberOfRow || row == 6 + NumberOfRow || row == 7 + NumberOfRow || row == 8 + NumberOfRow) {
        //static NSString *CellIdentifiers = @"Cells";
        
        UserInfoCell1 *cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell1" owner:self options:nil] lastObject];
        
        
        if (row == 5 + NumberOfRow) {
            if ([[self.userdic stringForKey:@"title"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
                cell.properties.text = @"";
            } else {
                cell.properties.text =[self.userdic stringForKey:@"title"];
            }
            
            cell.name.text = @"职称:";
            
        }
        if (row == 6 + NumberOfRow) {
            if ([[self.userdic stringForKey:@"school"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
                cell.properties.text = @"";
            } else {
                cell.properties.text =[self.userdic stringForKey:@"school"];
            }
            
            cell.name.text = @"毕业/就读学校:";
            
        }
        if (row == 7 + NumberOfRow) {
            if ([[self.userdic stringForKey:@"skill"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
                cell.properties.text = @"";
            } else {
                cell.properties.text =[self.userdic stringForKey:@"skill"];
            }
            
            cell.name.text = @"专业:";
        }
        if (row == 8 + NumberOfRow) {
            if ([[self.userdic stringForKey:@"certificate"]isEqualToString:@""]) {
                cell.properties.placeholder = @"请填写";
                cell.properties.text = @"";
            } else {
                cell.properties.text =[self.userdic stringForKey:@"certificate"];
            }
            cell.name.text = @"学历:";
        }
        
        return  cell;
    }
}


@end
