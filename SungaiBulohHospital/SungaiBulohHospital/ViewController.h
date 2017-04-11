//
//  ViewController.h
//  SungaiBulohHospital
//
//  Created by Techno Softwares on 30/03/17.
//  Copyright © 2017 madan kumawat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentView.h"

@interface ViewController : UIViewController<UIDocumentInteractionControllerDelegate,UIWebViewDelegate>

{
    DocumentView *subview;
}

@property(nonatomic,strong) UIDocumentInteractionController *_docController;
@end

