//
//  PostVotesViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PostVotesViewController.h"
@interface PostVotesViewController ()

@end

@implementation PostVotesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _answersArray = [[NSMutableArray alloc] init];
        _answerNumber = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //header
    UIView * headerView = [[UIView alloc] init];
    [headerView setFrame:CGRectMake(0, 0, 320, 50)];
    UILabel * label = [[UILabel alloc] initWithFrame:headerView.bounds];
    [headerView addSubview:label];
    [label release];
    label.text = @"发布违法，反动投票信息依据纪录提交公安机关处理，请不要发涉及敏感政治话题";
    label.font = [UIFont systemFontOfSize:14.0];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    self.tableView.tableHeaderView = headerView;
    [headerView release];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 1 + _answerNumber;
    }
    if (section == 2) {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * cellIndectifierDescription = @"decription";
            PostDescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndectifierDescription];
            if (!cell) {
                cell = [[[PostDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndectifierDescription]autorelease];
            }
            [cell.textView setFrame:CGRectMake(5, 5, 320 - 10, 50-10)];
            return  cell;
        }
        if (indexPath.row == 1) {
            static NSString * cellIndectifierDescriptions = @"decriptions";
            PostDescriptionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndectifierDescriptions];
            if (!cell) {
                cell = [[[PostDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndectifierDescriptions]autorelease];
            }
            [cell.textView setFrame:CGRectMake(5, 5, 320 - 10, 150-10)];
            return  cell;
        }
        if (indexPath.row == 2) {
             static NSString * cellIndectifierSegment = @"cellIndectifierSegment";
            ChoiceTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndectifierSegment];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ChoiceTypeCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            [cell.segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
            return  cell;
        }

    }
    if (indexPath.section == 1) {
        if (indexPath.row < _answerNumber) {
            static NSString * cellIdentifierQuestion = @"cellIdentifierQuestion";
            QuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierQuestion];
            if (!cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"QuestionCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            if ([_answersArray count] > 0) {
                cell.ceontentLabel.text = [_answersArray objectAtIndex:_answerNumber - 1];
            }
            qcell = cell;
            return  cell;
            
        }
        
        if (indexPath.row == _answerNumber) {
            static NSString * cellAdd = @"addCell";
            AddAnswer * Cell = [tableView dequeueReusableCellWithIdentifier:cellAdd];
            if (!Cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddAnswer" owner:self options:nil];
                Cell = [array objectAtIndex:0];
            }
            [Cell.addAnswer addTarget:self action:@selector(AddAnswerContent) forControlEvents:UIControlEventTouchUpInside];
            return Cell;
        }
    }
    if (indexPath.section == 2) {
        static NSString *  cellIndentifierPost = @"cellIndentifierPost";
        PostBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifierPost];
        if (!cell) {
            cell = [[PostBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifierPost];
        }
        [cell.postBtn setTitle:@"发布" forState:UIControlStateNormal];
        return  cell;
    }

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50;
        }
        if (indexPath.row == 1) {
            return 150;
        }
        if (indexPath.row == 2) {
            return 40;
        }
    }
    if (indexPath.section == 1) {
        return 40;
    }
    if (indexPath.section == 2) {
        return  45;
    }
}


-(void) AddAnswerContent {
    
    
    [self.tableView reloadData];
}
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            NSLog(@"11");
           
            break;
        case 1:
            NSLog(@"22");
        
            break;
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    }

@end
