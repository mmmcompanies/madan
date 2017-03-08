//
//  LGHomeViewController.m
//  Looks Guru
//
//  Created by Techno Softwares on 23/01/15.
//  Copyright (c) 2015 Technosoftwares. All rights reserved.
//
#import "ChatViewController.h"
#import "LGHeaderViewController.h"
#import "LGNotificationsCenterViewController.h"
#import "LGPostLookViewController.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "AddFriendsView.h"
#import "LGHomeViewController.h"
#import "LGRequestViewController.h"
#import "CustomBadge.h"
#import "UIButton+CustomBadge.h"

dispatch_queue_t MyThread;

@interface LGHomeViewController ()
{
     BOOL stopDownload;
}
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation LGHomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    limit = 10;
    
    if (IS_IPAD)
    {
        defultCellHeight = 542;
    }
    else
    {
        defultCellHeight = 197;
    }
    
    MyThread = dispatch_queue_create("Back", nil);
    
   
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSString *strFetchPost = URL_FETCH_POST;
    
    urlFetchPosts = [[NSURL alloc] initWithString:strFetchPost];
     arrPosts = [[NSMutableArray alloc] init];
    [self setNeedsStatusBarAppearanceUpdate];
    count = 1;
    [activity setHidden:YES];
    tblFrame = tblPosts.frame;
    
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
    singleTapGestureRecognizer.delegate = self;
    
    if (nil == locationManger)
        locationManger = [[CLLocationManager alloc] init];
    
    locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    locationManger.delegate = self;
    if ([locationManger  respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManger requestWhenInUseAuthorization];
    }
    
    [locationManger startUpdatingLocation];
    
    arrPosts = [[NSMutableArray alloc] init];
    arrUserIdsOfLoadedProfileImage = [[NSMutableArray alloc] init];
    
    if ([CommonFunctions isConnectedToInternet])
    {
        [GMDCircleLoader setOnView:self.view withTitle:@"" animated:YES];
        
        [self performSelectorInBackground:@selector(getPosts) withObject:nil];
    }
    else
    {
        [CommonFunctions alertForNoInternetConnection];
    }
    
    btnLeft.hidden = NO;
    btnAddPost.hidden = YES;
    btnUploadLook.hidden = YES;
    btnNotification.hidden = YES;
    btnBack.hidden = YES;
    lblTitle.text = @"HOME";
    lblTitle.hidden = YES;
    Movetousersearch = YES;
    
    [btn_sbarUserSearch addTarget:self action:@selector(backSearchberClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn_1 addTarget:self action:@selector(btnNewsFeedClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn_2 addTarget:self action:@selector(btnFriendsRequest) forControlEvents:UIControlEventTouchUpInside];
    [btn_3 addTarget:self action:@selector(btnmessageClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_3 setBadgeWithNumber:@0];
    
    [btn_4 addTarget:self action:@selector(btnNotificationCenterClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn_5 addTarget:self action:@selector(btnAddPostClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn_6 addTarget:self action:@selector(btnInviteClicked) forControlEvents:UIControlEventTouchUpInside];
    
    imgProfilePicView.image = loginData.imgProfile;
    [imgProfilePicView setHidden:YES];
    
     [self.view addSubview:viewFooter];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
                    // return NO to not become first responder
-(void)viewWillAppear:(BOOL)animated
{
     [self.view endEditing:YES];
//    [sbarUserSearch endEditing:YES];
    
    [super viewWillAppear:animated];
    isOnHomeScreen = YES;
    [tblPosts reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceToken) name:@"UpdateDeviceToken" object:nil];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Looks Guru Home Page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    isOnHomeScreen = NO;
}

- (void)updateDeviceToken
{
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_UPDATE_DEVICE_TOKEN]];
    
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:strDeviceToken forKey:@"device_token"];
    
    [request setTimeOutSeconds:99999999999999999];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        
        responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"%@", responseString);
        id results;
        
        SBJSON *parser = [[SBJSON alloc]init];
        
        results = [parser objectWithString:responseString error:nil];
        
        if ([[results objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"Device token updated for user id :  %@", loginData.strUserId);
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@",error);
    }];
    [request startAsynchronous];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    if (location)//abs(howRecent) < 15.0)
    {
        loginData.strLongitidue  = [NSString stringWithFormat:@"%.6f", location.coordinate.longitude];
        loginData.strLatitude   = [NSString stringWithFormat:@"%.6f", location.coordinate.latitude];
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       
                       if (error){
                           //NSLog(@"Geocode failed with error: %@", error);
                           return;
                           
                       }
                       
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       strGetLocation = placemark.locality;
                       //NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
                   }];
    
}

-(void)locationManager:(CLLocationManager* )manager didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
//                       [[[UIAlertView alloc] initWithTitle:@"We need to know your location" message:@"Please go to Settings-- > Privacy-- > Location and enable Location services for Looks Guru" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                   });
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)getPosts
{
    if(!loginData.strLatitude || !loginData.strLongitidue)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"We need to know your location" message:@"Please go to Settings --> Privacy --> Location and enable Location services for Looks Guru" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            [GMDCircleLoader hideFromView:self.view animated:YES];
        });
        
        return;
    }
    alreadyRequested = YES;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlFetchPosts];
    
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:loginData.strLatitude forKey:@"latitude"];
    [request setPostValue:loginData.strLongitidue forKey:@"longitude"];
    
    NSString *strValue = [@(count) stringValue];
    [request setPostValue:strValue forKey:@"page_number"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForGetPostsFail:)];
    [request setDidFinishSelector:@selector(requestFoGetPostsSuccess:)];
    
    [request setTimeOutSeconds:99999999999];
    [request startAsynchronous];
}

