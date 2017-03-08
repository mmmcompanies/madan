//
//  LGChatViewCell.m
//  Looks Guru
//
//  Created by Techno Softwares on 02/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "LGChatViewCell.h"

@implementation LGChatViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.txt_sender.layer.borderWidth = 1;
    self.txt_sender.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_sender.layer.cornerRadius = 5;
    self.txt_sender.clipsToBounds =true;
    
    self.txt_reciver.layer.borderWidth = 1;
    self.txt_reciver.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_reciver.layer.cornerRadius = 5;
    self.txt_reciver.clipsToBounds =true;

    // Configure the view for the selected state
}

@end
