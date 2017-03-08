
//  ChatViewController.m
//  Looks Guru
//
//  Created by Techno Softwares on 22/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//
#import "LGChatViewCell.h"
#import "AddfriendController.h"
#import "ChatViewController.h"
#import "AddfriendsCell.h"
#import "STBubbleTableViewCell.h"
@interface ChatViewController ()<STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    btnLeft.hidden = YES;
    btnAddPost.hidden = YES;
    btnUploadLook.hidden = YES;
    btnNotification.hidden = YES;
    btn_sbarUserSearch.hidden = YES;
    viewFooter.hidden = YES;
    btnBack.hidden = NO;
    lblTitle.text = @"CONTACTS";
    
    [sbarUserSearch setShowsCancelButton:YES animated:YES];
    sbarUserSearch.delegate = self;
    
    ChatData = [[LGPostData alloc] init];
    
#pragma mark
    
    Subview = [Chatview newChatview];
    Subview.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    chatViewframe =  Subview.frame;
    Subview.hidden = true;
    [self.view addSubview:Subview];
    
    Subview.viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (IS_IPAD) ? 85.0f : 65)];
    Subview.viewHeader.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:17.0/255.0 blue:33.0/255.0 alpha:1.0];
    [Subview addSubview:Subview.viewHeader];
    
    Subview.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,(IS_IPAD) ? 25.0f: 20,  [UIScreen mainScreen].bounds.size.width, 40)];
    Subview.lblTitle.font = BRANDON_REGULAR_FONT((IS_IPAD)?32: 16);
    Subview.lblTitle.backgroundColor = [UIColor clearColor];
    Subview.lblTitle.textColor = [UIColor whiteColor];
    Subview.lblTitle.textAlignment = NSTextAlignmentCenter;
    [Subview.viewHeader addSubview:Subview.lblTitle];
    
    Subview.imgProfilePicView = [[UIImageView alloc] initWithFrame:CGRectMake((IS_IPAD)?20: 10, (IS_IPAD)?30: 25, (IS_IPAD)? 40 : 30,(IS_IPAD)?40: 30)];
    Subview.imgProfilePicView.layer.cornerRadius = Subview.imgProfilePicView.frame.size.width/2;
    [Subview.imgProfilePicView setClipsToBounds:YES];
    Subview.imgProfilePicView.layer.borderWidth = 1.0;
    [Subview.imgProfilePicView setContentMode:UIViewContentModeScaleAspectFill];
    Subview.imgProfilePicView.layer.borderColor = [UIColor whiteColor].CGColor;
    [Subview.viewHeader addSubview:Subview.imgProfilePicView];
    