-(void)requestForGetPostsFail:(ASIFormDataRequest *)request
{
    alreadyRequested = NO;
    [GMDCircleLoader hideFromView:self.view animated:YES];
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [CommonFunctions alertForNoInternetConnection];
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
    
    alreadyRequested = NO;
    
    if(![results isKindOfClass:[NSArray class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[[UIAlertView alloc] initWithTitle:@"" message:@"No looks to show!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                           [tblPosts reloadData];
                       });
    }
    else
    {
        if(results.count > 0)
        {
            for(int i = 0; i < [results count]; i++)
            {
                LGPostData *post = [[LGPostData alloc] init];
                post.strPageCount =[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"page_count"]];
                
                post.strPostImage = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"post_image"]];
                post.strMediumThumbURL = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"image_200"]];
                post.strMediumThumbURL = [NSString stringWithFormat:@"%@%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"image_400"]];
                post.strPostId = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"post_id"]];
                
                NSString *straboutPic = [[[results objectAtIndex:i]objectForKey:@"about_pic"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"[%@]", straboutPic);
                straboutPic = [straboutPic stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                
                post.strAboutLook = [NSString stringWithFormat:@"%@",straboutPic];
                post.strImageTags = [NSString stringWithFormat:@"%@",[[results objectAtIndex:i]objectForKey:@"tag"]];
                post.strUserName = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"user_name"]];
                post.strRating = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"rating"]];
                
                straboutPic = [[[results objectAtIndex:i] objectForKey:@"review"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"[%@]", straboutPic);
                straboutPic = [straboutPic stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                
                post.strReview = [NSString stringWithFormat:@"%@", straboutPic];
                post.strRateUserName = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"first_name"]];
                post.strUserImg = [NSString stringWithFormat:@"%@/%@", URL_MAIN, [[results objectAtIndex:i] objectForKey:@"user_image"]];
                post.strPublishDate = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"publish_date"]];
                post.strGender = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"gender"]];
                post.strPrivacyStatus = [[results objectAtIndex:i] objectForKey:@"user_privacy"];
                post.strDisplayName = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"display_name"]];
                NSString *text = post.strDisplayName;
                if (text.length>0)
                {
                    
                    post.strDisplayName = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
                }

                
                NSLog(@"%@ uppercased is %@", text, post.strDisplayName);

                post.strUserId = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"user_id"]];
                post.strLocation = [[results objectAtIndex:i] objectForKey:@"user_location"];
                post.strfollowers = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_follower"]];
                post.strfollowing = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_following"]];
                
                if([post.strLocation isKindOfClass:[NSNull class]])
                {
                    post.strLocation = @"Unavailable";
                }
                else if([post.strLocation length] == 0)
                {
                    post.strLocation = @"Unavailable";
                }
                
                post.strLikeCount = [NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"count_like"]];
                
                straboutPic = [[[results objectAtIndex:i] objectForKey:@"style_mantra"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"[%@]", straboutPic);
                straboutPic = [straboutPic stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                
                post.strStylemantra = [NSString stringWithFormat:@"%@", straboutPic];
                
                if([[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"like"]] isEqualToString:@"0"])
                {
                    post.isLike = NO;
                }
                else
                {
                    post.isLike = YES;
                }
                
                if([[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"save"]] isEqualToString:@"0"])
                {
                    post.isSave = NO;
                }
                else
                {
                    post.isSave = YES;
                }
                
                if([[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"is_following"]] isEqualToString:@"0"])
                {
                    post.isFollowing = NO;
                }
                else
                {
                    post.isFollowing = YES;
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
                        
//                        NSString *goodValue = [[[arr objectAtIndex:j] objectForKey:@"comment"] stringByReplacingOccurrencesOfString:@"-@-" withString:@"\\"];
//                        NSData *newdata = [goodValue dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//                        NSString *mystring = [[NSString alloc] initWithData:newdata encoding:NSNonLossyASCIIStringEncoding];
                        
                        NSString *mystring = [[[arr objectAtIndex:j] objectForKey:@"comment"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        NSLog(@"[%@]", mystring);
                        mystring = [mystring stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//                        data.strCommentId = [];
                        data.strCommentId = [[arr objectAtIndex:j] objectForKey:@"comment_id"];
                        data.strComment = mystring;
                        data.strUserImgURL = [[arr objectAtIndex:j] objectForKey:@"comment_user_image"];
                        data.strUserName = [[arr objectAtIndex:j] objectForKey:@"comment_user_name"];
                        data.strUserid = [[arr objectAtIndex:j] objectForKey:@"user_id"];
                        data.strPostId = [[arr objectAtIndex:j] objectForKey:@"post_id"];
                        data.strPublishDate = [[arr objectAtIndex:j] objectForKey:@"publish_date"];
                        data.strCommentUserImage = [[arr objectAtIndex:j] objectForKey:@"comment_image"];
                        
                        [post.arrComments addObject:data];
                    } 
                }
                
                post.isImageBlank = NO;
                
                if(![[[results objectAtIndex:i] objectForKey:@"width"] isKindOfClass:[NSNull class]])
                {
                    post.postImageWidth = [[[results objectAtIndex:i] objectForKey:@"width"] floatValue];
                }
                
                if(![[[results objectAtIndex:i] objectForKey:@"height"] isKindOfClass:[NSNull class]])
                {
                    post.postImageHeight = [[[results objectAtIndex:i] objectForKey:@"height"] floatValue];
                }
                if(post.postImageWidth == 0 || post.postImageHeight == 0)
                {
                    post.isImageBlank = YES;
                    post.postImageWidth = self.view.frame.size.width;
                    post.postImageHeight = defultCellHeight;
                }
                
                [arrPosts addObject:post];
                totalNumberOfPages = [post.strPageCount integerValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if(totalNumberOfPages >= count)
                               {
                                   activity.hidden = YES;
                                   tblPosts.frame = tblFrame;
                               }
                               [GMDCircleLoader hideFromView:self.view animated:YES];
                               [tblPosts reloadData];
                           });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [[[UIAlertView alloc] initWithTitle:@"" message:@"No looks to show!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                               [GMDCircleLoader hideFromView:self.view animated:YES];
                           });
        }
    }
    
}

- (CGRect)rectForText:(NSString *)text
            usingFont:(UIFont *)font
        boundedBySize:(CGSize)maxSize
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:font}];
    
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}


- (UIImage *)loadImage:(NSString *)strImageURL
{
    return imgProfilePicView.image;
}

