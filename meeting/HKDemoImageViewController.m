//
//  HKDemoImageViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKDemoImageViewController.h"

@interface HKDemoImageViewController ()

@end

@implementation HKDemoImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageView release];
    [_image release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageView:nil];
    [self setImage:nil];
    [super viewDidUnload];
}
@end