//    Subview.btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(1, (IS_IPAD) ? 32.5f: 20, 45, 40)];
//    [Subview.btnLeft setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
//    [Subview.btnLeft setTitle:@"" forState:UIControlStateNormal];
//    Subview.btnLeft.backgroundColor = [UIColor clearColor];
////    [Subview.btnLeft addTarget:self action:@selector(btnLeftClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [Subview.viewHeader addSubview:Subview.btnLeft];
    
    loding = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loding.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width)/2 - 30 , [UIScreen mainScreen].bounds.size.height - ([UIScreen mainScreen].bounds.size.height)/2 - 30, 60, 60);
    
    loding.transform = CGAffineTransformMakeScale(2.0, 2.0);
     [loding setHidden:YES];
    [Subview addSubview:loding];
    
    Subview.btnbackRight = [[UIButton alloc] initWithFrame:CGRectMake( (IS_IPAD) ? [UIScreen mainScreen].bounds.size.width -60:[UIScreen mainScreen].bounds.size.width - 40, (IS_IPAD)?30: 25, (IS_IPAD)? 40 : 30,(IS_IPAD)?40: 30)];
    
    [Subview.btnbackRight setTitle:@"" forState:UIControlStateNormal];
    Subview.btnbackRight.backgroundColor = [UIColor clearColor];
    [Subview.btnbackRight addTarget:self action:@selector(btnbackClicked) forControlEvents:UIControlEventTouchUpInside];
    [Subview.btnbackRight setImage:[UIImage imageNamed:@"btn_backRight.png"] forState:UIControlStateNormal];
    [Subview.viewHeader addSubview:Subview.btnbackRight];
    
    [Subview.cmtBtn addTarget:self action:@selector(send_conversation) forControlEvents:UIControlEventTouchUpInside];
    Subview.txtViewComnt.layer.borderColor = [UIColor colorWithRed:248.0/255.0 green:206.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor;
    Subview.txtViewComnt.layer.borderWidth = 1.0f;
    Subview.txtViewComnt.layer.cornerRadius = 8.0;
    
    Subview.cmntText.delegate = self;
    Subview.cmtBtn.userInteractionEnabled = false;
    Subview.cmtBtn.alpha = 0.4;
    
    
    [Subview.tbl_chatview registerNib:[UINib nibWithNibName:@"LGChatViewCell" bundle:nil] forCellReuseIdentifier:@"LGChatViewCell"];
//    _tbl_chatlist.scrollEnabled = NO;
    
    [_tbl_chatlist registerNib:[UINib nibWithNibName:@"AddfriendsCell" bundle:nil] forCellReuseIdentifier:@"AddfriendsCell"];
    
    
    btn_addfriend.layer.borderColor = [UIColor whiteColor].CGColor;
    btn_addfriend.layer.borderWidth = 1;
    btn_addfriend.layer.cornerRadius = 5;
    btn_addfriend.clipsToBounds = true;
    
    UISwipeGestureRecognizer *viewRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(RightSwipe:)];
    [viewRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [Subview addGestureRecognizer:viewRecognizer];
    viewRecognizer.delegate = self;
    if ([CommonFunctions isConnectedToInternet])
    {
        [GMDCircleLoader setOnView:self.view withTitle:@"" animated:YES];
        
         [self getPosts];
    }
    else
    {
        [CommonFunctions alertForNoInternetConnection];
    }
   
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    isCommentScreen = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Keyboard Notification

- (void)keyboardFrameChanged:(NSNotification*)aNotification
{
    NSLog(@"Keyboard Frame changed! Text :   %@", aNotification);
    
    NSDictionary* info = [aNotification userInfo];
    CGPoint kbStartPosition = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin;
    CGPoint kbEndPosition = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    NSLog(@"Keyboard Start Y :  %f", kbStartPosition.y);
    NSLog(@"Keyboard End Y :  %f", kbEndPosition.y);
    NSLog(@"Keyboard End Y :  %f", kbStartPosition.y - kbEndPosition.y);
    
    
    Subview.viewCmmentBox.frame = CGRectMake(Subview.viewCmmentBox.frame.origin.x, Subview.viewCmmentBox.frame.origin.y - (kbStartPosition.y - kbEndPosition.y), Subview.viewCmmentBox.frame.size.width, Subview.viewCmmentBox.frame.size.height);
    
//    Subview.tbl_chatview.frame = CGRectMake(Subview.tbl_chatview.frame.origin.x, Subview.tbl_chatview.frame.origin.y, Subview.tbl_chatview.frame.size.width, Subview.tbl_chatview.frame.size.height - (kbStartPosition.y - kbEndPosition.y));
//    Subview.tbl_constraints_bottom.constant = (kbStartPosition.y - kbEndPosition.y);
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_addfriend_clicked:(id)sender {
    
    AddfriendController *ChatView = [[AddfriendController alloc] initWithNibName:@"AddfriendController" bundle:nil];
    [self.navigationController pushViewController:ChatView animated:YES];

}

- (void)leftSwipe:(UISwipeGestureRecognizer *)panGestureRecognizer
{
     [self.view endEditing:YES];
     Subview.hidden = false;
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
//    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
     CGPoint tbllocation = [panGestureRecognizer locationInView:_tbl_chatlist];
    
//     Subview.hidden = false;
     [[Subview superview] bringSubviewToFront:Subview];
    NSIndexPath *swipedIndexPath = [_tbl_chatlist indexPathForRowAtPoint:tbllocation];
    set_indexpath = swipedIndexPath;
    
    LGPostData *data = [searchresult objectAtIndex:swipedIndexPath.row];
    strFriendID = data.strFriendID;
    Subview.lblTitle.text = data.strDisplayName;
    if (!data.imgPostImage)
    {
        [self startIconDownload:data forIndexPath:swipedIndexPath];
    }
    else
    {
        [Subview.imgProfilePicView setImage:data.imgPostImage];
    }
    if ([CommonFunctions isConnectedToInternet])
    {
        [loding startAnimating];
        [loding setHidden:NO];
        
        isPreviousRequestComplted = NO;
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHAT_LIST]];
        
        [request setPostValue:loginData.strUserId forKey:@"user_id"];
        [request setPostValue:data.strFriendID forKey:@"friend_id"];
        
        
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestForconversationFail:)];
        [request setDidFinishSelector:@selector(requestForconversationSuccess:)];
        
        [request setTimeOutSeconds:99999999999];
        [request startAsynchronous];

    }
    else
    {
        [CommonFunctions alertForNoInternetConnection];
    }
    
    
    AddfriendsCell *swipedCell  = [_tbl_chatlist cellForRowAtIndexPath:swipedIndexPath];
    Subview.frame = chatViewframe;
    [UIView animateWithDuration:1.1 animations:^{
        swipedCell.frame = CGRectOffset(swipedCell.frame, [UIScreen mainScreen].bounds.size.width, 0.0);
        Subview.frame = CGRectOffset(Subview.frame, [UIScreen mainScreen].bounds.size.width, 0.0);

    }];
    