//- (CGFloat)getCustomHeightForEachElement:(LGPostData *)deal
//{
//    //Margin Height
//    int marginTopBottom = (IS_IPAD)?184 : 75;
//    
//    //Height For Bottom View
//    int heightForBottomView = deal.isImageBlank ? 0 : ((IS_IPAD)? 74 : 41);
//    
//    // Image Height Auto Adjustment
//    int maxImgWidth = (IS_IPAD)? 768 : (IS_IPHONE_6_PLUS) ? 414 : (IS_IPHONE_6) ? 371 : 320;
//    float oldWidth = maxImgWidth, oldHeight = (IS_IPAD)?542 : 197;
//    
//    oldWidth = deal.postImageWidth;
//    oldHeight = deal.postImageHeight;
//    float scaleFactor = maxImgWidth / oldWidth;
//    
//    float newHeight = oldHeight * scaleFactor;
//    
//    int finalHeight = marginTopBottom + heightForBottomView + newHeight;
//    return finalHeight;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    LGPostData *data = [arrPosts objectAtIndex:indexPath.row];
//    
//    int finalHeight =  [self getCustomHeightForEachElement:data];
//    {
//        return finalHeight;
//    }
//}
- (CGFloat)getCustomHeightForEachElement:(LGPostData *)deal
{
    //Margin Height
    int marginTopBottom = (IS_IPAD)?184 : 75;
    
    //Height For Bottom View
    int heightForBottomView = (IS_IPAD)? 74 : 41;
    
    
    // Image Height Auto Adjustment
    int maxImgWidth = (IS_IPAD)? 768 : (IS_IPHONE_6_PLUS) ? 414 : (IS_IPHONE_6) ? 371 : 320;
    float oldWidth = maxImgWidth, oldHeight = (IS_IPAD)?542 : 197;
    
    oldWidth = deal.postImageWidth;
    oldHeight = deal.postImageHeight;
    
    
    float scaleFactor = maxImgWidth / oldWidth;
    
    float newHeight = oldHeight * scaleFactor;
    //float newWidth = oldWidth * scaleFactor;
    
    
    // Label Height Auto Adjustment
    //    CGSize maximumLabelSize = CGSizeMake((IS_IPAD)? 656 : 260,9000);
    //    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:(IS_IPAD)?32:16];
    //    CGRect titleRect = [self rectForText:[deal strProductTitle]
    //                               usingFont:font
    //                           boundedBySize:maximumLabelSize];
    int heightDealName;
    // int heightDealName = titleRect.size.height;
    
    int finalHeight = marginTopBottom + heightForBottomView + newHeight ;
    
    //NSLog(@"Height: %d", finalHeight);
    
    return finalHeight;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *sampleView = [[UIView alloc] init];
//    sampleView.backgroundColor = [UIColor clearColor];
//       return sampleView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50.0f;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LGPostData *data = [arrPosts objectAtIndex:indexPath.row];
    
    int finalHeight =  [self getCustomHeightForEachElement:[arrPosts objectAtIndex:indexPath.row]];
    
    
    if([data isImageBlank])
    {
        NSLog(@"%d",finalHeight);
    }
    return finalHeight;    
    
    
    if (IS_IPAD)
    {
        return finalHeight;
    }
    
    else if (IS_IPHONE_6)
    {
        return finalHeight+5;
    }
    
    else if (IS_IPHONE_6_PLUS)
    {
        return finalHeight+14;
    }
    
    //
    
    //    else if([[data arrComments] count] == 1)
    //    {
    //        return ((IS_IPAD)?130:60)+finalHeight;
    //    }
    //    else
    //    {
    //        return ((IS_IPAD)?254: 116)+finalHeight;
    //    }
    
    
}
 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  arrPosts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    CellIdentifier = @"Cell";
    
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL isAtLeast6 = [version floatValue] >= 6.0;
    UITableViewCell *cell;
    if(isAtLeast6)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIImageView *imgPosteUserImage = (UIImageView *)[cell viewWithTag:1];
    
    UILabel *lblTime = (UILabel *)[cell viewWithTag:2];
  
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:4];
    UIActivityIndicatorView *indicatorUserImg = (UIActivityIndicatorView *)[cell viewWithTag:5];
    UILabel *lblName = (UILabel *)[cell viewWithTag:6];
    UILabel *lblLikes = (UILabel *)[cell viewWithTag:7];
    UILabel *lblDisLikes = (UILabel *)[cell viewWithTag:8];
    UILabel *lblComments = (UILabel *)[cell viewWithTag:9];
    UILabel * lblSecondComment = (UILabel *)[cell viewWithTag:90];
    UIImageView * imgTimeview = (UIImageView *)[cell viewWithTag:200];
    
    UILabel *lblLocation = (UILabel *)[cell viewWithTag:10];
    lblComments.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 11);
    lblDisLikes.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 11);
    lblLikes.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 11);
    lblLocation.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 11);
    lblName.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 17);
    lblTime.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 12);

   
//    [btnUserLook setBackgroundImage:loginData.imgProfile forState:UIControlStateNormal];
    
    imgPosteUserImage.layer.cornerRadius = imgPosteUserImage.frame.size.width/2;
    imgPosteUserImage.clipsToBounds = YES;
    imgPosteUserImage.layer.cornerRadius = imgPosteUserImage.frame.size.width/2;
    [imgPosteUserImage setClipsToBounds:YES];
    imgPosteUserImage.layer.borderWidth = 2.0;
    imgPosteUserImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    LGPostData *data = [arrPosts objectAtIndex:indexPath.row];
    
   // lblName.text = data.strDisplayName;
    lblLikes.text = data.strLikeCount;
    lblDisLikes.text = data.strDislikeCount;
    lblName.text = data.strDisplayName;
    lblComments.text = [NSString stringWithFormat:@"%d", (int)[data.arrComments count]];
    lblLocation.text = data.strLocation;
   // lblTime.text = [self getDifferenceFromToday:data.strPublishDate];
    NSString *strPublishTime = [self getDifferenceFromToday:data.strPublishDate];
    lblTime.text = strPublishTime;
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width - (IS_IPAD ? 400: 200), (IS_IPAD)? 40 : 20);
    
    CGRect titleRect = [self rectForText:strPublishTime
                               usingFont:[lblTime font]
                           boundedBySize:maximumLabelSize];
    lblTime.frame = CGRectMake(tableView.frame.size.width-(titleRect.size.width + 5), lblTime.frame.origin.y, titleRect.size.width, lblTime.frame.size.height);
    imgTimeview.frame = CGRectMake(lblTime.frame.origin.x - 25, imgTimeview.frame.origin.y, imgTimeview.frame.size.width, imgTimeview.frame.size.height);
    if (IS_IPAD)
    {
        imgTimeview.frame = CGRectMake(lblTime.frame.origin.x - 35, imgTimeview.frame.origin.y, imgTimeview.frame.size.width, imgTimeview.frame.size.height);
    }
    
    UIImageView * imgvw = (UIImageView*)[cell viewWithTag:18];
    imgvw.clipsToBounds = YES;
    imgvw.layer.cornerRadius = imgvw.frame.size.width/2;
    
    
    UIImageView * cmtimgvw = (UIImageView*)[cell viewWithTag:21];
    cmtimgvw.clipsToBounds = YES;
    cmtimgvw.layer.cornerRadius = cmtimgvw.frame.size.width/2;

    
    CustomimageView * imgpostImage = (CustomimageView *) [cell viewWithTag:3];
    imgpostImage.indexpath = indexPath;
//    int random = arc4random() % arrPosts.count;
//    imgpostImage.image = [UIImage imageNamed:[arrPosts objectAtIndex:random]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [cell.imageView addGestureRecognizer:tap];
    imgpostImage.userInteractionEnabled = YES;
    [imgPosteUserImage removeGestureRecognizer:tap];
    
    [imgpostImage addGestureRecognizer:tap];

    RateView * viewRatings = (RateView *)[cell viewWithTag:109];
    UIView * viewRating = (UIView *) [cell viewWithTag:110];
    
