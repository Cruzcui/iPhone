//
//  MyNoteViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "MyNoteViewController.h"
#import "MyNoteCell.h"
#import "SBJsonParser.h"
@interface MyNoteViewController ()

@end

@implementation MyNoteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _share = [ShareInstance instance];
        _PicArray = [[NSMutableArray alloc] init];
        self.title = @"我的笔记";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_share.MyNoteDic) {
        static NSString *CellIdentifier = @"Cell";
        MyNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyNoteCell" owner:self options:nil];
            
            cell = [array objectAtIndex:0];
        }
        NSEnumerator *enumerator = [_share.MyNoteDic keyEnumerator];
        
        id keys;
        while ((keys = [enumerator nextObject]))
        {
            NSData * JSON =  [self WriteLocalFile:(NSString *)keys andsavefile:@"index"];
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * dic = [parser objectWithData:JSON];
            [parser release];
            cell.titleLabel.text = [dic objectForKey:@"title"];
            NSArray * array = [_share.MyNoteDic objectForKey:(NSString *)keys];
            cell.picCount.text = [NSString stringWithFormat:@"笔记数为:%d",[array count]];
            [cell.picImage setImage:[UIImage imageWithContentsOfFile:[array objectAtIndex:0]]];
            self.key = keys;
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (_share.MyNoteDic == nil) {
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"没有纪录";
            return  cell;
        }
       
    }

}
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放JSON的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[[NSData alloc] initWithContentsOfFile:realPath] autorelease];
    return dataInfile;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  106;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_share.MyNoteDic) {
        NSArray * dataArray = [_share.MyNoteDic objectForKey:self.key];
        if ([_PicArray count] >0) {
            [_PicArray removeAllObjects];
        }
        for (NSString *filePath in dataArray) {
            [_PicArray addObject:[MWPhoto photoWithFilePath:filePath]];
        }
        
        
        
        // Create & present browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        // Set options
        browser.hidesBottomBarWhenPushed = YES;
        browser.displayActionButton = NO;
        browser.wantsFullScreenLayout = YES;
        [self.navigationController pushViewController:browser animated:YES];
      

    }
  
    
    
}
#pragma mark - WMPhotobrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_PicArray count];
}  

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [_PicArray count])
        return [_PicArray objectAtIndex:index];
    return nil;
}


@end
