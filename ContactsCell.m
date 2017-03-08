//
//  ContactsCell.m
//  Looks Guru
//
//  Created by Techno Softwares on 14/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
       _img_contact.layer.cornerRadius = 37;
       _img_contact.clipsToBounds = true;
        [_img_contact setContentMode:UIViewContentModeScaleAspectFill];
    }
    else{
        _img_contact.layer.cornerRadius = 21;
        _img_contact.clipsToBounds = true;
       [ _img_contact setContentMode:UIViewContentModeScaleAspectFill];
    }

    
    _btn_sendSMS.layer.cornerRadius = 5;
    _btn_sendSMS.clipsToBounds = true;
    _btn_sendSMS.layer.borderWidth = 1;
    _btn_sendSMS.layer.borderColor = [UIColor whiteColor].CGColor;

    // Configure the view for the selected state
}

@end