//    viewRating.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0].CGColor;
    viewRating.frame = CGRectMake((self.view.frame.size.width-(viewRating.frame.size.width+4)), viewRating.frame.origin.y, viewRating.frame.size.width, viewRating.frame.size.height);
    viewRatings.notSelectedImage = [UIImage imageNamed:@"rating-w.png"];
    viewRatings.halfSelectedImage = [UIImage imageNamed:@"rating-w.png"];
    viewRatings.fullSelectedImage = [UIImage imageNamed:@"rating.png"];
    viewRatings.rating = [data.strRating intValue];
    
    viewRatings.editable = NO;
    viewRatings.maxRating = 5;
   // viewRatings.delegate = self;

    
//    viewRating.layer.borderWidth = 1.0f;
//    viewRating.layer.cornerRadius = 8.0;
    
    CustomButton *like =(CustomButton *)[cell viewWithTag:11];
    like.indexPath = indexPath;
    //like.alpha = 1.0;
    [like addTarget:self action:@selector(likePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomButton * dislike = (CustomButton *) [cell viewWithTag:12];
    dislike.indexPath = indexPath;
   //dislike.alpha = 1.0;
    [dislike addTarget:self action:@selector(dislikePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomButton *btnImage = (CustomButton *)[cell viewWithTag:34];
    btnImage.indexPath = indexPath;
    //[btnImage addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomButton * comment = (CustomButton *)[cell viewWithTag:13];
    comment.indexPath = indexPath;
    [comment addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomButton * userLooks = (CustomButton *) [cell viewWithTag:15];
    userLooks.indexPath = indexPath;
    [userLooks addTarget:self action:@selector(btnUserLookClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomButton * share = (CustomButton *)[cell viewWithTag:14];
    share.indexPath = indexPath;
    [share addTarget:self action:@selector(cbtnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * likeImgVw = (UIImageView *) [cell viewWithTag:31];
    [likeImgVw  setImage:[UIImage imageNamed:@"like.png"]];
    //[imgDislike  setImage:[UIImage imageNamed:@"disliked.png"]];
    UIImageView * dislikeImgVw = (UIImageView *) [cell viewWithTag:32];
     [dislikeImgVw setImage:[UIImage imageNamed:@"dislike.png"]];
    UIImageView * imgVwCmment = (UIImageView *) [cell viewWithTag:560];
    [imgVwCmment setImage:[UIImage imageNamed:@"comments.png"]];
    UIView * viewContener = (UIView *) [cell viewWithTag:41];
   
//    indicator.center = imgpostImage.center;
    
    indicator.frame = CGRectMake((cell.frame.size.width - indicator.frame.size.width) / 2, (cell.frame.size.height - indicator.frame.size.height) / 2, indicator.frame.size.width, indicator.frame.size.height);
    
    imgpostImage.frame = CGRectMake(imgpostImage.frame.origin.x, imgpostImage.frame.origin.y, imgpostImage.frame.size.width, imgpostImage.frame.size.height);
    btnImage.frame = imgpostImage.frame;
   
    if (IS_IPHONE_5)
    {
        imgpostImage.frame = CGRectMake(imgpostImage.frame.origin.x, imgpostImage.frame.origin.y, self.view.frame.size.width, imgpostImage.frame.size.height);
        viewContener.frame = CGRectMake(viewContener.frame.origin.x, viewContener.frame.origin.y, self.view.frame.size.width, viewContener.frame.size.height);
        lblTime.frame = CGRectMake(self.view.frame.size.width-(lblTime.frame.size.width+10), lblTime.frame.origin.y, lblTime.frame.size.width, lblTime.frame.size.height);
        btnImage.frame = imgpostImage.frame;
    }
    
    if (IS_IPHONE_6)
    {
        imgpostImage.frame = CGRectMake(imgpostImage.frame.origin.x, imgpostImage.frame.origin.y, self.view.frame.size.width, imgpostImage.frame.size.height);
        viewContener.frame = CGRectMake(viewContener.frame.origin.x, viewContener.frame.origin.y, self.view.frame.size.width, viewContener.frame.size.height);
        
        lblTime.frame = CGRectMake(self.view.frame.size.width-(lblTime.frame.size.width+10), lblTime.frame.origin.y, lblTime.frame.size.width, lblTime.frame.size.height);
            lblSecondComment.frame = CGRectMake(lblSecondComment.frame.origin.x+1, lblSecondComment.frame.origin.y,  lblSecondComment.frame.size.width, lblSecondComment.frame.size.height);
        
        likeImgVw.frame = CGRectMake(likeImgVw.frame.origin.x, likeImgVw.frame.origin.y, likeImgVw.frame.size.width, likeImgVw.frame.size.height);
        lblLikes.frame = CGRectMake(likeImgVw.frame.origin.x+15, lblLikes.frame.origin.y, lblLikes.frame.size.width, lblLikes.frame.size.height);
        
        dislikeImgVw.frame = CGRectMake(dislikeImgVw.frame.origin.x, dislikeImgVw.frame.origin.y, dislikeImgVw.frame.size.width, dislikeImgVw.frame.size.height);
        lblDisLikes.frame = CGRectMake(dislikeImgVw.frame.origin.x+15, lblDisLikes.frame.origin.y, lblDisLikes.frame.size.width, lblDisLikes.frame.size.height);
        
        lblComments.frame = CGRectMake(imgVwCmment.frame.origin.x+15, lblComments.frame.origin.y, lblComments.frame.size.width, lblComments.frame.size.height);
        btnImage.frame = imgpostImage.frame;
    }
    
    if (IS_IPHONE_6_PLUS)
    {
        imgpostImage.frame = CGRectMake(imgpostImage.frame.origin.x, imgpostImage.frame.origin.y, self.view.frame.size.width, imgpostImage.frame.size.height);
        viewContener.frame = CGRectMake(viewContener.frame.origin.x, viewContener.frame.origin.y, self.view.frame.size.width, viewContener.frame.size.height);
        
        lblTime.frame = CGRectMake(self.view.frame.size.width-(lblTime.frame.size.width+10), lblTime.frame.origin.y, lblTime.frame.size.width, lblTime.frame.size.height);
        lblSecondComment.frame = CGRectMake(lblSecondComment.frame.origin.x+2, lblSecondComment.frame.origin.y,  lblSecondComment.frame.size.width, lblSecondComment.frame.size.height);
        lblLikes.frame = CGRectMake(likeImgVw.frame.origin.x+15, lblLikes.frame.origin.y, lblLikes.frame.size.width, lblLikes.frame.size.height);
        
        dislikeImgVw.frame = CGRectMake(dislikeImgVw.frame.origin.x, dislikeImgVw.frame.origin.y, dislikeImgVw.frame.size.width, dislikeImgVw.frame.size.height);
        lblDisLikes.frame = CGRectMake(dislikeImgVw.frame.origin.x+15, lblDisLikes.frame.origin.y, lblDisLikes.frame.size.width, lblDisLikes.frame.size.height);
        
        lblComments.frame = CGRectMake(imgVwCmment.frame.origin.x+15, lblComments.frame.origin.y, lblComments.frame.size.width, lblComments.frame.size.height);
        btnImage.frame = imgpostImage.frame;
    }
    
    if (IS_IPAD)
    {
        imgpostImage.frame = CGRectMake(imgpostImage.frame.origin.x, imgpostImage.frame.origin.y, self.view.frame.size.width, imgpostImage.frame.size.height);
        viewContener.frame = CGRectMake(viewContener.frame.origin.x, viewContener.frame.origin.y, self.view.frame.size.width, viewContener.frame.size.height);
        
        lblTime.frame = CGRectMake(self.view.frame.size.width-(lblTime.frame.size.width+10), lblTime.frame.origin.y, lblTime.frame.size.width, lblTime.frame.size.height);
        btnImage.frame = imgpostImage.frame;
        
    }
    
    if(data.isLike)
    {
        [like setUserInteractionEnabled:YES];
        [dislike setUserInteractionEnabled:YES];
        [likeImgVw  setImage:[UIImage imageNamed:@"like1.png"]];
        [dislikeImgVw  setImage:[UIImage imageNamed:@"dislike.png"]];
    }
//    else{
//        [like setUserInteractionEnabled:YES];
//        [dislike setUserInteractionEnabled:YES];
//        [likeImgVw  setImage:[UIImage imageNamed:@"like.png"]];
//    
//    }
  else  if (data.isDislike)
    {
        [like setUserInteractionEnabled:YES];
        [dislike setUserInteractionEnabled:YES];
        [likeImgVw  setImage:[UIImage imageNamed:@"like.png"]];
        [dislikeImgVw  setImage:[UIImage imageNamed:@"disliked.png"]];
    }
    else
    {
        [like setUserInteractionEnabled:YES];
        [dislike setUserInteractionEnabled:YES];
        [dislikeImgVw  setImage:[UIImage imageNamed:@"dislike.png"]];
        [likeImgVw  setImage:[UIImage imageNamed:@"like.png"]];
     
//        [dislikeImgVw  setImage:[UIImage imageNamed:@"dislike.png"]];
    }
    
    if (data.strMediumThumbURL.length > 0 && !data.isImageBlank)
    {
        if (!data.imgPostImage)
        {
            [viewContener setHidden:YES];
            //[self OptimizedIconDownload:data andIndex:indexPath];
            [self startIconDownload:data forIndexPath:indexPath];
            indicator.hidden = NO;
            imgpostImage.image = nil;
            [indicator startAnimating];
        }
        else
        {
            [viewContener setHidden:NO];
            [indicator stopAnimating];
            indicator.hidden = YES;
            [imgpostImage setImage:data.imgPostImage];
            [cell bringSubviewToFront:viewRatings];
        }
    }
    else
    {
        [imgpostImage setImage:[UIImage imageNamed:(IS_IPAD)?@"no-img_ipad.png":@"no-img.png"]];
        data.imgPostImage = imgpostImage.image;
        
    }
    
    if (data.strUserImg.length > 0)
    {
        for(int i = 0; i < [arrUserIdsOfLoadedProfileImage count]; i++)
        {
            if([data.strUserId isEqualToString:[[arrUserIdsOfLoadedProfileImage objectAtIndex:i] strUserId]])
            {
                data.imgUserImage = [[arrUserIdsOfLoadedProfileImage objectAtIndex:i] imgUserImage];
                break;
            }
        }
        if (!data.imgUserImage)
        {
            NSLog(@"User Image URL :  %@", data.strUserImg);
            [self startUserImageDownload:data forIndexPath:indexPath];
            indicatorUserImg.hidden = NO;
            imgPosteUserImage.image = nil;
            [indicatorUserImg startAnimating];
        }
        else
        {
            [indicatorUserImg stopAnimating];
            indicatorUserImg.hidden = YES;
            [imgPosteUserImage setImage:data.imgUserImage];
        }
    }
    
    UIView *viewFirstCommentBox = [cell viewWithTag:16];
    UIView *viewSecondCommentBox = [cell viewWithTag:17];
    [viewFirstCommentBox setHidden:YES];
    [viewSecondCommentBox setHidden:YES];

    float oldWidth = imgpostImage.frame.size.width, oldHeight = imgpostImage.frame.size.height;
    if(data.imgPostImage)
    {
        oldWidth = data.imgPostImage.size.width;
        oldHeight = data.imgPostImage.size.height;
    }
    
    float scaleFactor = imgpostImage.frame.size.width / oldWidth;
    
    float newHeight = oldHeight * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    imgpostImage.frame = CGRectMake(imgpostImage.frame.origin.x, imgpostImage.frame.origin.y, newWidth, newHeight);
    
    viewContener.frame = CGRectMake(viewContener.frame.origin.x, (cell.frame.size.height - viewContener.frame.size.height) , viewContener.frame.size.width, viewContener.frame.size.height);
    
    if(data.isImageBlank)
    {
        [viewContener setHidden:YES];
    }
    else
    {
        [viewContener setHidden:NO];
    }
    
    {
        UIView *viewFirstCommentBox = [cell viewWithTag:16];
        [viewFirstCommentBox setHidden:YES];
        UIView *viewSecondCommentBox = [cell viewWithTag:17];
        [viewSecondCommentBox setHidden:YES];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if(indexPath.row >= 10)
    {
        LGPostData *data1 = [arrPosts objectAtIndex:indexPath.row - 10];
        data1.imgPostImage = nil;
    }
    
    return cell;
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)sender
{
    isFromImage = YES;
    CustomimageView * imge =  (CustomimageView *)[sender view];
    
    selectedIndex = imge.indexpath.row;
    
    selectedPost = [arrPosts objectAtIndex:imge.indexpath.row];
   
    if (selectedPost.isImageBlank)
        {
            return;
        }
    else  if (selectedPost.imgPostImage)
    {
        [self performSegueWithIdentifier:@"showComment" sender:self];
    }

//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Loading image..." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
    
}


-(void)likePhotoClicked:(id)sender
{
    CustomButton *btn = sender;
    selectedIndex =(int)btn.indexPath.row;
     selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
    if (selectedPost.isLike) {
        
        selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
        if (selectedPost.isLike)
        {
            int lcount = [[selectedPost strLikeCount] intValue] - 1;
            selectedPost.strLikeCount = [NSString stringWithFormat:@"%d", lcount];
            selectedPost.isLike = false;
            
            
        }
//        int dlcounts = [[selectedPost strDislikeCount] intValue] + 1;
//        selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d",dlcounts];
//        selectedPost.isDislike = true;
        
        [arrPosts replaceObjectAtIndex:selectedIndex withObject:selectedPost];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [tblPosts reloadData ];
        });
        
        [self performSelectorInBackground:@selector(UNlikePhoto) withObject:nil];

    }
    else {
        selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
        if (selectedPost.isDislike)
        {
            int dlcount = [[selectedPost strDislikeCount] intValue] - 1;
            selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d", dlcount];
            selectedPost.isDislike = false;
        }
        int lcounts = [[selectedPost strLikeCount] intValue] + 1;
        selectedPost.strLikeCount = [NSString stringWithFormat:@"%d",lcounts];
        selectedPost.isLike = true;
        
        [arrPosts replaceObjectAtIndex:selectedIndex withObject:selectedPost];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblPosts reloadData ];
        });
        
        [self performSelectorInBackground:@selector(likePhoto) withObject:nil];
    
    }

}

-(void)likePhoto
{
    if (alreadyRequested)
    {
        return;
        
    }
     alreadyRequested = YES;
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_LIKE_UNLIKE]];
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    [request setPostValue:@"1" forKey:@"post_like"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(likePhotoFail:)];
    [request setDidFinishSelector:@selector(likePhotoSuccess:)];
    [request startSynchronous];
}

- (void)likePhotoSuccess:(ASIHTTPRequest *)request
{
    alreadyRequested = NO;
    
    if(![loginData.strUserId isEqualToString:selectedPost.strUserId])
    {

    }
}
- (void)likePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",error);
    });
    
    alreadyRequested = NO;
}

