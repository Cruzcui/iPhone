//
//  HHCustomListBoxView.h
//  DalianPort
//
//  Created by mac on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHCustomEditCell.h"

@protocol HHCustomListBoxViewDelegate
- (void) selectedFinish;
@end

@interface HHCustomListBoxView : UIViewController<UITableViewDelegate,UITableViewDataSource,HHCustomListBoxViewDelegate>{
  
}

@property (nonatomic, retain) IBOutlet UITableView *tbView;
@property (nonatomic, retain) NSArray *content;
@property (nonatomic, assign) id<HHCustomListBoxViewDelegate> delegate;
@property (nonatomic, retain) HHCustomEditCell *backCell;
@property (nonatomic,copy) NSString *prevValue;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
       tableViewStyle:(UITableViewStyle) style dictData:(NSArray *) arrayData;

@end
