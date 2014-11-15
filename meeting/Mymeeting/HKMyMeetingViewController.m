//
//  HKMyMeetingViewController.m
//  HisGuidline
//
//  Created by kimi on 14-2-25.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMyMeetingViewController.h"
#import "UIButton+HHStyle.h"
#import <QuartzCore/QuartzCore.h>
#import "HKMeetingDetailViewController.h"
#import "ZBarSDK.h"

@interface HKMyMeetingViewController ()<ZBarReaderDelegate>

@end

@implementation HKMyMeetingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"我的会议";
        self.tabBarItem.image = [UIImage imageNamed:@"tab05.png"];
        _domain = [[MeetingDomain alloc] init];
        [_domain setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.btnScanMeeting hhStyle];
    [self.btnStartMetting hhStyle];
    self.txtlabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtlabel.layer.cornerRadius = 5;
    self.txtlabel.layer.borderWidth = 1;
    
    //进入会议
    [self.btnStartMetting addTarget:self action:@selector(startMeeting) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    [self.txtMeetingid setInputAccessoryView:topView];
  
    [topView release];
}
-(void)dismissKeyBoard
{
    [self.txtMeetingid resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) startMeeting {
    if (self.txtMeetingid.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入会议ID" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:self.txtMeetingid.text forKey:@"id"];
    [_domain getMeeting:params];
    
}
-(void) didParsDatas:(HHDomainBase *)domainData {
    if (domainData.dataDetails.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有该会议ID" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    }else {
        HKMeetingDetailViewController * meetingDetail = [[HKMeetingDetailViewController new] autorelease];
        meetingDetail.Maintitle = [[domainData.dataDetails lastObject] stringForKey:@"title"];
        meetingDetail.pkey = [[domainData.dataDetails lastObject] stringForKey:@"pkey"];
        [self.navigationController pushViewController:meetingDetail animated:YES];
       
    }
    
}

-(IBAction) btnScanClick:(id)sender{
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    //reader.scanCrop = CGRectMake(60, 190, 200, 200);
    reader.wantsFullScreenLayout = NO;
    reader.showsZBarControls = NO;
    
    [self setOverlayPickerView:reader];
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
    
    [reader release];
    
}


- (void)setOverlayPickerView:(ZBarReaderViewController *)reader

{
    
    //清除原有控件
    
    for (UIView *temp in [reader.view subviews]) {
        
        for (UIButton *button in [temp subviews]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                [button removeFromSuperview];
                
            }
            
        }
        
        for (UIToolbar *toolbar in [temp subviews]) {
            
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                
                [toolbar setHidden:YES];
                
                [toolbar removeFromSuperview];
                
            }
            
        }
        
    }
    
    //画中间的基准线
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    
    line.backgroundColor = [UIColor redColor];
    
    [reader.view addSubview:line];
    
    [line release];
    
    //最上部view
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    upView.alpha = 0.3;
    
    upView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:upView];
    
    //用于说明的label
    
    UILabel * labIntroudction= [[UILabel alloc] init];
    
    labIntroudction.backgroundColor = [UIColor clearColor];
    
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    
    labIntroudction.numberOfLines=2;
    
    labIntroudction.textColor=[UIColor whiteColor];
    
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    
    [upView addSubview:labIntroudction];
    
    [labIntroudction release];
    
    [upView release];
    
    //左侧的view
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    
    leftView.alpha = 0.3;
    
    leftView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:leftView];
    
    [leftView release];
    
    //右侧的view
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    
    rightView.alpha = 0.3;
    
    rightView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:rightView];
    
    [rightView release];
    
    //底部view
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 220)];
    
    downView.alpha = 0.3;
    
    downView.backgroundColor = [UIColor blackColor];
    
    [reader.view addSubview:downView];
    
    [downView release];
    
    //用于取消操作的button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    cancelButton.alpha = 0.4;
    
    [cancelButton setFrame:CGRectMake(20, 390, 280, 40)];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    
    [reader.view addSubview:cancelButton];
    
}

-(void) dismissOverlayView:(id) sender{
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
   self.txtMeetingid.text = symbol.data;//[symbol.data stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:^{
        [self startMeeting];
    }];
}




- (void)dealloc {
    [_domain release];
    [_txtlabel release];
    [_txtMeetingid release];
    [_btnStartMetting release];
    [_btnScanMeeting release];
    [super dealloc];
}
@end