-(void)UNlikePhoto
{
    if (alreadyRequested)
    {
        return;
        
    }
    alreadyRequested = YES;
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_LIKE_UNLIKE]];
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    [request setPostValue:@"0" forKey:@"post_like"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(UNlikePhotoFail:)];
    [request setDidFinishSelector:@selector(UNlikePhotoSuccess:)];
    [request startSynchronous];
}

- (void)UNlikePhotoSuccess:(ASIHTTPRequest *)request
{
    alreadyRequested = NO;
    
    if(![loginData.strUserId isEqualToString:selectedPost.strUserId])
    {
        
    }
}
- (void)UNlikePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",error);
    });
    
    alreadyRequested = NO;
}

-(void)dislikePhotoClicked:(id)sender
{
    CustomButton *btn = sender;
    selectedIndex = (int) btn.indexPath.row;
     selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
    if (selectedPost.isDislike) {
        
        if (selectedPost.isDislike)
        {
            int dlcount = [[selectedPost strDislikeCount] intValue] - 1;
            selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d", dlcount];
            selectedPost.isDislike = false;
        }
//        int lcounts = [[selectedPost strLikeCount] intValue] + 1;
//        selectedPost.strLikeCount = [NSString stringWithFormat:@"%d",lcounts];
//        selectedPost.isLike = true;
        
        [arrPosts replaceObjectAtIndex:selectedIndex withObject:selectedPost];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblPosts reloadData ];
        });
        
        [self performSelectorInBackground:@selector(likePhoto) withObject:nil];

    }
    
    else {
        
        selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
        
        if (selectedPost.isLike)
        {
            int lcount = [[selectedPost strLikeCount] intValue] - 1;
            selectedPost.strLikeCount = [NSString stringWithFormat:@"%d", lcount];
            selectedPost.isLike = false;
        }
        
        int dlcounts = [[selectedPost strDislikeCount] intValue] + 1;
        selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d",dlcounts];
        selectedPost.isDislike = true;
        
        [arrPosts replaceObjectAtIndex:selectedIndex withObject:selectedPost];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [tblPosts reloadData ];
        });
        
        [self performSelectorInBackground:@selector(UNlikePhoto) withObject:nil];
    }
    
    
}


