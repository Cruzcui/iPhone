//
//  HKCategoryViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCategoryViewController.h"
#import "HKCategoryDomain.h"
#import "MyProfile.h"
#import "ShareInstance.h"

#define HasSelectedKey @"__HasSelectedKey"

@interface HKCategoryViewController ()<HHDomainBaseDelegate>


@property (nonatomic,retain) HKCategoryDomain* cagegoryDomain;
@property (nonatomic,retain) HKCategoryDomain* SystemOptionDomain;
@end

@implementation HKCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.cagegoryDomain = [[[HKCategoryDomain alloc] init] autorelease];
        
        self.cagegoryDomain.delegate = self;
        
        self.SystemOptionDomain = [[[HKCategoryDomain alloc] init] autorelease];
        
        self.SystemOptionDomain.delegate = self;

        self.arrayCategoryList = [NSMutableArray array];
        
        self.pageType = 0;

        self.indexRow = 0;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}
-(void) dealloc{
    
    //2012-2-20 by kimi
    self.favSectionArray = nil;
    self.arrayCategoryList = nil;
    
    self.cagegoryDomain = nil;
    self.SystemOptionDomain = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"科室订阅";
    
    [self.cagegoryDomain setDelegate:self];
    [self.cagegoryDomain requestCategory];
    [self.SystemOptionDomain setDelegate:self];
    

    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"html_iphone" forKey:@"pkey"];
    [self.SystemOptionDomain getSystemOption:params];
    
    //self.tableView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    
    
    if (self.pageType == 1) {
        
        /*
        UIButton* btnHome = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
        
        [btnHome setBackgroundImage:[UIImage imageNamed:@"left_search.png"] forState:UIControlStateNormal];
        [btnHome setTitle:@"确定" forState:UIControlStateNormal];
        
        [btnHome addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         */
        
        UIBarButtonItem* barItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonClick:)] autorelease];
        
        self.navigationItem.rightBarButtonItem = barItem;
        
        self.tableView.editing = YES;
        
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        tap.numberOfTapsRequired = 1;
        [self.tableView addGestureRecognizer:tap];
        [tap release];
        

        
//        UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonClick:)];
//        
//        self.navigationItem.rightBarButtonItem = rightButton;
//        
//        [rightButton release];
        
        //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick:)] autorelease];
    }
    

}


-(void)longPressToDo:(UITapGestureRecognizer *)gesture