//    switch (panGestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:
//             NSLog(@"%f    StateBegan%f      %f       %f",velocity.x ,velocity.y,touchLocation.x,location.x);
//            location = touchLocation;
//            break;
//            
//        case UIGestureRecognizerStateChanged:{
//             NSLog(@"%f    StateChanged%f      %f       %f",velocity.x ,velocity.y,touchLocation.x,location.x);
//            
//            swipedCell.frame = CGRectMake(touchLocation.x - location.x, swipedCell.frame.origin.y, swipedCell.frame.size.width, swipedCell.frame.size.height);
//            Subview.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width + (touchLocation.x - location.x), Subview.frame.origin.y, Subview.frame.size.width, Subview.frame.size.height);
//            
//            break;
//        }
//            
//        case UIGestureRecognizerStateEnded:{
//             NSLog(@"%f    StateEnded%f      %f       %f",velocity.x ,velocity.y,touchLocation.x,location.x);
//            
//            if (touchLocation.x - location.x <= [UIScreen mainScreen].bounds.size.width/2 ) {
//                
//                [UIView animateWithDuration:1.1 animations:^{
//                    swipedCell.frame = CGRectOffset(swipedCellframe, -[UIScreen mainScreen].bounds.size.width, 0.0);
//                    Subview.frame = CGRectOffset(chatViewframe, -[UIScreen mainScreen].bounds.size.width, 0.0);
//                }];
//            }
//            else
//            {
//                [UIView animateWithDuration:1.1 animations:^{
//                    swipedCell.frame = CGRectOffset(swipedCellframe, [UIScreen mainScreen].bounds.size.width, 0.0);
//                    Subview.frame = CGRectOffset(chatViewframe, [UIScreen mainScreen].bounds.size.width, 0.0);
//                }];
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }

    
}
-(void)backButtonClicked:(id)sender
{
    Subview.hidden = true;
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnbackClicked{
    
    [self.view endEditing:YES];
    AddfriendsCell *swipedCell  = [_tbl_chatlist cellForRowAtIndexPath:set_indexpath];
    
    [UIView animateWithDuration:0.5 animations:^{
        swipedCell.frame = CGRectOffset(swipedCell.frame, -[UIScreen mainScreen].bounds.size.width, 0.0);
        Subview.frame = CGRectOffset(Subview.frame, -[UIScreen mainScreen].bounds.size.width, 0.0);
//          Subview.hidden = true;
    }];
    
  
}
- (void)RightSwipe:(UIPanGestureRecognizer *)gestureRecognizer
{
     [self.view endEditing:YES];
    //do you left swipe stuff here.
    AddfriendsCell *swipedCell  = [_tbl_chatlist cellForRowAtIndexPath:set_indexpath];
    
    [UIView animateWithDuration:1.5 animations:^{
        swipedCell.frame = CGRectOffset(swipedCell.frame, -[UIScreen mainScreen].bounds.size.width, 0.0);
        Subview.frame = CGRectOffset(Subview.frame, -[UIScreen mainScreen].bounds.size.width, 0.0);
//         Subview.hidden = true;
    }];
    
   
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbl_chatlist ) {
        
        return  searchresult.count;
    }
    else
    {
         return  ChatData.arrmessage.count;
    
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//
    
    if (tableView == _tbl_chatlist ) {
        AddfriendsCell *cell = (AddfriendsCell *)[_tbl_chatlist dequeueReusableCellWithIdentifier:@"AddfriendsCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddfriendsCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        swipedCellframe = cell.frame;
        
        cell.img_arrow.hidden = true;
        cell.backgroundColor = [UIColor clearColor];
        
        LGPostData *data = [searchresult objectAtIndex:indexPath.row];
        
        if (data.strSmallThumbURL.length > 0)
        {
            if (!data.imgPostImage)
            {
                [self startIconDownload:data forIndexPath:indexPath];
            }
            else
            {
                [cell.img_item setImage:data.imgPostImage];
                
            }
        }
        
        cell.lbl_itemName.text = data.strDisplayName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(leftSwipe:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:recognizer];
        recognizer.delegate = self;
        
        return cell;
    }
    else
    {
//        LGChatViewCell *cell = (LGChatViewCell *)[Subview.tbl_chatview dequeueReusableCellWithIdentifier:@"LGChatViewCell"];
//        if (cell == nil) {
//            // Load the top-level objects from the custom cell XIB.
//            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LGChatViewCell" owner:self options:nil];
//            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
//            cell = [topLevelObjects objectAtIndex:0];
//        }
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        static NSString *CellIdentifier = @"Bubble Cell";
        
        STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[STBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            cell.backgroundColor = self.tableView.backgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.dataSource = self;
            cell.delegate = self;
        }
        
        if ([loginData.strUserId isEqualToString:ChatData.arrsenderID[indexPath.row]]) {
            
//            cell.txt_sender.hidden = false;
//            cell.txt_reciver.hidden = true;
//            cell.txt_sender.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = ChatData.arrmessage[indexPath.row];
            cell.authorType = STBubbleTableViewCellAuthorTypeSelf;
            cell.bubbleColor = STBubbleTableViewCellBubbleColorPurple;
            
//            cell.txt_sender_width.constant = [arrtxtViewWidth[indexPath.row] floatValue];
            
        }
        else
        {
//            cell.txt_reciver.hidden = false;
//            cell.txt_sender.hidden = true;
//             cell.txt_reciver.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = ChatData.arrmessage[indexPath.row];
            cell.authorType = STBubbleTableViewCellAuthorTypeOther;
            cell.bubbleColor = STBubbleTableViewCellBubbleColorGray;
//            cell.txt_reciver_width.constant = [arrtxtViewWidth[indexPath.row] floatValue];
            
//            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//            gesture.minimumPressDuration = 0.3;
//            gesture.allowableMovement = 600;
//            [cell.textLabel addGestureRecognizer:gesture];
            
        }
        
        

//        recognizer.delegate = self;
        
        return cell;

    }
}

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        return 100.0f;
    }
    
    return 50.0f;
}

