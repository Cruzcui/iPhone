//
//  HHCustomEditCell.m
//  DalianPort
//
//  Created by mac on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHCustomEditCell.h"

@interface HHCustomEditCell(){
    
    UIView *cellValue;
}

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;

@property (nonatomic,retain) IBOutlet UILabel *unitLabel;

- (IBAction)lostKeyboardFocus:(id)sender;

@end

@implementation HHCustomEditCell

@synthesize cellType = _cellType;
@synthesize titleLabel = _titleLabel;
@synthesize unitLabel = _unitLabel;
@synthesize Regex = _Regex;
@synthesize cellData;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}

- (void)setCellType:(CustomEditType)cellType{
        
  
    
    switch (cellType) {
        case CustomEditTypeEdit:
            cellValue = [[[UITextField alloc] initWithFrame:CGRectMake(90, (self.frame.size.height - 30 )/2, 180, 30)] autorelease];
           
            [(UITextField*)cellValue setTextColor:[UIColor colorWithRed:0x2d/255.0 green:0x64/255.0 blue:0xb3/255.0 alpha:1]];
            //[(UITextField*)cellValue setBorderStyle:UITextBorderStyleLine];
            [(UITextField*)cellValue setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            
            [(UITextField*)cellValue setFont:[UIFont systemFontOfSize:14]];
            [(UITextField*)cellValue setReturnKeyType:UIReturnKeyDone];
            [(UITextField*)cellValue addTarget:self action:@selector(lostKeyboardFocus:) forControlEvents:UIControlEventEditingDidEndOnExit];
             break;
        case CustomEditTypePassword:
            cellValue = [[[UITextField alloc] initWithFrame:CGRectMake(90, (self.frame.size.height - 30 )/2, 180, 30)] autorelease];
            
            [(UITextField*)cellValue setTextColor:[UIColor colorWithRed:0x2d/255.0 green:0x64/255.0 blue:0xb3/255.0 alpha:1]];
            [(UITextField*)cellValue setSecureTextEntry:YES];
            [(UITextField*)cellValue setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            
            [(UITextField*)cellValue setFont:[UIFont systemFontOfSize:14]];
            [(UITextField*)cellValue setReturnKeyType:UIReturnKeyDone];
            [(UITextField*)cellValue addTarget:self action:@selector(lostKeyboardFocus:) forControlEvents:UIControlEventEditingDidEndOnExit];
            break;

        case CustomEditTypeLabel:
            cellValue = [[[UILabel alloc] initWithFrame:CGRectMake(90, (self.frame.size.height - 30 )/2, 180, 30)] autorelease];
            
            [(UILabel*)cellValue setBackgroundColor:[UIColor clearColor]];
            [(UILabel*)cellValue setTextColor:[UIColor colorWithRed:0x2d/255.0 green:0x64/255.0 blue:0xb3/255.0 alpha:1]];
            [(UILabel*)cellValue setFont:[UIFont systemFontOfSize:14]];
            [(UILabel*)cellValue setMinimumFontSize:14];

            break;
        case CustomEditTypeSwitch:
            cellValue = [[[UISwitch alloc] initWithFrame:CGRectMake(200, (self.frame.size.height - 27 )/2, 100, 27)] autorelease];
            break;
        case CustomEditTypeSelection:
            cellValue = [[[UILabel alloc] initWithFrame:CGRectMake(90, (self.frame.size.height - 30 )/2, 180, 30)] autorelease];
            [(UILabel*)cellValue setBackgroundColor:[UIColor clearColor]];
            [(UILabel*)cellValue setTextColor:[UIColor colorWithRed:0x2d/255.0 green:0x64/255.0 blue:0xb3/255.0 alpha:1]];
            [(UILabel*)cellValue setFont:[UIFont systemFontOfSize:14]];
            [(UILabel*)cellValue setMinimumFontSize:14];
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case CustomEditTypeTextMemo:
            cellValue = [[[UITextView alloc] initWithFrame:CGRectMake(90, 7.5, 180, 90)] autorelease];
            [(UITextView*)cellValue setBackgroundColor:[UIColor clearColor]];
            [(UITextView*)cellValue setTextColor:[UIColor colorWithRed:0x2d/255.0 green:0x64/255.0 blue:0xb3/255.0 alpha:1]];
            [(UITextView*)cellValue setFont:[UIFont systemFontOfSize:14]];
            [(UITextView*)cellValue setReturnKeyType:UIReturnKeyDone];
            [(UITextView*)cellValue setDelegate:self];
            break;
            
        case CustomButton:
            self.titleLabel.frame = self.frame;
            
            
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.titleLabel setFont:[UIFont systemFontOfSize:20]];
            [self.titleLabel setMinimumFontSize:18];
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            self.backgroundColor = [UIColor redColor];
           
            break;
            
        default:
            break;
    }
    
    
    
    [self addSubview:cellValue];
    
    _cellType = cellType;
}

- (void) setTitleText:(NSString*)titleText{
    [self.titleLabel setText:titleText];
    
    if (self.cellType == CustomEditTypeLabel)
        [self.titleLabel sizeToFit];
}

- (void) setUnitText:(NSString*)unitText{
    [self.unitLabel setText:unitText];
}

- (void) setPlaceHolder:(NSString*)placeHolder{
    
    if (self.cellType == CustomEditTypeEdit && cellValue != nil){
        UITextField *curCellValue = (UITextField*)cellValue;
        
        [curCellValue setPlaceholder:placeHolder];
        
        curCellValue = nil;
    }
}

- (void) setText:(NSObject *)text{
    
    UITextField *curTextField;
    UILabel *curLabel;
    UISwitch *curSwitch;
    UITextView *curTextView;
    
    switch (self.cellType) {
        case CustomEditTypeEdit:
        case CustomEditTypePassword:
            curTextField = (UITextField*)cellValue;
            [curTextField setText:(NSString*)text];
            curTextField = nil;            
            break;
        case CustomEditTypeLabel:
            curLabel = (UILabel*)cellValue;
            [curLabel setText:(NSString*)text];
            curLabel = nil;
            break;
        case CustomEditTypeSwitch:
            curSwitch = (UISwitch*)cellValue;
            [curSwitch setOn:[(NSNumber*)text boolValue] animated:YES];
            curSwitch = nil;
            break;
        case CustomEditTypeSelection:
            curLabel = (UILabel*)cellValue;
            [curLabel setText:(NSString*)text];
            curLabel = nil;
            break;
        case CustomEditTypeTextMemo:
            curTextView = (UITextView*)cellValue;
            [curTextView setText:(NSString*)text];
            curTextView = nil;
        case CustomButton:
            //curLabel = (UILabel*)cellValue;
            //[curLabel setText:(NSString*)text];
            //curLabel = nil;
        default:
            break;
    }

}

- (NSObject *) text{
    UITextField *curTextField;
    UILabel *curLabel;
    UISwitch *curSwitch;
    UITextView *curTextView;
    
    switch (self.cellType) {
        case CustomEditTypeEdit:
        case CustomEditTypePassword:
            curTextField = (UITextField*)cellValue;
            return curTextField.text;
            break;
        
        case CustomEditTypeSwitch:
            curSwitch = (UISwitch*)cellValue;
            return [NSNumber numberWithBool:curSwitch.on];
            break;
        case CustomEditTypeLabel:
        case CustomEditTypeSelection:
            curLabel = (UILabel*)cellValue;
            return curLabel.text;
            break;
        case CustomEditTypeTextMemo:
            curTextView = (UITextView*)cellValue;
            return curTextView.text;
            break;
            
        case CustomButton:
            return self.titleLabel.text;
            break;

        default:
            return nil;
            break;
    }

}

- (IBAction)lostKeyboardFocus:(id)sender{
    
    UITextField *curTextField = (UITextField*)cellValue;
    
    if (![curTextField.text isEqualToString:@""]){
        
        if ([self validateData:curTextField.text]){
            [curTextField resignFirstResponder];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入不符合规范要求，请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alertView show];
            
            [alertView release];
            
        }
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [(UITextField*)cellValue becomeFirstResponder];
}

- (BOOL) validateData: (NSString *) candidate {
    
    //NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    
    if (self.Regex != nil && ![self.Regex isEqualToString:@""]){
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.Regex]; 
                
        return [emailTest evaluateWithObject:candidate];
    }
    else {
        return YES;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {//按下return键
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }else {
        if ([textView.text length] < 150) {//判断字符个数
            return YES;
        }  
    }
    return NO;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect frame;
    
    frame = self.titleLabel.frame;
    
    frame.size.height = self.frame.size.height;
    
    [self.titleLabel setFrame:frame];
    
    if (cellValue != nil){
        
        frame = cellValue.frame;
        
        frame.origin.y = (self.frame.size.height - frame.size.height)/ 2;
        
        [cellValue setFrame:frame];

    }
}

- (void)dealloc{
    
    self.cellData = nil;
    
    [super dealloc];
}

@end
