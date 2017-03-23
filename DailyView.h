//
//  DailyView.h
//  MPlayer
//
//  Created by Techno Softwares on 22/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyView : UIView
@property (assign, nonatomic) bool isShown;
@property (strong, nonatomic) IBOutlet UIButton *btn_daily;
@property (strong, nonatomic) IBOutlet UIButton *btn_weekly;
@property (strong, nonatomic) IBOutlet UIButton *btn_monthly;
@property (strong, nonatomic) IBOutlet UIButton *btn_yearly;
@property (strong, nonatomic) IBOutlet UIButton *btn_save;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view_botmConstraints;
@property (strong, nonatomic) IBOutlet UITextField *txt_Daily;
@property (strong, nonatomic) IBOutlet UITextField *txt_Weekly;
@property (strong, nonatomic) IBOutlet UITextField *txt_Monthly;
@property (strong, nonatomic) IBOutlet UITextField *txt_Yearly;

+ (id) newQueueListView;
@end
