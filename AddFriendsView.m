//
//  AddFriendsView.m
//  Looks Guru
//
//  Created by Techno Softwares on 14/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//
#import "AddfriendsCell.h"
#import "AddFriendsView.h"
#import "LGHeaderViewController.h"
#import "LGNotificationsCenterViewController.h"
#import "LGPostLookViewController.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "ContactsList.h"
#import <MessageUI/MessageUI.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ChatViewController.h"
#import "LGHeaderViewController.h"
#import "LGNotificationsCenterViewController.h"
#import "LGPostLookViewController.h"
#import "AddFriendsView.h"


@interface AddFriendsView ()<MFMailComposeViewControllerDelegate,FBSDKSharingDelegate>

@end

@implementation AddFriendsView

- (void)viewDidLoad {
    [super viewDidLoad];
     [[self navigationController] setNavigationBarHidden:YES animated:YES];
    #pragma mark header view
     self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, (IS_IPAD) ? 85.0f : 65)];
    // [self setNeedsStatusBarAppearanceUpdate];
   
    
    viewHeader.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:17.0/255.0 blue:33.0/255.0 alpha:1.0];
    [self.view addSubview:viewHeader];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,(IS_IPAD) ? 25.0f: 20,  [UIScreen mainScreen].bounds.size.width, 40)];
    lblTitle.font = BRANDON_REGULAR_FONT((IS_IPAD)?32: 16);
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:lblTitle];
    
    //    imgProfilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (IS_IPAD) ? 35.0f: 22.5, 35, 35)];
    imgProfilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (IS_IPAD)?30: 25, (IS_IPAD)? 40 : 30,(IS_IPAD)?40: 30)];
    imgProfilePicView.layer.cornerRadius = 17;
    imgProfilePicView.clipsToBounds = YES;
    imgProfilePicView.layer.cornerRadius = imgProfilePicView.frame.size.width/2;
    [imgProfilePicView setClipsToBounds:YES];
    imgProfilePicView.layer.borderWidth = 1.0;
    [imgProfilePicView setContentMode:UIViewContentModeScaleAspectFill];
    imgProfilePicView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(1, (IS_IPAD) ? 32.5f: 20, 45, 40)];
    [btnLeft setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    [btnLeft setTitle:@"" forState:UIControlStateNormal];
    btnLeft.backgroundColor = [UIColor clearColor];
    
    //    [btnLeft addTarget:self.revealViewController action:@selector(btnLeftClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnLeft addTarget:self action:@selector(btnLeftClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btnBack = [[UIButton alloc]initWithFrame:CGRectMake(5,(IS_IPAD)?30: 25, (IS_IPAD)? 40 : 30,(IS_IPAD)?40: 30)];
    [btnBack setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [btnBack setTitle:@"" forState:UIControlStateNormal];
    btnBack.backgroundColor = [UIColor clearColor];
    
    [btnBack addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    btnAddPost = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - ((IS_IPAD)? 45 : 35), (IS_IPAD) ? 32.5f: 25, (IS_IPAD)? 40 : 30, (IS_IPAD)? 40 : 30)];
    [btnAddPost setImage:[UIImage imageNamed:@"add-cap.png"] forState:UIControlStateNormal];
    [btnAddPost setTitle:@"" forState:UIControlStateNormal];
    btnAddPost.backgroundColor = [UIColor clearColor];
    [btnAddPost setClipsToBounds:YES];
    [[btnAddPost layer] setCornerRadius:btnAddPost.frame.size.height / 2];
    [[btnAddPost layer] setBorderWidth:1.0];
    [[btnAddPost layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [btnAddPost addTarget:self action:@selector(btnAddPostClicked) forControlEvents:UIControlEventTouchUpInside];
    
    btnNotification = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - ((IS_IPAD)? 90 : 70), (IS_IPAD) ? 32.5f: 25, (IS_IPAD)? 40 : 30, (IS_IPAD)? 40 : 30)];
    //[btnNotification setBackgroundImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];
    [btnNotification setTitle:@"!" forState:UIControlStateNormal];
    btnNotification.backgroundColor = [UIColor clearColor];
    [btnNotification setClipsToBounds:YES];
    [[btnNotification layer] setCornerRadius:btnNotification.frame.size.height / 2];
    [[btnNotification layer] setBorderWidth:1.0];
    [[btnNotification layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnNotification addTarget:self action:@selector(btnNotificationCenterClicked) forControlEvents:UIControlEventTouchUpInside];
    
    btnUploadLook = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 65, (IS_IPAD) ? 55.0f: 30, 50, 20)];
    
    if (IS_IPAD)
    {
        btnUploadLook.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width -90, 40,80,30);
    }
    
    [btnUploadLook setTitle:@"POST" forState:UIControlStateNormal];
    btnUploadLook.backgroundColor = [UIColor clearColor];
    [btnUploadLook addTarget:self action:@selector(btnUploadLookClicked) forControlEvents:UIControlEventTouchUpInside];
    [[btnUploadLook titleLabel] setFont:[UIFont fontWithName:[[[btnUploadLook titleLabel] font] fontName] size:(IS_IPAD)?19:15]];
    [btnUploadLook setClipsToBounds:YES];
    [[btnUploadLook layer] setCornerRadius:btnUploadLook.frame.size.height / 2];
    [[btnUploadLook layer] setBorderWidth:1.0];
    [[btnUploadLook layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [btnUploadLook setHidden:YES];
    [btnBack setHidden:YES];
    
    btnSearch = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - ((IS_IPAD)? 45 : 35), (IS_IPAD) ? 32.5f: 25, (IS_IPAD)? 40 : 30, (IS_IPAD)? 40 : 30)];
    [btnSearch setImage:[UIImage imageNamed:@"search-icon.png"] forState:UIControlStateNormal];
    [btnSearch setTitle:@"" forState:UIControlStateNormal];
    btnSearch.backgroundColor = [UIColor clearColor];
    [btnSearch setClipsToBounds:YES];
    [[btnSearch layer] setCornerRadius:btnSearch.frame.size.height / 2];
    [[btnSearch layer] setBorderWidth:1.0];
    [[btnSearch layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [btnSearch addTarget:self action:@selector(btnShoFindboxClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setHidden:YES];
    [viewHeader addSubview:btnSearch];
    
    btnReportUser = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - ((IS_IPAD)? 45 : 35), (IS_IPAD) ? 32.5f: 25, (IS_IPAD)? 40 : 30, (IS_IPAD)? 40 : 30)];
    [btnReportUser setImage:[UIImage imageNamed:@"report_flag.png"] forState:UIControlStateNormal];
    [btnReportUser setTitle:@"" forState:UIControlStateNormal];
    btnReportUser.backgroundColor = [UIColor whiteColor];
    [btnReportUser setClipsToBounds:YES];
    [[btnReportUser layer] setCornerRadius:btnReportUser.frame.size.height / 2];
    [[btnReportUser layer] setBorderWidth:1.0];
    [[btnReportUser layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnReportUser addTarget:self action:@selector(btnReportImageClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [viewHeader addSubview:btnReportUser];
    [btnReportUser setHidden:YES];
    
    [imgProfilePicView setHidden:YES];
    
    btnUserLikes = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - ((IS_IPAD)? 90 : 70), (IS_IPAD) ? 32.5f: 25, (IS_IPAD)? 40 : 30, (IS_IPAD)? 40 : 30)];
    [btnUserLikes setImage:[UIImage imageNamed:@"UserLikes.png"] forState:UIControlStateNormal];
    btnUserLikes.backgroundColor = [UIColor clearColor];
    [btnUserLikes setClipsToBounds:YES];
    [[btnUserLikes layer] setCornerRadius:btnUserLikes.frame.size.height / 2];
    [[btnUserLikes layer] setBorderWidth:1.0];
    [[btnUserLikes layer] setBorderColor:[[UIColor colorWithRed:140.0/255.0 green:79.0/255.0 blue:140.0/255.0 alpha:1.0] CGColor]];
    [btnUserLikes addTarget:self action:@selector(btnUserLikesClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnUserLikes setHidden:YES];
    
    btnEditingDone = [[UIButton alloc] initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 65, (IS_IPAD) ? 55.0f: 30, 50, 20)];
    
    if (IS_IPAD)
    {
        btnEditingDone.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width -90, 40,80,30);
    }
    
    [btnEditingDone setTitle:@"DONE" forState:UIControlStateNormal];
    btnEditingDone.backgroundColor = [UIColor clearColor];
    [btnEditingDone addTarget:self action:@selector(btnDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[btnEditingDone titleLabel] setFont:[UIFont fontWithName:[[[btnEditingDone titleLabel] font] fontName] size:(IS_IPAD)?19:15]];
    [btnEditingDone setClipsToBounds:YES];
    [[btnEditingDone layer] setCornerRadius:btnEditingDone.frame.size.height / 2];
    [[btnEditingDone layer] setBorderWidth:1.0];
    [[btnEditingDone layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [btnEditingDone setHidden:YES];
    
    [viewHeader addSubview:btnUploadLook];
    [viewHeader addSubview:btnLeft];
    [viewHeader addSubview:btnAddPost];
    [viewHeader addSubview:imgProfilePicView];
    [viewHeader addSubview:btnNotification];
    [viewHeader addSubview:btnBack];
    [viewHeader addSubview:btnUserLikes];
    [viewHeader addSubview:btnEditingDone];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushnotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushReceived:) name:@"pushnotification" object:nil];
    
    
    btnLeft.hidden = YES;
    btnAddPost.hidden = YES;
    btnUploadLook.hidden = YES;
    btnNotification.hidden = YES;
    btnBack.hidden = NO;
    
    
    lblTitle.text = @"INVITE FRIENDS";
    
    
//    viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ((IS_IPAD) ? 65 : 50), self.view.frame.size.width, (IS_IPAD) ? 65 : 50)];
//    viewFooter.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:17.0/255.0 blue:33.0/255.0 alpha:1.0];
//    
//    CGFloat WSize = ([UIScreen mainScreen].bounds.size.width/6);
//    CGFloat btnX =  (WSize - ((IS_IPAD)? 60 : 40))/2;
//    CGFloat btnY = (IS_IPAD)? 17.5 : 15.0;
//    CGFloat lblX = 0;
//    CGFloat lblY = btnY + ((IS_IPAD)? 30 : 20) ;
//    CGFloat btnWidth =(IS_IPAD)? 60 : 40;
//    CGFloat btnHieght =(IS_IPAD)? 30 : 20;
//    
//    NSArray *lblNameArray = @[@"News Feed",@"Invites",@"Notifications",@"Look"];
//    NSArray *btnImageArray = @[@"newsfeed",@"invite_friends",@"notification_icon",@"look_cap"];
//    btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHieght)];
//    btn_1.backgroundColor = [UIColor clearColor];
//    btn_1.imageEdgeInsets = UIEdgeInsetsMake(0, (IS_IPAD)? 15 : 10, 0, (IS_IPAD)? 15 : 10);
//    [btn_1 setImage:[UIImage imageNamed:btnImageArray[0]] forState:UIControlStateNormal];
//    //    [btn_1 addTarget:self action:@selector(btnNotificationCenterClicked) forControlEvents:UIControlEventTouchUpInside];
//    btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(btnX + WSize, btnY, btnWidth,btnHieght)];
//    btn_2.backgroundColor = [UIColor clearColor];
//    btn_2.imageEdgeInsets = UIEdgeInsetsMake(0, (IS_IPAD)? 15 : 10, 0, (IS_IPAD)? 15 : 10);
//    [btn_2 setImage:[UIImage imageNamed:btnImageArray[1]] forState:UIControlStateNormal];
//    //    [btn_2 addTarget:self action:@selector(btnInviteClicked) forControlEvents:UIControlEventTouchUpInside];
//    btn_3 = [[UIButton alloc] initWithFrame:CGRectMake(btnX + WSize*2, btnY, btnWidth, btnHieght)];
//    btn_3.backgroundColor = [UIColor clearColor];
//    btn_3.imageEdgeInsets = UIEdgeInsetsMake(0, (IS_IPAD)? 15 : 10, 0, (IS_IPAD)? 15 : 10);
//    [btn_3 setImage:[UIImage imageNamed:btnImageArray[2]] forState:UIControlStateNormal];
//    [btn_3 addTarget:self action:@selector(btnmessageClicked) forControlEvents:UIControlEventTouchUpInside];
//    btn_4 = [[UIButton alloc] initWithFrame:CGRectMake(btnX + WSize*3, btnY, btnWidth, btnHieght)];
//    btn_4.backgroundColor = [UIColor clearColor];
//    btn_4.imageEdgeInsets = UIEdgeInsetsMake(0, (IS_IPAD)? 15 : 10, 0, (IS_IPAD)? 15 : 10);
//    [btn_4 setImage:[UIImage imageNamed:btnImageArray[3]] forState:UIControlStateNormal];
//    [btn_4 addTarget:self action:@selector(btnNotificationCenterClicked) forControlEvents:UIControlEventTouchUpInside];
//    btn_5 = [[UIButton alloc] initWithFrame:CGRectMake(btnX + WSize*4, btnY, btnWidth, btnHieght)];
//    btn_5.backgroundColor = [UIColor clearColor];
//    btn_5.imageEdgeInsets = UIEdgeInsetsMake(0, (IS_IPAD)? 15 : 10, 0, (IS_IPAD)? 15 : 10);
//    [btn_5 setImage:[UIImage imageNamed:btnImageArray[3]] forState:UIControlStateNormal];
//    [btn_5 addTarget:self action:@selector(btnAddPostClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    btn_6 = [[UIButton alloc] initWithFrame:CGRectMake(btnX + WSize*5, btnY, btnWidth, btnHieght)];
//    btn_6.backgroundColor = [UIColor clearColor];
//    btn_6.imageEdgeInsets = UIEdgeInsetsMake(0, (IS_IPAD)? 15 : 10, 0, (IS_IPAD)? 15 : 10);
//    [btn_6 setImage:[UIImage imageNamed:btnImageArray[3]] forState:UIControlStateNormal];
//    [btn_6 addTarget:self action:@selector(btnInviteClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:viewFooter];
//    
//    [viewFooter addSubview:btn_1];
//    [viewFooter addSubview:btn_2];
//    [viewFooter addSubview:btn_3];
//    [viewFooter addSubview:btn_4];
//    [viewFooter addSubview:btn_5];
//    [viewFooter addSubview:btn_6];

#pragma mark
    
   itemArray = @[@"Add from Contacts", @"Share on WhatsApp", @"Share by Email",@"Share on Facebook"];
    imgArray = @[@"contacts", @"whatsapp", @"email", @"facebook_icon"];
    
        _tbl_details.scrollEnabled = NO;
        
    [_tbl_details registerNib:[UINib nibWithNibName:@"AddfriendsCell" bundle:nil] forCellReuseIdentifier:@"AddfriendsCell"];
    
    _tbl_details.dataSource = self;
    _tbl_details.delegate = self;
    [_tbl_details reloadData];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnInviteClicked
{
    AddFriendsView *addfriends = [[AddFriendsView alloc] initWithNibName:@"AddFriendsView" bundle:nil];
    [self.navigationController pushViewController:addfriends animated:YES];
}
-(void)btnfriendsClicked
{
    LGPostLookViewController *look = (LGPostLookViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addpost"];
    [self.navigationController pushViewController:look animated:YES];
}
- (void)btnmessageClicked
{
    ChatViewController *ChatView = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [self.navigationController pushViewController:ChatView animated:YES];
}
-(void)btnAddPostClicked
{
    LGPostLookViewController *look = (LGPostLookViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addpost"];
    [self.navigationController pushViewController:look animated:YES];
}
- (void)btnNotificationCenterClicked
{
    LGNotificationsCenterViewController *notification = (LGNotificationsCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationCenter"];
    [self.navigationController pushViewController:notification animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddfriendsCell *cell = (AddfriendsCell *)[_tbl_details dequeueReusableCellWithIdentifier:@"AddfriendsCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddfriendsCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if (indexPath.row == 0) {
         cell.img_arrow.hidden = false;
    }
    else
    {
        cell.img_arrow.hidden = true;
    
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.img_item.image = [UIImage imageNamed:imgArray[indexPath.row]];
    cell.lbl_itemName.text = itemArray[indexPath.row];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(IS_IPAD)
    {
        return 80;
    }
    else
    {
        return 45;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
          ContactsList *Contacts = [[ContactsList alloc] initWithNibName:@"ContactsList" bundle:nil];
        [self.navigationController pushViewController:Contacts animated:YES];
    }
    if (indexPath.row == 1)
    {
            NSString * msg = @"https://itunes.apple.com/mk/app/looks-guru/id1087881143?mt=8";
            
            NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",msg];
            NSURL * whatsappURL = [NSURL URLWithString:urlWhats];
            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
            {
                [[UIApplication sharedApplication] openURL: whatsappURL];
            }
            else
            {
              UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
       
    }

    if (indexPath.row == 2)
    {
        [self sendEmail];
    }
    
    if (indexPath.row == 3)
    {
//       FBLinkShareParams* params = [[FBLinkShareParams alloc]init];
//        params.link = [NSURL URLWithString:@"https://developers.facebook.com/ios"];
//        params.picture = [NSURL URLWithString:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png"];
//        params.name = @"Facebook SDK for iOS";
//        params.caption = @"Build great apps";
        
//        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc]init];
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/mk/app/looks-guru/id1087881143?mt=8"];
//        content.contentTitle = @"Facebook SDK for iOS";
//        content.imageURL = [NSURL URLWithString:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png"];
//        content.contentDescription = @"Build great apps";

        [FBSDKShareDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];

//        dialog.mode = FBSDKShareDialogModeNative;
//        // if you don't set this before canShow call, canShow would always return YES
//        if (!dialog.canShow) {
//            // fallback presentation when there is no FB app
//            dialog.mode = FBSDKShareDialogModeFeedBrowser;
//        }
//        [dialog show];
        
        //        [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//            if(error) {
//                NSLog(@"Error: %@", error.description);
//            } else {
//                NSLog(@"Success!");
//            }
//        }];

       
    }
   
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
   
    NSLog(@"FBSharing share");
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
   
    NSLog(@"FBSharing  failure: %@", [error localizedDescription]);
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
     NSLog(@"FBSharing cancelled");
}



#pragma mark header controller
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushnotification" object:nil];
}


-(void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushReceived:(NSNotification *)notification
{
    NSDictionary *dict = [[notification userInfo] valueForKey:@"push"];
    NSString *strScreenName;
    if([[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Like"] || [[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Comment"] || [[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Ratings"])
    {
        strScreenName = @"Comment";
    }
    else if ([[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Follow"])
    {
        strScreenName = @"FollowView";
    }
    else
    {
        strScreenName = @"HomeViewController";
    }
    
    isComingFromPush = YES;
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:strScreenName];
    
    if(([[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Request"]) && !isOnHomeScreen)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (([[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Like"] || [[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Comment"] || [[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Ratings"]) && !isCommentScreen)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (([[[dict valueForKey:@"aps"] valueForKey:@"key"] isEqualToString:@"Follow"]) && !isUserLooksScreen)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)sendEmail {
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"https://itunes.apple.com/mk/app/looks-guru/id1087881143?mt=8";
    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@"support@test.com"];
   if (!MFMailComposeViewController.canSendMail)  {
        
      UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please setup Email Account First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
//    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