-(void)dislikePhoto
{
    if (alreadyRequested)
    {
        return;
        
    }
    alreadyRequested = YES;

    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_DISLIKE_UNDISLIKE]];
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    [request setPostValue:@"1" forKey:@"post_like"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(dislikePhotoFail:)];
    [request setDidFinishSelector:@selector(dislikePhotoSuccess:)];
    [request startSynchronous];
}

- (void)dislikePhotoSuccess:(ASIHTTPRequest *)request
{
    alreadyRequested = NO;
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[loginData strUserId], @"sender_id", [selectedPost strUserId], @"receiver_id", [NSString stringWithFormat:@"%@ dislikes your awesome look.", loginData.strDisplayName], @"message", @"Dislike", @"key", nil];
//    
//    [[LGRestInteraction restInteractionManager] sendPushNotification:dict];
}




- (void)dislikePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", error);
    });
    
    alreadyRequested = NO;
}
-(void)UNdislikePhoto
{
    if (alreadyRequested)
    {
        return;
        
    }
    alreadyRequested = YES;
    
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_DISLIKE_UNDISLIKE]];
    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    [request setPostValue:@"0" forKey:@"post_like"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(UNdislikePhotoFail:)];
    [request setDidFinishSelector:@selector(UNdislikePhotoSuccess:)];
    [request startSynchronous];
}

- (void)UNdislikePhotoSuccess:(ASIHTTPRequest *)request
{
    alreadyRequested = NO;
}




- (void)UNdislikePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", error);
    });
    
    alreadyRequested = NO;
}

-(void)imageButtonClicked:(id)sender
{
    isFromImage = YES;
    CustomButton *btn = sender;
    selectedIndex = btn.indexPath.row;
    
    selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
    
    if (selectedPost.isImageBlank)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"showComment" sender:self];
}

-(void)commentButtonClicked:(id)sender
{
    isFromImage = NO;
    CustomButton *btn = sender;
    selectedIndex = btn.indexPath.row;
    
    selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
    
    if (selectedPost.isImageBlank)
    {
        return;
    }
    
    [self performSegueWithIdentifier:@"showComment" sender:self];
}

