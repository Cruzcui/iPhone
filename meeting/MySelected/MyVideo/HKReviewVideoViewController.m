//
//  HKReviewVideoViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKReviewVideoViewController.h"
#import "HKMycommonsCell.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
@interface HKReviewVideoViewController ()

@end

@implementation HKReviewVideoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _share = [ShareInstance instance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
        
    }
    if (_share.MyVideoDic) {
        NSDictionary* data = _share.MyVideoDic;
        
        //    cell.imgTitle.image =[UIImage imageNamed:[data stringForKey:@"image"]];
        [cell.imgTitle setImageWithURL:[NSURL URLWithString:[data stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"nav_3@2x.png"]];
        
        cell.titleLabel.text = [data stringForKey:@"title"];
        cell.sectionLabel.text = [data stringForKey:@"author"];
        cell.timeLabel.text = [data stringForKey:@"time"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_share.MyVideoDic) {
        NSDictionary* data = _share.MyVideoDic;
        [self createMPPlayerController:[data stringForKey:@"videourl"]];

    }
    
    
}
- (void)createMPPlayerController:(NSString *)sFileNamePath {
    
    MPMoviePlayerViewController *moviePlayer =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:sFileNamePath]];
    moviePlayer.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    [moviePlayer.moviePlayer prepareToPlay];
    
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    
    [moviePlayer.view setFrame:self.view.bounds];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer]; // 这里是presentMoviePlayerViewControllerAnimated
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(movieFinishedCallback:)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
     
                                               object:moviePlayer];
    
    [moviePlayer release];
    
}
-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                  object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}

@end
