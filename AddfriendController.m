//
//  AddfriendController.m
//  Looks Guru
//
//  Created by Techno Softwares on 01/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//
#import "ContactsCell.h"
#import "AddfriendController.h"

@interface AddfriendController ()

@end

@implementation AddfriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    btnLeft.hidden = YES;
    btnAddPost.hidden = YES;
    btnUploadLook.hidden = YES;
    btnNotification.hidden = YES;
    btnBack.hidden = NO;
    viewFooter.hidden = YES;
    lblTitle.text = @"CONTACTS";
    btn_sbarUserSearch.hidden = YES;
    
    sbarUserSearch.delegate = self;
    [sbarUserSearch setShowsCancelButton:YES animated:YES];
    
#pragma mark
    Fullnamearr = [[NSMutableArray alloc]init];
    ImageArr= [[NSMutableArray alloc]init];
    contactsArray= [[NSMutableArray alloc]init];
    NumberArry = [[NSMutableArray alloc]init];
    
    
   
    [_tbl_listUser registerNib:[UINib nibWithNibName:@"ContactsCell" bundle:nil] forCellReuseIdentifier:@"ContactsCell"];
    
    if ([CommonFunctions isConnectedToInternet])
    {
        [GMDCircleLoader setOnView:self.view withTitle:@"" animated:YES];
        
        [self getPosts];
    }
    else
    {
        [CommonFunctions alertForNoInternetConnection];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark search bar

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{

    [searchBar resignFirstResponder];
    sbarUserSearch.text = @"";
    searchresult = arrPosts;
    [_tbl_listUser reloadData];

   
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
        
        [_tbl_listUser reloadData];
    }
    
    else if(newLength == 0)
    {
        searchresult = arrPosts;
        [_tbl_listUser reloadData];
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
    [_tbl_listUser reloadData];
    // Do the search...
}
-(void)datareload {
    
     [_tbl_listUser reloadData];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     [self.view endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchresult.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsCell *cell = (ContactsCell *)[_tbl_listUser dequeueReusableCellWithIdentifier:@"ContactsCell"];
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
    
    LGPostData *data = [searchresult objectAtIndex:indexPath.row];
    
    if (data.strSmallThumbURL.length > 0)
    {
        if (!data.imgPostImage)
        {
            [self startIconDownload:data forIndexPath:indexPath];
        }
        else
        {
            [cell.img_contact setImage:data.imgPostImage];
            
        }
    }

    
    cell.lbl_contactName.text = data.strDisplayName;
    cell.btn_sendSMS.alpha = 1.0;
    [cell.btn_sendSMS setTitle:@"Add" forState:UIControlStateNormal];
    [cell.btn_sendSMS addTarget:self action:@selector(AddFriends:) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark
-(void)getPosts
{
    isPreviousRequestComplted = NO;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_USERS_LIST]];
    
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
                               
                               _tbl_listUser.dataSource = self;
                               _tbl_listUser.delegate = self;
                               [_tbl_listUser reloadData];
                               
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
        iconDownloader.Usersdata = appRecord;
        [iconDownloader setCompletionHandler:^{
            if (!stopDownload) {
                
                ContactsCell *cell = (ContactsCell*)[_tbl_listUser cellForRowAtIndexPath:indexPath];
                {
                    [cell.img_contact setImage:appRecord.imgPostImage];
                }
                
                [cell.img_contact setContentMode:UIViewContentModeScaleAspectFit];
                
                cell.img_contact.clipsToBounds = YES;
                
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


-(IBAction)AddFriends:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.alpha = 0.4;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tbl_listUser];
    NSIndexPath *Index = [self.tbl_listUser indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",Index.row);

    LGPostData *data = [searchresult objectAtIndex:Index.row];
    
    isPreviousRequestComplted = NO;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_ADD_FRIENDS]];
    
//    http://api.looksguru.com/send_friend_request.php?user_id=110&friend_id=135
    
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:data.strFriendID forKey:@"friend_id"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForAddFriendsFail:)];
    [request setDidFinishSelector:@selector(requestFoAddFriendsSuccess:)];
    
    [request setTimeOutSeconds:99999999999];
    [request startAsynchronous];
   
}

-(void)requestForAddFriendsFail:(ASIFormDataRequest *)request
{
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       isPreviousRequestComplted = YES;
                       [CommonFunctions alertForNoInternetConnection];
                       [GMDCircleLoader hideFromView:self.view animated:YES];
                   });
}
-(void)requestFoAddFriendsSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser = [[SBJSON alloc]init];
    NSMutableArray *results = [parser objectWithString:responseString error:nil];
    
    results = [parser objectWithString:responseString error:nil];
    
    [self getPosts];
}
@end