#pragma mark - STBubbleTableViewCellDelegate methods

- (void)tappedImageOfCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"%ld", (long)indexPath.row);
    
     [self save_conversation:ChatData.conversionID[indexPath.row]];
    
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    CGPoint location = [gesture locationInView:self.view];
    CGPoint tbllocation = [gesture locationInView:Subview.tbl_chatview];
    NSIndexPath *IndexPath = [Subview.tbl_chatview indexPathForRowAtPoint:tbllocation];
    
    LGChatViewCell *Cell  = [Subview.tbl_chatview cellForRowAtIndexPath:IndexPath];
    
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        Cell.txt_sender.layer.borderColor = [UIColor redColor].CGColor;
        Cell.txt_reciver.layer.borderColor = [UIColor redColor].CGColor;
        
        [self save_conversation:[[arrChat objectAtIndex:IndexPath.row] valueForKey:@"conversation_id"]];
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled ||
             gesture.state == UIGestureRecognizerStateFailed ||
             gesture.state == UIGestureRecognizerStateEnded)
    {
        
    }
    
}

- (void)someMethod:(CGPoint)location
{
    // move whatever you wanted to do in the gesture handler here.
//    [self text:<#(NSString *)#> sizeWithFont:<#(UIFont *)#> constrainedToSize:<#(CGSize)#>];
    NSLog(@"%s", __FUNCTION__);
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbl_chatlist ) {
        if(IS_IPAD)
        {
            return 80;
        }
        else
        {
            return 45;
        }
    }
    else
    {
        UITextView *textview = [[UITextView alloc]init];
        
        textview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        textview.hidden = true;
//        [textview setAttributedText:[[arrChat objectAtIndex:indexPath.row] valueForKey:@"message"]];
        textview.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        textview.text = ChatData.arrmessage[indexPath.row];
        textview.scrollEnabled =  false;
        [textview sizeToFit];
        [textview layoutIfNeeded];
        float  width = textview.contentSize.width + 20;
        
       
        if (width <= 40) {
            
            txtViewWidth = width;
            [arrtxtViewWidth addObject:[NSString stringWithFormat:@"%f",txtViewWidth]];
        }
        else if (width <= [UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width * 30 / 100)) {
            
            txtViewWidth = width;
            [arrtxtViewWidth addObject:[NSString stringWithFormat:@"%f",txtViewWidth]];
        }
        else
        {
            txtViewWidth = [UIScreen mainScreen].bounds.size.width - ([UIScreen mainScreen].bounds.size.width * 30 / 100);
            [arrtxtViewWidth addObject:[NSString stringWithFormat:@"%f",txtViewWidth]];
        }
       
        CGSize size = [textview sizeThatFits:CGSizeMake(txtViewWidth - 20 , 9999)];
        
        if (size.height <= 34) {
            
             return 40;
        }
        else
        {
            
        return size.height + 20;
            
        }
    }
}

-(CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        return frame.size;
    }
    else
    {
        return [text sizeWithFont:font constrainedToSize:size];
    }
}

//- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated{
//
//
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self.view endEditing:YES];
    
    if (tableView == _tbl_chatlist ) {
    
    LGPostData *data = [searchresult objectAtIndex:indexPath.row];
    
    
        Subview.hidden = false;
        [[Subview superview] bringSubviewToFront:Subview];

    strFriendID = data.strFriendID;
    Subview.lblTitle.text = data.strDisplayName;
    if (!data.imgPostImage)
    {
        [self startIconDownload:data forIndexPath:indexPath];
    }
    else
    {
        [Subview.imgProfilePicView setImage:data.imgPostImage];
    }
    
    if ([CommonFunctions isConnectedToInternet])
    {
        [loding startAnimating];
        [loding setHidden:NO];
       
        isPreviousRequestComplted = NO;
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHAT_LIST]];
        
        [request setPostValue:loginData.strUserId forKey:@"user_id"];
        [request setPostValue:data.strFriendID forKey:@"friend_id"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requestForconversationFail:)];
        [request setDidFinishSelector:@selector(requestForconversationSuccess:)];
        
        [request setTimeOutSeconds:99999999999];
        [request startAsynchronous];
    }
    else
    {
        [CommonFunctions alertForNoInternetConnection];
    }
        NSLog(@"%f,     %f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        
    Subview.tbl_chatview.hidden = true;
    set_indexpath = indexPath;
    AddfriendsCell *swipedCell  = [_tbl_chatlist cellForRowAtIndexPath:indexPath];
        Subview.frame =chatViewframe;
    [UIView animateWithDuration:.5 animations:^{
        swipedCell.frame = CGRectOffset(swipedCell.frame, [UIScreen mainScreen].bounds.size.width, 0.0);
        Subview.frame = CGRectOffset(Subview.frame, [UIScreen mainScreen].bounds.size.width, 0.0);
        
    }];
        
    }
    
    else{
        
        
    }
   
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[Subview superview] bringSubviewToFront:Subview];
//        //do you left swipe stuff here.
//        [UIView animateWithDuration:1.1 animations:^{
//            Subview.frame = CGRectOffset(Subview.frame, 320.0, 0.0);
//    
//        }];
//    
//    return UITableViewCellEditingStyleNone;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Open "Transaction"
//    [tableView beginUpdates];
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // your code goes here
//        //add code here for when you hit delete
////        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    
//    // Close "Transaction"
//    [tableView endUpdates];
//    
//    
//    [[Subview superview] bringSubviewToFront:Subview];
//    //do you left swipe stuff here.
//    [UIView animateWithDuration:1.1 animations:^{
//        Subview.frame = CGRectOffset(Subview.frame, 320.0, 0.0);
//        
//    }];
//}
//http://api.looksguru.com/fetch_friends_list.php?user_id=108


