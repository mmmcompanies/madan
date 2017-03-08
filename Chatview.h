//
//  Chatview.h
//  Looks Guru
//
//  Created by Techno Softwares on 22/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chatview : UIView

   @property (strong, nonatomic) UIView *viewHeader;
   @property (strong, nonatomic) UILabel *lblTitle;
   @property (strong, nonatomic) UIButton *btnLeft;
   @property (strong, nonatomic) UIButton * btnbackRight;
   @property (strong, nonatomic) UIImageView *imgProfilePicView;

 @property (strong, nonatomic)IBOutlet UITextField * cmntText;
 @property (strong, nonatomic)IBOutlet UIButton * cmtBtn;
 @property (strong, nonatomic)IBOutlet UIView * viewCmmentBox;
@property (strong, nonatomic) IBOutlet UITableView *tbl_chatview;
@property (strong, nonatomic) IBOutlet UIView * txtViewComnt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbl_constraints_bottom;

+ (id) newChatview;
@end
