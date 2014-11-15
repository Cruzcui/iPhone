#import <UIKit/UIKit.h>

#import "HHDomainBase.h"
#import "HKDLCategoryListViewController.h"

@interface KeshiListController : UITableViewController<HHDomainBaseDelegate>
@property (nonatomic,retain) NSMutableArray * arrayCategoryList;

@property (nonatomic,assign) id<HKDLCategoryListViewControllerDelegate> delegate;


@end
