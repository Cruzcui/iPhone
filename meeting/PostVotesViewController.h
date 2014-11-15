//
//  PostVotesViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDescriptionCell.h"
#import "AddAnswer.h"
#import "ChoiceTypeCell.h"
#import "PostBtnCell.h"
#import "QuestionCell.h"
@interface PostVotesViewController : UITableViewController {
    NSMutableArray * _answersArray;
    int _answerNumber;
    NSString * _questionStr;
    QuestionCell * qcell;
}
@property (nonatomic,retain) NSIndexPath * indexPath;

@end
