//
//  LGChatViewCell.h
//  Looks Guru
//
//  Created by Techno Softwares on 02/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGChatViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *txt_sender;
@property (strong, nonatomic) IBOutlet UITextView *txt_reciver;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txt_reciver_width;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txt_sender_width;


@end