-(void)btnUserLookClicked:(id)sender
{
    CustomButton *btn = sender;
    selectedIndex = btn.indexPath.row;
    
    selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
    
    
    [self performSegueWithIdentifier:@"showUserLooks" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showComment"])
    {
        LGCommentsViewController *comments = (LGCommentsViewController *)[segue destinationViewController];
        
        comments.selectedPost = selectedPost;
        comments.isFromImage = isFromImage;
    }
    else if ([[segue identifier] isEqualToString:@"showUserLooks"])
    {
        LGUserLooksViewController * userlooks = (LGUserLooksViewController *) [segue destinationViewController];
    
        userlooks.selectedpost = selectedPost;

        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)OptimizedIconDownload:(LGPostData *)data andIndex:(NSIndexPath *)indexPath
{

        UITableViewCell *cell = [tblPosts cellForRowAtIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:4];
        CustomButton *btnImage = (CustomButton *)[cell viewWithTag:34];
    
                dispatch_async(MyThread, ^{

                NSURL *url = [NSURL URLWithString:data.strPostImage];
                
                NSData *imgData = [NSData dataWithContentsOfURL:url];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [arrPosts count];
                        
                        data.imgPostImage = [UIImage imageWithData:imgData];


                        imageView.image = data.imgPostImage;
                        if([tblPosts numberOfRowsInSection:0] > indexPath.row)
                        {
                            [tblPosts reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                    
                    });

                    
                });
    
    
}

- (void)startIconDownload:(LGPostData *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];

    if (iconDownloader == nil)
    {
       stopDownload  = NO;
        
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.isHomeImage = YES;
        [iconDownloader setCompletionHandler:^{
            if (!stopDownload)
            {
                UITableViewCell *cell = [tblPosts cellForRowAtIndexPath:indexPath];
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:4];
                CustomButton *btnImage = (CustomButton *)[cell viewWithTag:34];
                btnImage.indexPath = indexPath;
                [indicator stopAnimating];
                indicator.hidden = YES;

                [imageView setImage:appRecord.imgPostImage];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
                imageView.clipsToBounds = YES;
                btnImage.hidden = NO;
                
                // Remove the IconDownloader from the in progress list.
                // This will result in it being deallocated.
                [self.imageDownloadsInProgress removeObjectForKey:indexPath];
                [tblPosts reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else
            {
                appRecord.imgPostImage = nil;
            }
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (void)startUserImageDownload:(LGPostData *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        stopDownload = NO;
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            if (!stopDownload) {
                UITableViewCell *cell = [tblPosts cellForRowAtIndexPath:indexPath];
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:5];
                
                [indicator stopAnimating];
                indicator.hidden = YES;
                
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                CGSize newSize = [CommonFunctions getCustomHeightForProfilePic:appRecord.imgUserImage];
                NSLog(@"New Height: %f %f", newSize.width, newSize.height);
                
                appRecord.imgUserImage = [CommonFunctions imageWithImage:appRecord.imgUserImage scaledToSize:newSize];
                
                [arrUserIdsOfLoadedProfileImage addObject:appRecord];
                
                [imageView setImage:appRecord.imgUserImage];
                // Remove the IconDownloader from the in progress list.
                // This will result in it being deallocated.
                
                [self.imageDownloadsInProgress removeObjectForKey:indexPath];
                //[tblPosts reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else
            {
                appRecord.imgUserImage = nil;
            }
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownloadForProfileImage];
    }
}

- (NSString *)getDifferenceFromToday:(NSString *)dateString
{
    NSDate *currentDate = [NSDate date];
    //NSLog(@"%@", currentDate);
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromGivenDate = [f dateFromString:dateString];
    //NSLog(@"%@",fromGivenDate);
    
    fromGivenDate = [CommonFunctions getLocalTimeWithDate:fromGivenDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                        fromDate:fromGivenDate
                                                          toDate:currentDate
                                                         options:0];
    
    //NSLog(@"%d,%d,%d", components.hour, components.minute, components.second);
    
    if(components.second < 0)
    {
        return [NSString stringWithFormat:@"0s"];
    }
    
    if(components.year == 0)
    {
        if(components.month == 0)
        {
            if(components.day == 0)
            {
                if(components.hour == 0)
                {
                    if(components.minute == 0)
                    {
                        return [NSString stringWithFormat:@"%ds ago", components.second];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%dm %ds ago", components.minute, components.second];
                    }
                }
                else
                {
                    return [NSString stringWithFormat:@"%dh %dm ago", components.hour, components.minute];
                }
            }
            else
            {
                return [NSString stringWithFormat:@"%d %@ ago", components.day, (components.day > 1) ? @"days":@"day"];
            }
        }
        else
        {
            f.dateFormat = @"MMM dd";
            //NSLog(@"%@",[f stringFromDate:fromGivenDate]);
            return [NSString stringWithFormat:@"%@", [f stringFromDate:fromGivenDate]];
        }
    }
    else
    {
        f.dateFormat = @"MMM dd, YYYY";
        //NSLog(@"%@",[f stringFromDate:fromGivenDate]);
        return [NSString stringWithFormat:@"%@", [f stringFromDate:fromGivenDate]];
    }
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if(aScrollView == tblPosts)
    {
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        if(y <= 270 )
        {
            activitytop.hidden = NO;
            [activitytop startAnimating];
//            [self performSelectorInBackground:@selector(getPosts) withObject:nil];
        }
        else
        {
            activitytop.hidden = YES;
            [activitytop stopAnimating];
        
        }
        
        float reload_distance = 5;
        if(y > h + reload_distance)
        {
            if(count < totalNumberOfPages && !alreadyRequested)
            {
                tblPosts.frame = CGRectMake(tblPosts.frame.origin.x, tblPosts.frame.origin.y, tblPosts.frame.size.width, tblPosts.frame.size.height - 30);
                activity.hidden = NO;
                [activity startAnimating];
                count++;
                [self performSelectorInBackground:@selector(getPosts) withObject:nil];
            }
            else
            {
                activity.hidden = YES;
                [activity stopAnimating];
                tblPosts.frame = tblFrame;
            }
        }
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LGPostData *data = [arrPosts objectAtIndex:indexPath.row];
//    return [self getCustomHeightForEachElement:data];
//}

//- (CGFloat)getCustomHeightForEachElement:(LGPostData *)deal
//{
//    //Margin Height
//    int marginTopBottom = (IS_IPAD)?80 : 40;
//    
//    //Height For Bottom View
//    int heightForBottomView = (IS_IPAD)? 210 : 105;
//    
//    
//    // Image Height Auto Adjustment
//    int maxImgWidth = (IS_IPAD)? 703 : 272;
//    float oldWidth = maxImgWidth, oldHeight = (IS_IPAD)?384 : 196;
//    if(deal.imgProfile)
//    {
//        oldWidth = deal.imgProfile.size.width;
//        oldHeight = deal.imgProfile.size.height;
//    }
//    
//    float scaleFactor = maxImgWidth / oldWidth;
//    
//    float newHeight = oldHeight * scaleFactor;
//    //float newWidth = oldWidth * scaleFactor;
//    
//    
//    // Label Height Auto Adjustment
//    
//    int finalHeight = marginTopBottom + heightForBottomView + newHeight + 60;
//    
//    //NSLog(@"Height: %d", finalHeight);
//    
//    return finalHeight;
//}

- (void)cbtnShareClicked:(id)sender
{
    if([CommonFunctions isConnectedToInternet])
    {
        CustomButton *btn = (CustomButton *) sender;
        LGPostData *data = [arrPosts objectAtIndex:btn.indexPath.row];
        
        selectedPost = data;
        
        //selectedPost.imgUserImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selectedPost.strUserImg]]];
        
        [self performSelectorInBackground:@selector(sharePost) withObject:nil];
    }
    else
    {
        [CommonFunctions alertForNoInternetConnection];
    }
}

-(void) sharePost
{
    UIActionSheet *imageActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share On" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"Email", nil];
    imageActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    imageActionSheet.alpha=1.0;
    imageActionSheet.tag = 1;
    [imageActionSheet showInView:self.view];
    imageActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self shareOnFacebook];
    }
    else if(buttonIndex == 1)
    {
        [self shareOnTwitter];
    }
    else if(buttonIndex == 2)
    {
        [self shareViaMail];
    }
}

-(void)shareOnFacebook
{
    
//    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState state, NSError *error)
//     {
//         if (error)
//         {
//             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//             [alertView show];
//         }
//         else if(session.isOpen)
//         {
//             NSString *str_img = [NSString stringWithFormat:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png"];
//             
//             NSDictionary *params = @{
//                                      @"name" :[NSString stringWithFormat:@"Facebook SDK for iOS"],
//                                      @"caption" : @"Build great Apps",
//                                      @"description" :@"Welcome to iOS world",
//                                      @"picture" : str_img,
//                                      @"link" : @"",
//                                      };
//             
//             // Invoke the dialog
//             [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                                    parameters:params
//                                                       handler:
//              ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                  if (error) {
//                      //NSLog(@"Error publishing story.");
//                     // [self.indicator stopAnimating];
//                  } else {
//                      if (result == FBWebDialogResultDialogNotCompleted) {
//                          //NSLog(@"User canceled story publishing.");
//                         // [self.indicator stopAnimating];
//                      } else {
//                          //NSLog(@"Story published.");
//                         // [self.indicator stopAnimating];
//                      }
//                  }}];
//         }
//         
//     }];
//    
//    return;
//
//        //FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    NSString *strPackInfo = @"";
    NSString *logoURLLink = selectedPost.strPostImage;
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys: selectedPost.strDisplayName, @"name", strPackInfo, @"caption", selectedPost.strAboutLook, @"description", @"https://itunes.apple.com/us/app/logo-game-guess-the-brands/id953721694?mt=8", @"link", logoURLLink, @"picture", nil];
//        params.link = [NSURL URLWithString:@"https://itunes.apple.com/us/app/logo-game-guess-the-brands/id953721694?mt=8"];
//        params.picture = [NSURL URLWithString:selectedPost.strPostImage];
//    
//        params.name = @"Looks Guru";
//        params.caption = @"Build great apps";
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            if(error) {
                NSLog(@"Error: %@", error.description);
            } else {
                NSLog(@"Success!");
            }
      }];
    
//    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
//    params.link = [NSURL URLWithString:@"https://itunes.apple.com/us/app/logo-game-guess-the-brands/id953721694?mt=8"];
//    params.picture = [NSURL URLWithString:selectedPost.strPostImage];
//    params.name = selectedPost.strAboutLook;
//    params.caption = @"Looks Guru";
//    [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//        if(error) {
//            NSLog(@"Error: %@", error.description);
//        } else {
//            NSLog(@"Success!");
//        }
//    }];
    
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    {
//        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        __weak typeof(self) bself = self;
//        [slComposerSheet setInitialText:[NSString stringWithFormat:@"Checkout my new look \n %@ \n %@ ", selectedPost.strDisplayName, selectedPost.strAboutLook]];
//        
//        if(selectedPost.strPostImage.length > 0)
//        {
//            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:selectedPost.strPostImage]];
//            [slComposerSheet addImage:[UIImage imageWithData:imgData]];
//        }
//        
//        
//        [self presentViewController:slComposerSheet animated:YES completion:nil];
//        
//        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
//            NSLog(@"start completion block");
//            NSString *output;
//            switch (result) {
//                case SLComposeViewControllerResultCancelled:
//                    output = @"Action Cancelled";
//                    break;
//                case SLComposeViewControllerResultDone:
//                    output = @"Post Sharing Successfull";
//                    break;
//                default:
//                    break;
//            }
//            if (result != SLComposeViewControllerResultCancelled)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^
//                               {
//                                   
//                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:bself cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                                   [alert show];
//                                   
//                               });
//                
//                
//                
//            }
//        }];
//    }
//    else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
//                                                            message:@"You can't share your post right now, make sure your device has an internet connection and you have to login from setting."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//    }
}

-(void)shareOnTwitter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [slComposerSheet setInitialText:[NSString stringWithFormat:@"Checkout my new look\n %@", selectedPost.strDisplayName]];
        
        if(selectedPost.strPostImage.length > 0)
        {
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:selectedPost.strPostImage]];
            [slComposerSheet addImage:[UIImage imageWithData:imgData]];
        }
        
        [self presentViewController:slComposerSheet animated:YES completion:nil];
        
        [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSLog(@"start completion block");
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post sharing successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                                   
                               });
            }
            
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't share your post right now, make sure your device has an internet connection and you have to  login from setting."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