#pragma mark
-(void)getPosts
{
    isPreviousRequestComplted = NO;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHAT_FRIENDS_LIST]];
    
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    //    //api.looksguru.com/fetch_user_list.php?user_id=110
    
    
    //    NSString *strValue = [@(count) stringValue];
    //    [request setPostValue:strValue forKey:@"page"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForGetPostsFail:)];
    [request setDidFinishSelector:@selector(requestFoGetPostsSuccess:)];
    
    [request setTimeOutSeconds:99999999999];
    [request startAsynchronous];
}
-(void)requestForGetPostsFail:(ASIFormDataRequest *)request
{
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       isPreviousRequestComplted = YES;
                       [CommonFunctions alertForNoInternetConnection];
                       [GMDCircleLoader hideFromView:self.view animated:YES];
                   });
}
-(void)requestFoGetPostsSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser = [[SBJSON alloc]init];
    NSMutableArray *results = [parser objectWithString:responseString error:nil];
    
    results = [parser objectWithString:responseString error:nil];
    arrPosts = [[NSMutableArray alloc] init];
    
    if(![results isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                           //                           isPreviousRequestComplted = YES;
                           //                           [HUD hide];
                       });
    }
    else
    {
        if(results.count > 0)
        {
            for(int i = 0; i < [results count]; i++)
            {
                LGPostData *post = [[LGPostData alloc] init];
                post.strUserId = loginData.strUserId;
                post.strPostImage = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"image"]];
                post.strSmallThumbURL = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"image_200"]];
                post.strMediumThumbURL = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"image_400"]];
                post.strPostId = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"post_id"]];
                post.strUserName = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"user_name"]];
                post.strUserImg = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"user_image"]];
                
                post.strFriendID = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"id"]];
                
                post.strGender = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"gender"]];
                post.strDisplayName = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"display_name"]];
                
                NSString *straboutPic = [[[results objectAtIndex:i] objectForKey:@"style_mantra"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"[%@]", straboutPic);
                straboutPic = [straboutPic stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                post.strStylemantra =  [NSString stringWithFormat:@"%@", straboutPic];
                
                NSString *text = post.strDisplayName;
                if (text.length>0)
                {
                    post.strDisplayName = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
                }
                
                NSLog(@"%@ uppercased is %@", text, post.strDisplayName);
                
                post.strLocation = [[results objectAtIndex:i] objectForKey:@"location"];
                post.strPageCount =[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"page_count"]];
                post.strLikeCount = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_like"]];
                post.strfollowers = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_follower"]];
                post.strfollowing = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_following"]];
                post.strRating = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"rating"]];
                
                straboutPic = [[[results objectAtIndex:i] objectForKey:@"review"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"[%@]", straboutPic);
                straboutPic = [straboutPic stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                
                post.strReview = [NSString stringWithFormat:@"%@", straboutPic];
                post.strRateUserName = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"first_name"]];//Display Name of the Looks Guru User
                
                straboutPic = [[[results objectAtIndex:i]objectForKey:@"about_pic"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"[%@]", straboutPic);
                straboutPic = [straboutPic stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                post.strAboutLook = [NSString stringWithFormat:@"%@",straboutPic];
                post.strImageTags = [NSString stringWithFormat:@"%@",[[results objectAtIndex:i]objectForKey:@"tag"]];
                
                if([[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"like"]] isEqualToString:@"0"])
                {
                    post.isLike = NO;
                }
                else
                {
                    post.isLike = YES;
                }
                
                
                if ([[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"dislike"]] isEqualToString:@"0"])
                {
                    post.isDislike = NO;
                }
                else
                {
                    post.isDislike = YES;
                }
                post.strDislikeCount = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_dislike"]];
                post.arrComments = [[NSMutableArray alloc] init];//[[results objectAtIndex:i] objectForKey:@"comment"];
                NSArray *arr = [[results objectAtIndex:i] objectForKey:@"comment"];
                if ([arr isKindOfClass:[NSArray class]])
                {
                    for (int j = 0; j < [arr count]; j++)
                    {
                        LGCommentsData *data = [[LGCommentsData alloc] init];
                        
                        NSString *mystring = [[[arr objectAtIndex:j] objectForKey:@"comment"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSLog(@"[%@]", mystring);
                        
                        mystring = [mystring stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                        
                        data.strComment = mystring;
                        
                        data.strCommentId = [[arr objectAtIndex:j] objectForKey:@"comment_id"];
                        data.strUserImgURL = [[arr objectAtIndex:j] objectForKey:@"comment_user_image"];
                        data.strUserName = [[arr objectAtIndex:j] objectForKey:@"comment_user_name"];
                        data.strUserid = [[arr objectAtIndex:j] objectForKey:@"user_id"];
                        data.strPostId = [[arr objectAtIndex:j] objectForKey:@"post_id"];
                        data.strPublishDate = [[arr objectAtIndex:j] objectForKey:@"publish_date"];
                        data.strCommentUserImage = [[arr objectAtIndex:j] objectForKey:@"comment_image"];
                        
                        [post.arrComments addObject:data];
                    }
                }
                post.strCommentCount = [NSString stringWithFormat:@"%d", (int)[post.arrComments count]];
                //post.imgPostImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[post strPostImage]]]];
                
                if(![[[results objectAtIndex:i] objectForKey:@"width"] isKindOfClass:[NSNull class]])
                {
                    post.postImageWidth = [[[results objectAtIndex:i] objectForKey:@"width"] floatValue];
                }
                
                if(![[[results objectAtIndex:i] objectForKey:@"height"] isKindOfClass:[NSNull class]])
                {
                    post.postImageHeight = [[[results objectAtIndex:i] objectForKey:@"height"] floatValue];
                }
                
                [arrPosts addObject:post];
                totalNumberOfPages = [post.strPageCount integerValue];
                loginData.strFollowersCount = [post strfollowers];
                loginData.strFollowingCount = [post strfollowing];
                loginData.strStyleMantra = post.strStylemantra;
                totalPostCount = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"post_count"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [GMDCircleLoader hideFromView:self.view animated:YES];
                               
                               if(totalNumberOfPages >= count)
                               {
                                   //                                   activity.hidden = YES;
                               }
                               
                               searchresult = arrPosts;
                               
                               _tbl_chatlist.dataSource = self;
                               _tbl_chatlist.delegate = self;
                               [_tbl_chatlist reloadData];
                               
                               isPreviousRequestComplted = YES;
                           });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               isPreviousRequestComplted = YES;
                               [GMDCircleLoader hideFromView:self.view animated:YES];
                           });
        }
    }
    //#endif
}

