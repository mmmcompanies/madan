//
//  ContactsList.m
//  Looks Guru
//
//  Created by Techno Softwares on 14/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//
#import "ContactsCell.h"
#import "ContactsList.h"
#import "LGHeaderViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LGNotificationsCenterViewController.h"
#import "LGPostLookViewController.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import "LGRestInteraction.h"
@interface ContactsList ()<MFMessageComposeViewControllerDelegate>
{
    LGRestInteraction *obj;
}
@end

@implementation ContactsList

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
     [[self navigationController] setNavigationBarHidden:YES animated:YES];
#pragma mark header view
    [self contactsFromAddressBook];
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
    
    lblTitle.text = @"CONTACTS";
    
#pragma mark
    

    Fullnamearr = [[NSMutableArray alloc]init];
    ImageArr= [[NSMutableArray alloc]init];
    contactsArray= [[NSMutableArray alloc]init];
    NumberArry = [[NSMutableArray alloc]init];
    obj = [LGRestInteraction restInteractionManager];
    
//    obj.SendSMSArray = [[NSMutableArray alloc]init];
    
    [_tbl_contacts registerNib:[UINib nibWithNibName:@"ContactsCell" bundle:nil] forCellReuseIdentifier:@"ContactsCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Fullnamearr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsCell *cell = (ContactsCell *)[_tbl_contacts dequeueReusableCellWithIdentifier:@"ContactsCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ContactsCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IS_IPAD) {
        cell.img_contact.layer.cornerRadius = 37;
        cell.img_contact.clipsToBounds = true;
    }
    else{
        cell.img_contact.layer.cornerRadius = 21;
        cell.img_contact.clipsToBounds = true;
    }
    
    
    cell.lbl_contactName.text = Fullnamearr[indexPath.row];
    cell.img_contact.image = ImageArr[indexPath.row];
    [cell.btn_sendSMS addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(IS_IPAD)
    {
        return 100;
    }
    else
    {
        return 58;
    }
}

#pragma mark header controller
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushnotification" object:nil];
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

#pragma mark
#pragma mark Address book 
-(void)contactsFromAddressBook{
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                UIImage *profileImage;
                NSMutableArray *contactNumbersArray;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    
                    [Fullnamearr addObject:fullName];
                    
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }else{
                        profileImage = [UIImage imageNamed:@"profile-icon.png"];
                    }
                    
                     [ImageArr addObject:profileImage];
                    
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [NumberArry addObject:phone];
                        }
                    }
                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",profileImage,@"userImage",phone,@"PhoneNumbers", nil];
                    [contactsArray addObject:personDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int i = 0; i< obj.SendSMSArray.count; i++)
                    {
                       int temp =  [NumberArry indexOfObject:obj.SendSMSArray[i]];
                        
                        [Fullnamearr removeObjectAtIndex:temp];
                        [ImageArr removeObjectAtIndex:temp];
                        [NumberArry removeObjectAtIndex:temp];
                    }
                    _tbl_contacts.dataSource = self;
                    _tbl_contacts.delegate = self;
                    [_tbl_contacts reloadData];
                    
                    //                    [self.tableViewRef reloadData];
                });
            }
        }
    }];
    
    
    
}

- (IBAction)sendSMS:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tbl_contacts];
    NSIndexPath *indexPath = [self.tbl_contacts indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"%ld",(long)indexPath.row);
    indexpath = indexPath;
    
    NSArray *recipents = @[NumberArry[indexPath.row]];
    NSString *message = [NSString stringWithFormat:@"https://itunes.apple.com/mk/app/looks-guru/id1087881143?mt=8"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"cancelled by user");
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
              NSLog(@"send invatation !!");
            
            [obj.SendSMSArray addObject:NumberArry[indexpath.row]];
            [Fullnamearr removeObjectAtIndex:indexpath.row];
            [ImageArr removeObjectAtIndex:indexpath.row];
            [NumberArry removeObjectAtIndex:indexpath.row];
            
            [_tbl_contacts reloadData];
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
