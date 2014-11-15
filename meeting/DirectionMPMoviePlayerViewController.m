//
//  DirectionMPMoviePlayerViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-7.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "DirectionMPMoviePlayerViewController.h"

@implementation DirectionMPMoviePlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initLogic];
}




- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
-(void)initLogic
{
    isPortraitIn_ = NO;
    isSettingStatusBar_ = NO;
}
-(BOOL)shouldAutorotate
{
       return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (isPortraitIn_)
    {
        self.view.transform = CGAffineTransformIdentity;
        isPortraitIn_ = NO;
    }
}

- (void)cleanRotationTrace
{
    if (isPortraitIn_)
    {
        self.view.transform = CGAffineTransformIdentity;
        isPortraitIn_ = NO;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            isSettingStatusBar_ = NO;
        }
        else
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated:NO];
            isSettingStatusBar_ = NO;
        }
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.height + 20, self.view.frame.size.width - 20)];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        isPortraitIn_ = YES;
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        if (orientation == UIInterfaceOrientationPortrait)
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            isSettingStatusBar_ = NO;
        }
        else
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
            isSettingStatusBar_ = NO;
        }
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.height , self.view.frame.size.width)];
    }
}
@end  