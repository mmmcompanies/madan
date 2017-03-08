//
//  AddfriendController.h
//  Looks Guru
//
//  Created by Techno Softwares on 01/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "LGHeaderViewController.h"
#import "LGHeaderViewController.h"
#import <UIKit/UIKit.h>
#import "CommonFunctions.h"
#import "SBJSON.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "IconDownloader.h"
#import "LGHeaderViewController.h"
#import "PintCollectionViewLayout.h"
#import "PNCollectionCellBackgroundView.h"
#import "LGCommentsViewController.h"
#import "LGFollowerFollowingListViewController.h"
#import "LGPostData.h"
#import "MosaicLayoutDelegate.h"
#import "AFTableViewCell.h"
#import "MosaicLayout.h"
#import "MosaicData.h"
#import "CustomDataSource.h"

#define kColumnsiPadLandscape 5
#define kColumnsiPadPortrait 4
#define kColumnsiPhoneLandscape 3
#define kColumnsiPhonePortrait 2
#define kDoubleColumnProbability 40

@interface AddfriendController : LGHeaderViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *Fullnamearr;
    NSMutableArray *ImageArr;
    NSMutableArray *contactsArray;
    NSMutableArray *NumberArry;
    NSMutableArray *searchresult;
    
    
    NSMutableArray *arrPosts;
    NSInteger count;
    NSInteger totalNumberOfPages;
    BOOL isPreviousRequestComplted;
    BOOL stopDownload;
    MBProgressHUD *HUD;
    LGPostData *selectedPost;
    int downloadCOunter;
    NSString *totalPostCount;
   

}
@property (strong, nonatomic) IBOutlet UITableView *tbl_listUser;
 @property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end
