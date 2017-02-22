//
//  ChatViewController.m
//  Looks Guru
//
//  Created by Techno Softwares on 22/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "ChatViewController.h"
#import "AddfriendsCell.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    btnLeft.hidden = YES;
    btnAddPost.hidden = YES;
    btnUploadLook.hidden = YES;
    btnNotification.hidden = YES;
    btnBack.hidden = NO;
    
    lblTitle.text = @"CONTACTS";
    
#pragma mark
    
    Subview = [Chatview newChatview];
    Subview.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height );
//    Subview.hidden = true;
    [self.view addSubview:Subview];
    
    itemArray = @[@"Add from Contacts", @"Share on WhatsApp", @"Share by Email",@"Share on Facebook"];
    imgArray = @[@"contacts", @"whatsapp", @"email", @"facebook_icon"];
    
//    _tbl_chatlist.scrollEnabled = NO;
    
    [_tbl_chatlist registerNib:[UINib nibWithNibName:@"AddfriendsCell" bundle:nil] forCellReuseIdentifier:@"AddfriendsCell"];
    
    
    UISwipeGestureRecognizer *viewRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(RightSwipe:)];
    [viewRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [Subview addGestureRecognizer:viewRecognizer];
    viewRecognizer.delegate = self;
    
    _tbl_chatlist.dataSource = self;
    _tbl_chatlist.delegate = self;
    [_tbl_chatlist reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
//     Subview.hidden = false;
     [[Subview superview] bringSubviewToFront:Subview];
    //do you left swipe stuff here.
    CGPoint location = [gestureRecognizer locationInView:_tbl_chatlist];
    NSIndexPath *swipedIndexPath = [_tbl_chatlist indexPathForRowAtPoint:location];
    set_indexpath = swipedIndexPath;
    AddfriendsCell *swipedCell  = [_tbl_chatlist cellForRowAtIndexPath:swipedIndexPath];

    
    [UIView animateWithDuration:1.1 animations:^{
        swipedCell.frame = CGRectOffset(swipedCell.frame, [UIScreen mainScreen].bounds.size.width, 0.0);
        Subview.frame = CGRectOffset(Subview.frame, [UIScreen mainScreen].bounds.size.width, 0.0);
    }];
}

- (void)RightSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //do you left swipe stuff here.
    AddfriendsCell *swipedCell  = [_tbl_chatlist cellForRowAtIndexPath:set_indexpath];
    
    [UIView animateWithDuration:1.5 animations:^{
         swipedCell.frame = CGRectOffset(swipedCell.frame, -[UIScreen mainScreen].bounds.size.width, 0.0);
        Subview.frame = CGRectOffset(Subview.frame, -[UIScreen mainScreen].bounds.size.width, 0.0);
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddfriendsCell *cell = (AddfriendsCell *)[_tbl_chatlist dequeueReusableCellWithIdentifier:@"AddfriendsCell"];
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
    
    cell.backgroundColor = [UIColor greenColor];
    
    cell.img_item.image = [UIImage imageNamed:imgArray[indexPath.row]];
    cell.lbl_itemName.text = itemArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [cell addGestureRecognizer:recognizer];
    recognizer.delegate = self;

    
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

@end
