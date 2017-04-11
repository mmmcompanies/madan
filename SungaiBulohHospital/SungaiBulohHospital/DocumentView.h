//
//  DocumentView.h
//  SungaiBulohHospital
//
//  Created by Techno Softwares on 10/04/17.
//  Copyright © 2017 madan kumawat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentView : UIView
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UIButton *btn_share;
@property (strong, nonatomic) IBOutlet UIButton *btn_done;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
+ (id) newDocumentView;
@end