{
    //if(gesture.state == UIGestureRecognizerStateBegan)
        
    //{
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        NSMutableDictionary * dataSourceDic =  [_arrayCategoryList objectAtIndex:indexPath.row];
        if (self.pageType==1) {
            if ([[dataSourceDic stringForKey:HasSelectedKey] isEqualToString:@"1"]) {
                [dataSourceDic setValue:@"0" forKey:HasSelectedKey];
            }else{
                [dataSourceDic setValue:@"1" forKey:HasSelectedKey];
            }
            
            [self.tableView reloadData];
        }
    //}
 
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
    if ([_arrayCategoryList count] < 1) {
        return 1;
    }else{
        return [_arrayCategoryList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([_arrayCategoryList count] < 1) {
        cell.textLabel.text = @"正在加载，请稍后...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    
    NSDictionary * dicArray = [_arrayCategoryList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dicArray stringForKey:@"sname"];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if ([self.selectedKeshi isEqualToString:[dicArray stringForKey:@"sname"]] && self.pageType == 0) {
//        cell.backgroundColor = [UIColor lightGrayColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    }
    if (self.pageType == 0) {
        if (self.indexRow == indexPath.row ) {
             cell.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else {
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
    }
   
    
//    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
//    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    
    //科室订阅
    if (self.pageType == 1) {
        //cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked_checkbox"]] autorelease];
        [cell.imageView setImage:[UIImage imageNamed:@"unchecked_checkbox"]];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if ([[dicArray stringForKey:HasSelectedKey] isEqualToString:@"1"]) {
//            cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_checkbox"]] autorelease];
            [cell.imageView setImage:[UIImage imageNamed:@"checked_checkbox"]];
        }
        
        
    }
    
    return cell;
}


-(BOOL) hasFavSection:(NSString*) sectionKey{
    
    
    
    for (NSDictionary* dic in self.favSectionArray) {
        if ([[dic stringForKey:@"pkey"] isEqualToString:sectionKey]) {
            return YES;
        }
        
    }
    
    return NO;
}

-(void) rightButtonClick:(id) sender{
    
    
    NSMutableArray* favSectionArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary* sourceDic in self.arrayCategoryList) {
        if ([[sourceDic stringForKey:HasSelectedKey] isEqualToString:@"1"] ) {
            [favSectionArray addObject:sourceDic];
        }
    }
    
    if (self.delegate!=nil) {
        if ([self.delegate respondsToSelector:@selector(hkDLCategorytableView: didSelectFav:)]) {
            [self.delegate hkDLCategorytableView:self didSelectFav:favSectionArray];
        }
    }
    NSString * arrayString =  [_arrayCategoryList toJson];
    [[NSUserDefaults standardUserDefaults] setObject:arrayString forKey:@"arraylist"];

    [self.navigationController popToRootViewControllerAnimated:YES];

    
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dataSourceDic =  [_arrayCategoryList objectAtIndex:indexPath.row];
  

    
    if (self.pageType==1) {
        
        if ([[dataSourceDic stringForKey:HasSelectedKey] isEqualToString:@"1"]) {
            [dataSourceDic setValue:@"0" forKey:HasSelectedKey];
        }else{
            [dataSourceDic setValue:@"1" forKey:HasSelectedKey];
        }
        
        [self.tableView reloadData];
        return;
    }
    
    if (_delegate) {
        
        [_delegate hkDLCategorytableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:dataSourceDic];
        
          }
    self.indexRow = indexPath.row;
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor lightGrayColor];
    [self.tableView reloadData];
    
    
}

#pragma mark  - DomainDelegate
-(void) didParsDatas:(HHDomainBase *)domainData{
    if (domainData == self.cagegoryDomain) {
        
        [ShareInstance instance].categroyDatas = self.cagegoryDomain.dataDetails;
        
        
        [self.arrayCategoryList removeAllObjects];
        
        if (self.pageType == 1) {
            NSString * json = [[NSUserDefaults standardUserDefaults] objectForKey:@"arraylist"];
            if (json != nil) {
                NSArray * array = [NSArray fromString:json];
                if (array.count != [domainData dataDetails].count + 1) {
                    NSMutableDictionary* defaultSection = [NSMutableDictionary dictionary];
                    [defaultSection setObject:@"-1" forKey:@"pkey"];
                    [defaultSection setObject:@"全学科" forKey:@"sname"];
                    
                    if ([self hasFavSection:[defaultSection stringForKey:@"pkey"]]) {
                        [defaultSection setValue:@"1" forKey:HasSelectedKey];
                    }else{
                        [defaultSection setValue:@"0" forKey:HasSelectedKey];
                    }
                    
                    [self.arrayCategoryList addObject:defaultSection];
                } else {
                    self.arrayCategoryList = (NSMutableArray *) array;
                    return;
                }

            }
            else {
                NSMutableDictionary* defaultSection = [NSMutableDictionary dictionary];
                [defaultSection setObject:@"-1" forKey:@"pkey"];
                [defaultSection setObject:@"全学科" forKey:@"sname"];
                
                if ([self hasFavSection:[defaultSection stringForKey:@"pkey"]]) {
                    [defaultSection setValue:@"1" forKey:HasSelectedKey];
                }else{
                    [defaultSection setValue:@"0" forKey:HasSelectedKey];
                }
                
                [self.arrayCategoryList addObject:defaultSection];
                
            }

           
        }
        
        for (NSDictionary* sourceDic in [domainData dataDetails]) {
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:sourceDic];
            
            if ([self hasFavSection:[dict stringForKey:@"pkey"]]) {
                [dict setValue:@"1" forKey:HasSelectedKey];
            }else{
                [dict setValue:@"0" forKey:HasSelectedKey];
            }
            
            [self.arrayCategoryList addObject:dict];
        }
        
        
        
        // [_delegate didParsDatas:domainData];
        if ([_arrayCategoryList count] > 0) {
            NSDictionary * dicsource = [_arrayCategoryList objectAtIndex:0];
         
            
            //我的社区发送初始化消息数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WODESHEQU" object:dicsource];
            
            
            /* 2014-2-20 by kimi
            //指南原/Users/cuiyang/Desktop/2013_11_医学指南针/代码/iPhone/meeting/HisGuidLine/HKGuidListViewCell.h文发送初始化消息数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHINANLIEBIAO" object:dicsource];
            //我的社区发送初始化消息数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WODESHEQU" object:dicsource];
             */
            //医学工具发送初始化消息数据
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"TOOLS" object:dicsource];
        }
        
        
        [self.tableView reloadData];

    }
    if (domainData == self.SystemOptionDomain) {
        MyProfile * profile = [MyProfile myProfile];
        profile.SystemInfo = [domainData dataDictionary];
    }


}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageType == 1) {
         return YES;
    }
    return NO;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageType == 1 ) {
        return YES;
    }
    return NO;

}


// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


// Data manipulation - reorder / moving support
//
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //修改对应的数据源
    if (self.pageType == 1) {
        id object= [[_arrayCategoryList objectAtIndex:sourceIndexPath.row] retain];
        [_arrayCategoryList removeObjectAtIndex:sourceIndexPath.row];
        [_arrayCategoryList insertObject:object atIndex:destinationIndexPath.row];
        [object release];
        
        NSString * arrayString =  [_arrayCategoryList toJson];
        [[NSUserDefaults standardUserDefaults] setObject:arrayString forKey:@"arraylist"];
    }
   
}
//- (void)editBUttonOnClicked
//{
//    [self.tableView setEditing:self.tableView.editing animated:YES];
//    
//    if (self.tableView.editing) {
//        UIBarButtonItem *barButtonItem = self.navigationItem.rightBarButtonItem;
//        barButtonItem.title = @"Edit";
//    }else {
//        UIBarButtonItem *barButtonItem = self.navigationItem.rightBarButtonItem;
//        barButtonItem.title = @"Done";
//    }
//}
- (void)setEditing:(BOOL)e animated:(BOOL)ani
{
    [super setEditing:e animated:ani];
    [self.tableView setEditing:e animated:ani];//tableView 设置
    
//    if (e) self.editButtonItem.title = @"done";
//    else self.editButtonItem.title = @"edit";
}

@end
