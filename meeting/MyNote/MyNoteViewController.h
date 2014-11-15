//
//  MyNoteViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
#import "MWPhotoBrowser.h"
@interface MyNoteViewController : UITableViewController<MWPhotoBrowserDelegate> {
    ShareInstance * _share;
    NSMutableArray * _PicArray;
}
@property (nonatomic,copy)NSString *key;

@end
