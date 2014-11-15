//
//  HKCommonsMakerViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCommonsMakerViewController.h"
#import "UMSocial.h"
#import "HKTabBarItem.h"
#import "MeetingConst.h"


@interface HKCommonsMakerViewController ()<ACEDrawingViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *markImageView;
@property (retain,nonatomic) IBOutlet UIToolbar * toolbar;
@end

@implementation HKCommonsMakerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.canMark = YES;
        _share = [ShareInstance instance];
    }
    return self;
}

-(void) dealloc{
    
    self.markImage = nil;
    
    [_markImageView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        
    }

    self.title = @"点评批注";
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     nil]];
    
    /*
    UIButton* btnMessage = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
    
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"icon_message.png"] forState:UIControlStateNormal];
    [btnMessage addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    
    
    self.markImageView.image = self.markImage;
    
   
    
    if (!self.canMark) {
        [self.singView setHidden:YES];
    }else{
        
        NSLog(@"%0.0f",self.markImageView.frame.size.height);
        NSLog(@"%0.0f",self.view.bounds.size.height);
        
        //self.markImageView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-self.toolbar.frame.size.height);
    }
    
    //toobar item
    NSMutableArray* barItems = [NSMutableArray array];
    
    
    //分隔按钮
    UIBarButtonItem* splitBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:splitBtn1];
    
    
    //文字
    HKTabBarItem* itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"read_text.png"] title:@"文字"];
    
    [itemView addTarget:self action:@selector(texts:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* textBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
    //[[[UIBarButtonItem alloc] initWithTitle:@"前一章" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnPreClick:)] autorelease] ;
    
    [barItems addObject:textBtn];
    
    splitBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:splitBtn1];

    //涂鸦笔
    itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"read_pen.png"] title:@"涂鸦笔"];
    
    [itemView addTarget:self action:@selector(tuyabi:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* penBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
    //[[[UIBarButtonItem alloc] initWithTitle:@"前一章" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnPreClick:)] autorelease] ;
    
    [barItems addObject:penBtn];
    
    
    splitBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:splitBtn1];

    //橡皮擦
    itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"read_clean.png"] title:@"橡皮擦"];
    
    [itemView addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* undoBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
    //[[[UIBarButtonItem alloc] initWithTitle:@"前一章" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnPreClick:)] autorelease] ;
    
    [barItems addObject:undoBtn];
    
    
    splitBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:splitBtn1];

    
    //撤销
    itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"read_redo.png"] title:@"撤销"];
    
    [itemView addTarget:self action:@selector(redo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* redoBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
    //[[[UIBarButtonItem alloc] initWithTitle:@"前一章" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnPreClick:)] autorelease] ;
    
    [barItems addObject:redoBtn];
    
    
    //分隔按钮
    UIBarButtonItem* splitBtn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:splitBtn2];
    
    
    //分享
    /*
    itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"icon_share.png"] title:@"分享"];
    
    [itemView addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* shareBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
    //[[[UIBarButtonItem alloc] initWithTitle:@"前一章" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnPreClick:)] autorelease] ;
    
    [barItems addObject:shareBtn];
     */
    
    [self.toolbar setItems:barItems];
    self.toolbar.translucent = NO;
    [self.toolbar setBarTintColor:getUIColor(Color_tabbar_background)];
    
    
    
    self.singView.lineWidth = 2;
    self.singView.lineColor = [UIColor redColor];
    
    self.singView.delegate = self;
    
    
    //left button
    UIButton* btnBack = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
    
    [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* barItemBack = [[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
    
    self.navigationItem.leftBarButtonItem = barItemBack;
    
    
    UIBarButtonItem* barItemSave = [[[UIBarButtonItem alloc] initWithTitle:@"保存/分享" style:UIBarButtonItemStyleBordered target:self action:@selector(RightButtonClick)] autorelease];// initWithCustomView:btnSave] autorelease];
    
    self.navigationItem.rightBarButtonItem = barItemSave;
    
    
    
    
    //键盘处理
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    
    [topView setItems:buttonsArray];
   

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMarkImageView:nil];
    [super viewDidUnload];
}


- (IBAction)undo:(id)sender
{
    _singView.lineWidth = 5;
   _singView.drawTool = ACEDrawingToolTypeCure;
}

- (IBAction)redo:(id)sender
{
    [self.singView undoLatestStep];
    [self updateButtonStatus];
}


- (IBAction)texts:(id)sender {
    
   _singView.lineWidth = 2;
   text = [[[NSBundle mainBundle] loadNibNamed:@"TextInput" owner:self options:nil] objectAtIndex:0];
    
    [text setFrame:CGRectMake(10, 10, 300, 160)];
    text.layer.borderColor = [UIColor grayColor].CGColor;
    text.layer.borderWidth =1.0;
    text.layer.cornerRadius =5.0;
    text.layer.borderColor = [UIColor grayColor].CGColor;
    text.textView.layer.borderWidth =1.0;
    text.textView.layer.cornerRadius =5.0;

    [text.textView becomeFirstResponder];

    [text.textView setInputAccessoryView:topView];
    [topView release];

    [text.btn addTarget:self action:@selector(finishDone) forControlEvents:UIControlEventTouchUpInside];
    [text.cancel addTarget:self action:@selector(cancelexit) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:text];
    self.textbtn.enabled = NO;
    
    // ACEDrawingToolTypeRectagleStroke;
}
-(void)dismissKeyBoard
{
    [text.textView resignFirstResponder];
}
-(void) finishDone {
    
    if(text.textView.text==nil || text.textView.text.length<1){
        return;
    }
    
    _singView.tooltext = text.textView.text;
    [text removeFromSuperview];
    text = nil;
    self.textbtn.enabled = YES;
    
    [_singView addTextTools:_singView.tooltext At:CGPointMake(20, 20)];
    
    //_singView.drawTool = ACEDrawingToolTextTool;
}
-(void) cancelexit {
    [text removeFromSuperview];
    text = nil;
    self.textbtn.enabled = YES;

}
- (IBAction)tuyabi:(id)sender {
    _singView.drawTool = ACEDrawingToolTypePen;
  _singView.lineWidth = 2;

}


-(IBAction) share:(id)sender{
    
    
    
    [_singView qieTu:CGRectMake(0, 0, 320,self.view.bounds.size.height - self.toolbar.bounds.size.height*2)];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"52d65dfb56240b840a03efc2"
                                      shareText:@"你要分享的文字"
                                     shareImage:_singView.ima
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];
    
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.singView canUndo];
//    self.redoButton.enabled = [self.singView canRedo];
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}


-(void) rightButtonClick:(id)sender{
    
    //TODO:保存截图
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) leftButtonClick:(id) sender{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)RightButtonClick {
    
    [self share:nil];
    
    [_singView qieTu:CGRectMake(0, 0, 320,self.view.bounds.size.height - self.toolbar.bounds.size.height*2)];
    
    if (![_share.WenJianJiaName isEqualToString: [self.DicForPic objectForKey:@"pkey"]]) {
        _share.WenJianJiaName = [self.DicForPic objectForKey:@"pkey"];
        _share.PicName = 1;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    [_singView savePicture:_share.WenJianJiaName andsavefile:[NSString stringWithFormat:@"pizhu%@.jpg",[dateFormatter stringFromDate:[NSDate date]] ]];
    [dateFormatter release];

    _share.PicName ++;
  
}

@end
