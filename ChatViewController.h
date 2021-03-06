//
//  ChatViewController.h
//  Looks Guru
//
//  Created by Techno Softwares on 22/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

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
#import "Chatview.h"

@interface ChatViewController : LGHeaderViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    NSArray *itemArray;
    NSArray *imgArray;
    Chatview *Subview;
    NSIndexPath *set_indexpath;
    CGRect swipedCellframe;
    CGRect chatViewframe;
    CGPoint location;
    IBOutlet UIButton *btn_addfriend;
    NSString *strFriendID;
    
    UIActivityIndicatorView *loding;
    
    NSMutableArray *searchresult;
    
    NSArray *arrChat;
    float  txtViewWidth;
    NSMutableArray *arrtxtViewWidth;
//    NSMutableArray *arrmessage;
//    NSMutableArray *arrsenderID;
//     NSMutableArray *conversionID;
    
    NSMutableArray *arrPosts;
    NSInteger count;
    NSInteger totalNumberOfPages;
    BOOL isPreviousRequestComplted;
    BOOL stopDownload;
    MBProgressHUD *HUD;
    LGPostData *selectedPost;
    LGPostData *ChatData;
    int downloadCOunter;
    NSString *totalPostCount;

   
}
@property (strong, nonatomic) IBOutlet UITableView *tbl_chatlist;
 @property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end
