//
//  MyNoteMoreViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "ShareInstance.h"
@interface MyNoteMoreViewController : UITableViewController<MWPhotoBrowserDelegate> {
    ShareInstance *_share;
    UIAlertView * _alert;
}
@property (nonatomic,retain) NSMutableArray * PicArray;
@property (nonatomic,retain) NSMutableArray * ZhiNanArray;
@property (nonatomic,retain) NSMutableDictionary * dataDic;
@property (nonatomic,assign) BOOL jingduFlag;
@property (nonatomic,retain) NSString * pkey;
@end
