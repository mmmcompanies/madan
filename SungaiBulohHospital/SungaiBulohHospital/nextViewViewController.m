//
//  nextViewViewController.m
//  SungaiBulohHospital
//
//  Created by Techno Softwares on 10/04/17.
//  Copyright © 2017 madan kumawat. All rights reserved.
//

#import "nextViewViewController.h"

@interface nextViewViewController ()

@end

@implementation nextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.navigationController.navigationBar setHidden:YES];
    
    _view_ms.layer.cornerRadius = 10;
    _view_ms.clipsToBounds = true;
    _view_ms.layer.borderWidth = 1;
    _view_ms.layer.borderColor = [UIColor colorWithRed:91.0/255.0 green:101.0/255.0 blue:191.0/255.0 alpha:1.0].CGColor;
    
    _view_other.layer.cornerRadius = 10;
    _view_other.clipsToBounds = true;
    _view_other.layer.borderWidth = 1;
    _view_other.layer.borderColor = [UIColor colorWithRed:91.0/255.0 green:101.0/255.0 blue:191.0/255.0 alpha:1.0].CGColor;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_top_clicked:(id)sender {
    [self performSegueWithIdentifier:@"mercuryspill" sender:self];
    
}
- (IBAction)btn_bottom_clicked:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
