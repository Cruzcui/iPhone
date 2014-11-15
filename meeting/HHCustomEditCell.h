//
//  HHCustomEditCell.h
//  DalianPort
//
//  Created by mac on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	CustomEditTypeEdit = 0,
	CustomEditTypeSwitch = 1,
	CustomEditTypeSelection = 2,	
    CustomEditTypeLabel = 3,
    CustomEditTypeTextMemo = 4,
    CustomEditTypeGroup = 5,
    CustomEditTypePassword = 6,
    CustomButton = 99
    
} CustomEditType;


@interface HHCustomEditCell : UITableViewCell<UIAlertViewDelegate,UITextViewDelegate>



@property (nonatomic,assign) CustomEditType cellType;

@property (nonatomic,retain) NSDictionary *cellData;

@property (nonatomic,copy) NSString *Regex;

- (void) setTitleText:(NSString*)titleText;

- (void) setUnitText:(NSString*)unitText;

- (void) setPlaceHolder:(NSString*)placeHolder;

- (void) setText:(NSObject *)text;

- (NSObject *) text;

@end