-(void)shareViaMail
{
    NSString *emailTitle = @"Looks Guru";
    
    NSString *messageBody = [NSString stringWithFormat:@"Checkout my new look \n %@ \n %@", selectedPost.strDisplayName, selectedPost.strAboutLook];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    if(selectedPost.strPostImage.length > 0)
    {
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:selectedPost.strPostImage]];
        [mc addAttachmentData:imgData mimeType:@"image/png" fileName:@"Consult"];
    }
    
    
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    [self presentViewController:mc animated:YES completion:NULL];
    
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
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    imgProfilePicView.image = loginData.imgProfile;
}

#pragma mark Footer view Action 
-(void)btnInviteClicked
{
    AddFriendsView *addfriends = [[AddFriendsView alloc] initWithNibName:@"AddFriendsView" bundle:nil];
    [self.navigationController pushViewController:addfriends animated:YES];
}
-(void)btnFriendsRequest
{
    
    LGRequestViewController *addfriends = [[LGRequestViewController alloc] initWithNibName:@"LGRequestViewController" bundle:nil];
    [self.navigationController pushViewController:addfriends animated:YES];

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
- (void)btnNewsFeedClicked:(id)sender{
    NSLog(@"btnNewsFeedClicked  :  ");
    [tblPosts setContentOffset:CGPointZero animated:YES];
}

- (void)backSearchberClicked:(id)sender{
    NSLog(@"Search bar clicked :  ");
    
    UIViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSearchViewController"];
    [self.navigationController pushViewController:obj animated:NO];
    
    [self.view endEditing:YES];
    
}
@end
