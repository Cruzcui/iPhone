//
//  YGPSegmentedController.m
//  YGPSegmentedSwitch
//
//  Created by yang on 13-6-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "YGPSegmentedController.h"
#import "Globle.h"
#import "YGPConstKEY.h"
#import "MeetingConst.h"

//按钮空隙
#define BUTTONGAP 5
//按钮长度
#define BUTTONWIDTH 70
//按钮宽度
#define BUTTONHEIGHT 30
//滑条CONTENTSIZEX
#define CONTENTSIZEX 320

//偏移量
#define Off 200
//选择显示区域（view）
#define SelectVisible (sender.tag-100)
#define initselectedIndex 0

@implementation YGPSegmentedController
{

     int ButtonWidthBackg;
     
     NSMutableArray * _Buutonimage;
}
@synthesize TitleArray;
@synthesize SegmentedButton;
@synthesize Delegate=_delegate;
@synthesize Textleng;
@synthesize YGPScrollView;
@synthesize TEXTLENGARRAY;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
         self.frame =CGRectZero;
         YGPScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
         SelectedTagChang = 1;
       
         [self SetScrollview];     //setup
         [self setSelectedIndex:0];
         
    }
    return self;
}

//初始化框架数据
-(id)initContentTitle:(NSMutableArray*)Title CGRect:(CGRect)Frame
{
     if (self = [super init])
     {
          [self addSubview:YGPScrollView];
          TitleArray = Title ;
          [self setFrame:Frame];
          [YGPScrollView setFrame:Frame];
          [self setBackgroundColor];
          YGPScrollView.contentSize = CGSizeMake((BUTTONWIDTH+BUTTONGAP)*[self.TitleArray count]+BUTTONGAP, 40);
          TEXTLENGARRAY = [[NSMutableArray alloc]init];
     }


     //初始化button
     [self initWithButton];
     return self;
}

//设置滚动视图
-(void)SetScrollview
{

     YGPScrollView.backgroundColor = [UIColor whiteColor];
     YGPScrollView.pagingEnabled = NO;
     YGPScrollView.scrollEnabled=YES;
     YGPScrollView.showsHorizontalScrollIndicator = NO;
     YGPScrollView.showsVerticalScrollIndicator = NO;
}

//初始化button
-(void)initWithButton
{
     int buttonPadding = 15;
     int xPos =5;
    int lastButtonWidth = 0;
     SegmentedButton.titleLabel.text=nil;
     NSArray * array = [[NSArray alloc]init];
     NSMutableArray * array2 = [[NSMutableArray alloc]init];
    
    
     for (int i = 0; i<[self.TitleArray count]; i++)
     {
          
          NSString *title = [TitleArray objectAtIndex:i];
          SegmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
          [SegmentedButton setTitle:[NSString stringWithFormat:@"%@",[self.TitleArray objectAtIndex:i]] forState:UIControlStateNormal];
         
         SegmentedButton.titleLabel.font = [UIFont systemFontOfSize:16];

         
          int buttonWidth = [title sizeWithFont:SegmentedButton.titleLabel.font
                             constrainedToSize:CGSizeMake(150, 28)
                                  lineBreakMode:UILineBreakModeClip].width;
         
         lastButtonWidth = buttonWidth;
         
          [SegmentedButton setFrame:CGRectMake(xPos, 9, buttonWidth+buttonPadding, BUTTONHEIGHT)];
          SegmentedButton.tag=i+100;
                    if (i==0)
          {
               SegmentedButton.selected=NO;
          }
         
         
         UIColor* balckColor = [UIColor blackColor];
         
         
          [SegmentedButton setTitleColor:balckColor forState:UIControlStateNormal];
          [SegmentedButton setTitleColor:balckColor forState:UIControlStateSelected];
         
          [SegmentedButton addTarget:self action:@selector(SelectButton:) forControlEvents:UIControlEventTouchUpInside];
       
          
          xPos += buttonWidth+buttonPadding;
          
          _Buutonimage = [[NSMutableArray alloc]init];
          ButtonWidthBackg=buttonWidth+buttonPadding;
         
          NSString * strings;
          strings = nil;
         strings = [NSString stringWithFormat:@"%f",SegmentedButton.frame.size.width];
          
          [_Buutonimage removeAllObjects];
          [array2 addObject:strings];
          for (NSMutableArray * array3 in array2) {
               [_Buutonimage addObject:array3];
          }
      
          [YGPScrollView addSubview:SegmentedButton];
     }
    
    
    xPos += lastButtonWidth;
    
    YGPScrollView.contentSize = CGSizeMake(xPos+10, 40);
     
     //设置选中背景
     ButtonbackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, [[_Buutonimage objectAtIndex:0]floatValue], 40)];
    
     [ButtonbackgroundImage setImage:[UIImage imageNamed:@"red_background.png"]];
    
     //[ButtonbackgroundImage setBackgroundColor:[UIColor whiteColor]];
    
     [YGPScrollView addSubview:ButtonbackgroundImage];
}

//点击button调用方法
-(void)SelectButton:(UIButton*)sender
{
     //取消当前选择
     if (sender.tag!=SelectedTagChang)
     {
          UIButton * ALLButton = (UIButton*)[self viewWithTag:SelectedTagChang];
          ALLButton.selected=NO;
         ALLButton.backgroundColor = [UIColor clearColor];
         
         
          SelectedTagChang = sender.tag;
     }
   
     sender.selected=YES;
    [sender setBackgroundColor:[UIColor whiteColor]];
   
     //button 背景图片
     [UIView animateWithDuration:0.25 animations:^{
          [ButtonbackgroundImage setFrame:CGRectMake(sender.frame.origin.x, 0,[[_Buutonimage objectAtIndex:SelectVisible]floatValue] , 40)];
     } completion:^(BOOL finished){
           [self setSelectedIndex:SelectVisible];
      
       }];

//     NSLog(@"%f",sender.frame.origin.x);
//      [YGPScrollView setContentOffset:CGPointMake(sender.frame.origin.x, 0)];
     float x = YGPScrollView.contentOffset.x;
     [YGPScrollView setContentOffset:CGPointMake(x, 0)];
    
    /*
    NSLog(@"%0.0f %0.0f %0.0f",sender.frame.origin.x,self.frame.size.width,sender.frame.size.width);
     
    int offset = sender.frame.origin.x - ((self.frame.size.width - sender.frame.size.width)/2);
    
    if ((offset+sender.frame.size.width)<self.frame.size.width) {
        offset = self.frame.size.width - sender.frame.size.width;
    }
    
    //设置居中
    if (offset>0)//(sender.frame.origin.x>Off)
    {
        
        [YGPScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
        //[YGPScrollView setContentOffset:CGPointMake(sender.frame.origin.x-130, 0) animated:YES];
        
        
    }else{
        [YGPScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
     */

}

//选择index
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    
     if ([_delegate respondsToSelector:@selector(segmentedViewController:touchedAtIndex:)])
          [_delegate segmentedViewController:self touchedAtIndex:selectedIndex];
}

-(NSInteger)initselectedSegmentIndex
{
     //初始化为（0）
     return initselectedIndex;
}

-(void)setBackgroundColor
{
     //为了区别Tab和View的颜色
    self.backgroundColor = getUIColor(Color_NavBarBackColor); //[UIColor grayColor];
    YGPScrollView.alpha = 0.9;

}
@end
