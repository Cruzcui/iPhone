//
//  HKLeftSideViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKLeftSideViewController.h"
#import "HKWebViewController.h"
@interface HKLeftSideViewController ()

@end

@implementation HKLeftSideViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    UIView * viewfooter = [[[UIView alloc] init]autorelease];
    self.tableView.tableFooterView = viewfooter;
    self.tableView .backgroundColor = [UIColor whiteColor];

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
    if (section==0) {
        return 0;
    }
    
    if (section==3) {
        return 5;
    }
    if (section == 2) {
        return 2;
    }
    if (section == 1) {
       return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"leftSiderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            cell.imageView.image=[UIImage imageNamed:@"left_search.png"];
            cell.textLabel.text = @"收藏";
        }
    }
    
    if (indexPath.section==1) {
        
        if (indexPath.row == 0) {
            cell.imageView.image=[UIImage imageNamed:@"left_sider_01.png"];
            cell.textLabel.text = @"用户信息";
            cell.textLabel.textColor = [UIColor whiteColor];
        }else if(indexPath.row ==1){
            cell.imageView.image = [UIImage imageNamed:@"left_sider_01_1.png"];
            cell.textLabel.text = @"个人信息";
        }else if(indexPath.row ==2){
            cell.imageView.image = [UIImage imageNamed:@"changepasswords.png"];
            cell.textLabel.text = @" 修改密码";
        }else if(indexPath.row ==3){
            cell.imageView.image = [UIImage imageNamed:@"left_sider_01_2.png"];
            cell.textLabel.text = @"指针信息";
        }

        
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.imageView.image=[UIImage imageNamed:@"left_sider_02.png"];
            cell.textLabel.text = @"系统管理";
             cell.textLabel.textColor = [UIColor whiteColor];
               }
        else if(indexPath.row ==1){
            cell.imageView.image = [UIImage imageNamed:@"left_sider_02_2.png"];
            cell.textLabel.text = @"版本信息";
        }
        
    }else if(indexPath.section ==3 ){
        if (indexPath.row == 0) {
            cell.imageView.image=[UIImage imageNamed:@"left_sider_03.png"];
            cell.textLabel.text = @"软件相关";
             cell.textLabel.textColor = [UIColor whiteColor];
        }else if(indexPath.row ==1){
            cell.imageView.image = [UIImage imageNamed:@"left_sider_03_1.png"];
            cell.textLabel.text = @"意见反馈";
        }else if(indexPath.row ==2){
            cell.imageView.image = [UIImage imageNamed:@"left_sider_03_2.png"];
            cell.textLabel.text = @"免责声明";
        }else if(indexPath.row ==3){
            cell.imageView.image = [UIImage imageNamed:@"left_sider_03_3.png"];
            cell.textLabel.text = @"关于我们";
        }
        else if(indexPath.row ==4){
            cell.imageView.image = [UIImage imageNamed:@"left_side_help.png"];
            cell.textLabel.text = @"操作指南";
        }

    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}


- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor =  indexPath.row==0?[UIColor colorWithRed: 153.0/255 green: 153.0/255 blue: 153.0/255 alpha: 1.0]:[UIColor whiteColor];
    //[UIColor colorWithRed: 225.0/255 green: 225.0/255 blue: 225.0/255 alpha: 1.0];
    
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor colorWithRed: 225.0/255 green: 225.0/255 blue: 225.0/255 alpha: 1.0];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MySelected" object:nil];
    }
    
    
    if (indexPath.section==1) {
        
        if (indexPath.row == 0) {
            
        }
        else if(indexPath.row ==1){
         //个人信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"USERINFO" object:nil];

        }else if(indexPath.row ==3){
         //指针信息
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHIZHEN" object:nil];
        }else if(indexPath.row ==2){
        //修改密码
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEPASSWORD" object:nil];
        }

        
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            
        }else if(indexPath.row ==1){
            //版本信息
             [[NSNotificationCenter defaultCenter] postNotificationName:@"GENGXIN" object:nil];
        }
    }else if(indexPath.section ==3 ){
        if (indexPath.row == 0) {
            
        }else if(indexPath.row ==1){
             [[NSNotificationCenter defaultCenter] postNotificationName:@"FANKUI" object:nil];
            
            //意见反馈
        }else if(indexPath.row ==2){
            //免责声明
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MIANZE" object:nil];

         
        }else if(indexPath.row ==3){
            //关于我们
              [[NSNotificationCenter defaultCenter] postNotificationName:@"ABOUT" object:nil];
                 }
        else if(indexPath.row ==4){
            //关于我们
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CAOZUOZHINAN" object:nil];
        }

}
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



@end
