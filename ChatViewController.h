//
//  ChatViewController.h
//  Looks Guru
//
//  Created by Techno Softwares on 22/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "LGHeaderViewController.h"

#import "Chatview.h"

@interface ChatViewController : LGHeaderViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSArray *itemArray;
    NSArray *imgArray;
    Chatview *Subview;
    NSIndexPath *set_indexpath;
}
@property (strong, nonatomic) IBOutlet UITableView *tbl_chatlist;

@end