- (void)startIconDownload:(LGPostData *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        stopDownload = NO;
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.ChatusersData = appRecord;
        [iconDownloader setCompletionHandler:^{
            if (!stopDownload) {
                
                AddfriendsCell *cell = (AddfriendsCell*)[_tbl_chatlist cellForRowAtIndexPath:indexPath];
                {
                    [cell.img_item setImage:appRecord.imgPostImage];
                }
                
                [cell.img_item setContentMode:UIViewContentModeScaleAspectFit];
                
                cell.img_item.clipsToBounds = YES;
                
                downloadCOunter++;
                
                //                [_tbl_listUser reloadItemsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil]];
                
                [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            }else
            {
                appRecord.imgPostImage = nil;
            }
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

#pragma mark search bar

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    sbarUserSearch.text = @"";
    searchresult = arrPosts;
    [_tbl_chatlist reloadData];
    
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(sbarUserSearch.text.length == 0)
    {
        
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@", sbarUserSearch.text);
    NSUInteger newLength = [searchBar.text length] + [text length] - range.length;
    NSLog(@"%lu", (unsigned long)newLength);
    
    if(sbarUserSearch.text.length >= 1 || newLength == 1)
    {
        //        NSPredicate *resultPredicate = [NSPredicate
        //                                        predicateWithFormat:@"SELF contains[cd] %@",
        //                                        searchBar.text];
        
        searchresult = [NSMutableArray new];
        
        for(int i=0;i<arrPosts.count;i++)
        {
            LGPostData *data = [arrPosts objectAtIndex:i];
            NSString *text1 = [[NSString stringWithFormat:@"%@%@",searchBar.text,text] lowercaseString];
            NSString *name = data.strDisplayName;
            if([[name lowercaseString] containsString:text1])
            {
                [searchresult addObject:[arrPosts objectAtIndex:i]];
            }
        }
        
        [_tbl_chatlist reloadData];
    }
    
    if(newLength == 0)
    {
        searchresult = arrPosts;
        [_tbl_chatlist reloadData];
    }
    
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    searchresult = [NSMutableArray new];
    
    for(int i=0;i<arrPosts.count;i++)
    {
        LGPostData *data = [arrPosts objectAtIndex:i];
        NSString *text1 = [[NSString stringWithFormat:@"%@",searchBar.text] lowercaseString];
        NSString *name = data.strDisplayName;
        if([[name lowercaseString] containsString:text1])
        {
            [searchresult addObject:[arrPosts objectAtIndex:i]];
        }
    }
    sbarUserSearch.text = @"";
    [_tbl_chatlist reloadData];
    // Do the search...
}

#pragma mark 
#pragma mark Chat view 


//http://api.looksguru.com/conversation_list.php?user_id=110&friend_id=134 ---->>>> conversation list

-(void)requestForconversationFail:(ASIFormDataRequest *)request
{
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       isPreviousRequestComplted = YES;
                       [CommonFunctions alertForNoInternetConnection];
                       [GMDCircleLoader hideFromView:self.view animated:YES];
                   });
}
-(void)requestForconversationSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser = [[SBJSON alloc]init];
    NSMutableArray *results = [parser objectWithString:responseString error:nil];
    
    results = [parser objectWithString:responseString error:nil];
  
    arrtxtViewWidth = [[NSMutableArray alloc] init];
    ChatData.arrmessage = [[NSMutableArray alloc] init];
    ChatData.arrsenderID = [[NSMutableArray alloc] init];
    ChatData.conversionID = [[NSMutableArray alloc] init];
    if(![results isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [loding stopAnimating];
                           [loding setHidden:YES];
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                           
                       });
    }
    else
    {
            if(results.count > 0)
            {
                arrChat = results;
                [ChatData.arrmessage addObjectsFromArray:[arrChat valueForKey:@"message"]];
                [ChatData.arrsenderID addObjectsFromArray:[arrChat valueForKey:@"sender_user_id"]];
                [ChatData.conversionID addObjectsFromArray:[arrChat valueForKey:@"conversation_id"]];
                
                Subview.tbl_chatview.dataSource = self;
                Subview.tbl_chatview.delegate = self;
//                [Subview.tbl_chatview setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
                 Subview.tbl_chatview.hidden = false;
                [Subview.tbl_chatview reloadData];
                [self scrollTableToBottom];
                
                [loding stopAnimating];
                [loding setHidden:YES];
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   
                                   [loding stopAnimating];
                                   [loding setHidden:YES];
                                   isPreviousRequestComplted = YES;
                                   [GMDCircleLoader hideFromView:self.view animated:YES];
//                                   [Subview.tbl_chatview reloadData];
                               });
            }
        }
}

//http://api.looksguru.com/conversation.php?sender_user_id=110&receiver_user_id=135&message=this is for testing ------->>>>>> conversation
#pragma mark 
#pragma mark text field delegets

