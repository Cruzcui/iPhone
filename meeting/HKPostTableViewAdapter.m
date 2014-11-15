//
//  HKPostTableViewAdapter.m
//  meeting
//
//  Created by kimi on 13-8-15.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKPostTableViewAdapter.h"
#import "HHCustomEditCell.h"    
#import "HHCustomListBoxView.h"
#import "MyProfile.h"


@interface HKPostTableViewAdapter()

@property (nonatomic,retain) NSMutableArray *arrayGroupList;

@property (nonatomic,retain) NSMutableArray *arrayCell;
@property (nonatomic,retain) NSArray *arrayContent;

@end


@implementation HKPostTableViewAdapter

@synthesize arrayGroupList;
@synthesize arrayCell;
@synthesize arrayContent;

@synthesize delegate;

-(id) initWithFile:(NSString *)profile PostURL:(NSString *)url
{
    self = [self init];
    if (self) {
        
        NSString* path=[[NSBundle mainBundle] pathForResource:profile
                                             ofType:@"plist"];
        
        self.arrayContent = [[[NSArray alloc]
                      initWithContentsOfFile:path] autorelease];
        
        self.arrayCell = [NSMutableArray arrayWithCapacity:[self.arrayContent count]];
        self.arrayGroupList = [NSMutableArray arrayWithCapacity:[self.arrayContent count]];

        
        NSMutableArray *arrayGroupCell = [NSMutableArray arrayWithCapacity:5];
        
        for (int i=0;i<[self.arrayContent count];i++){
            
            NSDictionary *nsData = [self.arrayContent objectAtIndex:i];
            
            if ([[nsData stringForKey:@"p_Type"] intValue] == CustomEditTypeGroup){
               
                if ([arrayGroupCell count] > 0){
                    arrayGroupCell = [NSMutableArray arrayWithCapacity:5];
                    
                }
                
                [self.arrayCell addObject:arrayGroupCell];
                [self.arrayGroupList addObject:[nsData stringForKey:@"p_Title"]];
                
                
            }else {
                
                HHCustomEditCell *cell;
                
                //最关键的就是这句。加载自己定义的nib文件
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HHCustomEditCell" owner:self options:nil];
                //此时nib里含有的是组件个数
                for (id oneObj in nib) {
                    
                    //NSLog(@"%@",oneObj);
                    
                    if([oneObj isKindOfClass:[HHCustomEditCell class]]){
                        cell = (HHCustomEditCell*)oneObj;
                    }
                }
                
                
                [cell setCellType:(CustomEditType)[(NSString*)[nsData objectForKey:@"p_Type"] intValue]];
                
                [cell setCellData:nsData];
                
                if ([nsData objectForKey:@"p_PlaceHolder"]!= nil){
                    [cell setPlaceHolder:[nsData objectForKey:@"p_PlaceHolder"]];
                }
                
                if ([nsData objectForKey:@"p_UnitTitle"]!= nil){
                    [cell setUnitText:[nsData objectForKey:@"p_UnitTitle"]];
                }
                
                if ([nsData objectForKey:@"p_Regex"]!= nil){
                    [cell setRegex:[nsData objectForKey:@"p_Regex"]];
                }
                
                [cell setTitleText:[nsData objectForKey:@"p_Title"]];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [arrayGroupCell addObject:cell];
                
            }
        }
        
        //if ([arrayGroupCell count] > 0){
        //    [self.arrayCell addObject:arrayGroupCell];
        //}
        
    }
    
    return self;
}

-(void) dealloc
{
    
    self.arrayGroupList = nil;
    self.arrayCell = nil;
    self.arrayContent = nil;
    [super dealloc];
    
    
}

-(NSMutableDictionary*) getInputData
{
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    
    NSDictionary *nsData;
    HHCustomEditCell *cell;
    
    NSString *strKey;
    NSString *strValue;
    
    for (int j=0;j<[self.arrayCell count];j++){
        
        NSMutableArray *nsGroupCell = [self.arrayCell objectAtIndex:j];
        
        for (int i=0;i<[nsGroupCell count];i++){
            
            cell = [nsGroupCell objectAtIndex:i];
            
            nsData = cell.cellData;
            
            NSLog(@"%@",nsData);
            
            strKey = [nsData objectForKey:@"p_PostName"];
            
            if (strKey != nil){
                
                if (cell.cellType == CustomEditTypeSwitch)
                {
                    strValue = [(NSNumber*)[cell text] boolValue]?@"1":@"0";
                }
                else {
                    strValue = (NSString*)[cell text];
                }
                
                if(strValue == nil){
                    strValue = @"";
                }
                
                
                [tmpDict setValue:strValue forKey:strKey];
            }
            
        }
        
    }
    
    //NSLog(@"Release Data:%@",self.request.postda);
    
    
    NSLog(@"Release Data:%@",tmpDict);
    
    
    return tmpDict;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (self.arrayGroupList != nil){
        return [self.arrayGroupList count];
    }
    else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.arrayGroupList objectAtIndex:section] != nil){
        return [self.arrayGroupList objectAtIndex:section];
    }
    else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSMutableArray *nsGroupCell = [self.arrayCell objectAtIndex:section];
    
    
    return [nsGroupCell count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *nsGroupCell = [self.arrayCell objectAtIndex:indexPath.section];
    
    HHCustomEditCell *curCell = (HHCustomEditCell*)[nsGroupCell objectAtIndex:indexPath.row];
    
    if (curCell.cellType == CustomEditTypeTextMemo){
        return 105;
    }
    else {
        
        return 40;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"CellInfo";
    
    // Configure the cell...
    
    
    HHCustomEditCell *cell;
    
    NSMutableArray *nsGroupCell = [self.arrayCell objectAtIndex:indexPath.section];
    
    cell = (HHCustomEditCell*)[nsGroupCell objectAtIndex:indexPath.row];
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HHCustomEditCell* cell = (HHCustomEditCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator){
        
        NSDictionary *nsData = cell.cellData;
        
        NSString *strPlistFile = [nsData objectForKey:@"p_PList"];
        
        if (strPlistFile != nil && ![strPlistFile isEqualToString:@""]){
            
            NSString *path=[[NSBundle mainBundle] pathForResource:strPlistFile
                                                           ofType:@"plist"];
            NSArray *arrayData = [[[NSArray alloc]
                                   initWithContentsOfFile:path] autorelease];
            
            HHCustomListBoxView *detailsView = [[[HHCustomListBoxView alloc] initWithNibName:@"HHCustomListBoxView" bundle:nil tableViewStyle:UITableViewStyleGrouped dictData:arrayData] autorelease];
            
            [detailsView setBackCell:(HHCustomEditCell*)cell];
            
        }
    }else if(cell.cellType == CustomButton){
        if(self.delegate){
            [self.delegate doButtonClick:cell];
        }
    }
}

@end
