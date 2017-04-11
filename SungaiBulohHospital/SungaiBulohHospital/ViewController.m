//
//  ViewController.m
//  SungaiBulohHospital
//
//  Created by Techno Softwares on 30/03/17.
//  Copyright © 2017 madan kumawat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnleft_clicked:(id)sender {
//    [self showDocumentIntercationController];
}
- (IBAction)btn_menu_clicked:(id)sender {
    
}
- (IBAction)btn_next_clicked:(id)sender {
    
    [self performSegueWithIdentifier:@"next" sender:self];
}

- (void)showView
{
    subview = [DocumentView newDocumentView];
  
        subview.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);

    [self.view addSubview: subview];
   [subview.btn_done addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [subview.btn_share addTarget:self action:@selector(showDocumentIntercationController) forControlEvents:UIControlEventTouchUpInside];
    
    [self docClicked];
    
    CGRect rect = subview.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height;
    subview.frame = rect;
    [UIView beginAnimations:@"ShowView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    rect.origin.y = 0;
    subview.frame = rect;
    [UIView commitAnimations];
}

- (void)hideView{
    CGRect rect = subview.frame;
    [UIView beginAnimations:@"HideView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    rect.origin.y = [UIScreen mainScreen].bounds.size.height;
    subview.frame = rect;
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [subview removeFromSuperview];
}

-(void)showDocumentIntercationController
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"Disclaimer" withExtension:@"doc"];
    
    self._docController = [UIDocumentInteractionController interactionControllerWithURL:path];
    self._docController.delegate=self;
    [self._docController presentPreviewAnimated:YES];
//    [self._docController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
}


- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller
{
    NSLog(@"UIDocumentInteractionController dismissed");
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    
    return self;
}
- (void)docClicked {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Disclaimer" ofType:@"doc"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    subview.webview.delegate = self;
    subview.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [subview.webview setScalesPageToFit:YES];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:url];
    [subview.webview loadRequest:myRequest];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"didFailLoadWithError:%@", error); }

@end