- (void)scrollTableToBottom {
    int rowNumber = [Subview.tbl_chatview numberOfRowsInSection:0];
    if (rowNumber > 0) [Subview.tbl_chatview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength == 0)
    {
        Subview.cmtBtn.userInteractionEnabled = false;
        Subview.cmtBtn.alpha = 0.3;
    }
    else
    {
        Subview.cmtBtn.userInteractionEnabled = true;
        Subview.cmtBtn.alpha = 1.0;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    Subview.cmtBtn.userInteractionEnabled = false;
//    Subview.cmtBtn.alpha = 0.4;
    
    [textField resignFirstResponder];
    return YES;
}
-(void)send_conversation
{
    Subview.cmtBtn.userInteractionEnabled = false;
    Subview.cmtBtn.alpha = 0.3;
    
    isPreviousRequestComplted = NO;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHAT]];
    
    [request setPostValue:loginData.strUserId forKey:@"sender_user_id"];
    [request setPostValue:strFriendID forKey:@"receiver_user_id"];
    [request setPostValue:Subview.cmntText.text forKey:@"message"];
    
    NSString *conversation_id = [NSString stringWithFormat:@"%d",[self getRandomNumberBetween:1 to:10000000]];
     [request setPostValue:conversation_id forKey:@"conversation_id"];
    
    NSString *string = Subview.cmntText.text;
    [ChatData.arrmessage addObject:string];
    [ChatData.arrsenderID addObject:loginData.strUserId];
    [ChatData.conversionID addObject:conversation_id];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForsend_conversationFail:)];
    [request setDidFinishSelector:@selector(requestForsend_conversationSuccess:)];
    
    [request setTimeOutSeconds:99999999999];
    [request startAsynchronous];
    
    [Subview.cmntText resignFirstResponder];
    Subview.cmntText.text = @"";
}
-(void)requestForsend_conversationFail:(ASIFormDataRequest *)request
{
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       isPreviousRequestComplted = YES;
                       [CommonFunctions alertForNoInternetConnection];
                       [GMDCircleLoader hideFromView:self.view animated:YES];
                   });
}
-(void)requestForsend_conversationSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser = [[SBJSON alloc]init];
    NSMutableArray *results = [parser objectWithString:responseString error:nil];
    
    results = [parser objectWithString:responseString error:nil];
    arrPosts = [[NSMutableArray alloc] init];
    
    if(![results isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                           
                       });
    }
    else
    {
        if(results.count > 0)
        {
//            isPreviousRequestComplted = NO;
//            ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHAT_LIST]];
//            
//            [request setPostValue:loginData.strUserId forKey:@"user_id"];
//            [request setPostValue:strFriendID forKey:@"friend_id"];
//            [request setDelegate:self];
//            [request setDidFailSelector:@selector(requestForconversationFail:)];
//            [request setDidFinishSelector:@selector(requestForconversationSuccess:)];
//            
//            [request setTimeOutSeconds:99999999999];
//            [request startAsynchronous];
            Subview.tbl_chatview.dataSource = self;
            Subview.tbl_chatview.delegate = self;
            Subview.tbl_chatview.hidden = false;
            [Subview.tbl_chatview reloadData];
            [self scrollTableToBottom];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               isPreviousRequestComplted = YES;
                               [GMDCircleLoader hideFromView:self.view animated:YES];
                           });
        }
    }
}

//http://api.looksguru.com/conversation_save.php?user_id=134&conversation_id=4 ----->>>> conversation Save
-(void)save_conversation:(NSString *)conversation_id
{
    isPreviousRequestComplted = NO;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_CHAT_SAVE]];
    
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:conversation_id forKey:@"conversation_id"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForsave_conversationFail:)];
    [request setDidFinishSelector:@selector(requestForsave_conversationSuccess:)];
    
    [request setTimeOutSeconds:99999999999];
    [request startAsynchronous];
}
-(void)requestForsave_conversationFail:(ASIFormDataRequest *)request
{
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       isPreviousRequestComplted = YES;
                       [CommonFunctions alertForNoInternetConnection];
                       [GMDCircleLoader hideFromView:self.view animated:YES];
                   });
}
-(void)requestForsave_conversationSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser = [[SBJSON alloc]init];
    NSMutableArray *results = [parser objectWithString:responseString error:nil];
    
    results = [parser objectWithString:responseString error:nil];
    arrPosts = [[NSMutableArray alloc] init];
    
    if(![results isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                           
                       });
    }
    else
    {
        if(results.count > 0)
        {
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               isPreviousRequestComplted = YES;
                               [GMDCircleLoader hideFromView:self.view animated:YES];
                           });
        }
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

@end
