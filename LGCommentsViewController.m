//
//  LGUploadLooksViewController.m
//  Looks Guru
//
//  Created by Techno Softwares on 02/06/15.
//  Copyright (c) 2015 Technosoftwares. All rights reserved.
//

#import "LGCommentsViewController.h"
#import "LGRatingsViewController.h"
#import "LGUserLikesViewController.h"

@interface LGCommentsViewController ()
{
    CGRect defaultFrame;
    CGRect defaultFrame_imgLikeImg;
    CGRect defaultFrame_lblLikelbl;
    CGRect defaultFrame_btnLike;
    CGRect defaultFrame_imgDislike;
    CGRect defaultFrame_lblDislike;
    CGRect defaultFrame_btnDislike;
    CGRect defaultFrame_imgCmtImage;
    CGRect defaultFrame_lblCmnt;
    CGRect defaultFrame_btnCmment;
    CGRect defaultFrame_imgShare;
    CGRect defaultFrame_btnShaere;
    
}

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation LGCommentsViewController 
@synthesize selectedPost;
@synthesize arrPosts;
@synthesize tlPictureTags;
@synthesize isFromImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCommentScreen = YES;
    
    lblTitle.text = @"COMMENTS";
    //[imgProfilePicView setImage:[UIImage imageNamed:@"btn_back.png"]];
    imgProfilePicView.hidden = YES;
    btnBack.frame = CGRectMake(imgProfilePicView.frame.origin.x, btnBack.frame.origin.y, btnBack.frame.size.width, btnBack.frame.size.height);
    
    //viewCmmentBox.frame = CGRectMake(viewCmmentBox.frame.origin.x, viewCmmentBox.frame.origin.y + moveFactor, viewCmmentBox.frame.size.width, viewCmmentBox.frame.size.height);
    imgProfilePicView.image = loginData.imgProfile;
    btnLeft.hidden = NO;
    btnBack.hidden = NO;
    [btnNotification setHidden:YES];
    [btnUserLikes setHidden:NO];
    [btnAddPost setHidden:YES];
    cmntText.tintColor = [UIColor whiteColor];
    [lblImgVw setHidden:YES];
    
    [btn_sbarUserSearch setHidden:YES];
    [viewFooter setHidden:YES];
    [sbarUserSearch setHidden:YES];
    
    [btn_sbarUserSearch addTarget:self action:@selector(backSearchberClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btn_1 addTarget:self action:@selector(btnNewsFeedClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    [btnReportUser setHidden:NO];
    
    NSString *strComment = URL_ADD_COMMENT;
    urlComments = [[NSURL alloc] initWithString:strComment];
    tableArr = [[NSMutableArray alloc]init];
    tableVw.backgroundColor = [UIColor clearColor];
    
    imgUserImage.layer.cornerRadius = imgUserImage.frame.size.width/2;
    [imgUserImage setClipsToBounds:YES];
    imgUserImage.layer.borderWidth = 2.0;
    imgUserImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (selectedPost.imgUserImage)
    {
        imgUserImage.image = selectedPost.imgUserImage;
    }
    else
    {
        selectedPost.imgUserImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selectedPost.strUserImg]]];
        imgUserImage.image = selectedPost.imgUserImage;
    }
    
    count = 1;
    if (selectedPost.strLikeCount)
    {
        lblLikelbl.text = selectedPost.strLikeCount;
    }
    else
    {
      lblLikelbl.text = @"0";
    }
    
    if (selectedPost.strDislikeCount)
    {
        lblDislike.text = selectedPost.strDislikeCount;
    }
    else
    {
        lblDislike.text = @"0";
    }
    
    nameLabl.font = BRANDON_FONT((IS_IPAD)?30: 17);
    lblLooksGuruName.font = BRANDON_FONT((IS_IPAD)?30: 17);
    locationLbel.font =BRANDON_FONT((IS_IPAD)?22: 13);
    //lblLooksGuruReview.font =BRANDON_FONT((IS_IPAD)?14: 11);
    //lblAboutPic.font = BRANDON_FONT((IS_IPAD)?20:14);
    timelabel.font = BRANDON_FONT((IS_IPAD)?25: 12);
    
    lblCmnt.text = [NSString stringWithFormat:@"%d", (int)[selectedPost.arrComments count]];
    vwRate.notSelectedImage = [UIImage imageNamed:@"rating-w.png"];
    vwRate.halfSelectedImage = [UIImage imageNamed:@"rating-w.png"];
    vwRate.fullSelectedImage = [UIImage imageNamed:@"rating.png"];
    vwRate.rating = [selectedPost.strRating intValue];
    vwRate.editable = NO;
    vwRate.maxRating = 5;
    
    NSString *strPublishTime = [self getDifferenceFromToday:selectedPost.strPublishDate];
    timelabel.text = strPublishTime;
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width - (IS_IPAD ? 400: 200), (IS_IPAD)? 40 : 20);
    CGRect titleRect = [self rectForText:strPublishTime
                               usingFont:BRANDON_FONT((IS_IPAD)?25: 12)
                           boundedBySize:maximumLabelSize];
    timelabel.frame = CGRectMake((cScrollVw.frame.size.width - (titleRect.size.width + (IS_IPAD ? 20 : 10))), timelabel.frame.origin.y, titleRect.size.width, timelabel.frame.size.height);
    
    imgTimeView.frame = CGRectMake(timelabel.frame.origin.x - (imgTimeView.frame.size.width + (IS_IPAD ? 20 : 10)), imgTimeView.frame.origin.y, imgTimeView.frame.size.width, imgTimeView.frame.size.height);
    
    if (IS_IPHONE_6_PLUS)
    {
        lblLooksGuruName.frame = CGRectMake(lblLooksGuruName.frame.origin.x, lblLooksGuruName.frame.origin.y+5, lblLooksGuruName.frame.size.width, lblLooksGuruName.frame.size.height);
        lblLooksGuruReview.frame = CGRectMake(lblLooksGuruReview.frame.origin.x, lblLooksGuruReview.frame.origin.y+3, lblLooksGuruReview.frame.size.width, lblLooksGuruReview.frame.size.height);
    }
    
    [btnLike addTarget:self action:@selector(likePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnDislike addTarget:self action:@selector(dislikePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnShaere addTarget:self action:@selector(cbtnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imgUserImage.layer.cornerRadius = imgUserImage.frame.size.width/2;
    
    viewRating.frame = CGRectMake((self.view.frame.size.width - (viewRating.frame.size.width)-2), viewRating.frame.origin.y, viewRating.frame.size.width, viewRating.frame.size.height);
    
    if (!selectedPost.imgPostImage)
    {
        indector.hidden = NO;
        
    }
    else
    {
        indector.hidden = YES;
        isDownloaded = true;
    }
    
    [self performSelectorInBackground:@selector(downLoadImage) withObject:nil];
    
    imgPostImage.image = selectedPost.imgPostImage;
    
    scviewZoomImage.contentSize = imgPostImage.image.size;
    scviewZoomImage.delegate = self;
    
    txtViewComnt.layer.borderColor = [UIColor colorWithRed:248.0/255.0 green:206.0/255.0 blue:240.0/255.0 alpha:1.0].CGColor;
    txtViewComnt.layer.borderWidth = 1.0f;
    txtViewComnt.layer.cornerRadius = 8.0;
    
    nameLabl.text = selectedPost.strDisplayName;
    locationLbel.text = selectedPost.strLocation;

    defaultFrame = imgZoomPostImage.frame;
    
    float oldWidth = selectedPost.postImageWidth, oldHeight = selectedPost.postImageHeight;
    float scaleFactor = imgPostImage.frame.size.height / oldHeight;
    
    float newHeight = oldHeight * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    imgPostImage.frame = CGRectMake(imgPostImage.frame.origin.x, imgPostImage.frame.origin.y, newWidth, newHeight);
    btnPostImage.frame = CGRectMake(btnPostImage.frame.origin.x, btnPostImage.frame.origin.y, newWidth, newHeight);
    
    if ([selectedPost.strReview length] == 0)
    {
        lblLooksGuruReview.text = @"Not rated yet.";
        CGRect rect = [self rectForText:lblLooksGuruReview.text usingFont:BRANDON_FONT((IS_IPAD)?14: 11) boundedBySize:CGSizeMake(viewLooksGuru.frame.size.width, lblLooksGuruReview.frame.size.height)];
        [lblLooksGuruReview setFrame:CGRectMake(lblLooksGuruReview.frame.origin.x, lblLooksGuruReview.frame.origin.y, rect.size.width, lblLooksGuruReview.frame.size.height)];
        rect = [self rectForText:@"Rate now." usingFont:[UIFont fontWithName:@"helvetica-bold" size:[[lblLooksGuruReview font] pointSize]] boundedBySize:CGSizeMake(viewLooksGuru.frame.size.width, lblLooksGuruReview.frame.size.height)];
        
        if (![loginData.strUserTypes isEqualToString:@"simple"]  && ![loginData.strUserId isEqualToString:selectedPost.strUserId])
        {
            UIButton *btnRateNow = [[UIButton alloc] initWithFrame:CGRectMake(lblLooksGuruReview.frame.origin.x + lblLooksGuruReview.frame.size.width + (IS_IPAD ? 6 : 3), lblLooksGuruReview.frame.origin.y, rect.size.width, lblLooksGuruReview.frame.size.height)];
            [btnRateNow setTitle:@"Rate now." forState:UIControlStateNormal];
            [btnRateNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[btnRateNow titleLabel] setFont:[UIFont fontWithName:@"helvetica-bold" size:[[lblLooksGuruReview font] pointSize]]];
            [btnRateNow addTarget:self action:@selector(btnRateNowClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewLooksGuru addSubview:btnRateNow];
        }
    }
    else
    {
        lblLooksGuruReview.text = selectedPost.strReview;
        lblLooksGuruName.text = selectedPost.strRateUserName;
    } 
    
    if ([selectedPost.strAboutLook length]==0)
    {
        lblAboutPic.text = @"";
        viewPictureProperties.hidden = YES;
    }
    else
    {
        viewPictureProperties.frame = CGRectMake(viewPictureProperties.frame.origin.x, imgPostImage.frame.origin.y + imgPostImage.frame.size.height + 10, viewPictureProperties.frame.size.width, viewPictureProperties.frame.size.height);
        lblAboutPic.frame = CGRectMake(lblAboutPic.frame.origin.x, 5, lblAboutPic.frame.size.width, lblAboutPic.frame.size.height);
        lblAboutPic.text = selectedPost.strAboutLook;
        
//        tlPictureTags.tags = (NSMutableArray *) [selectedPost.strImageTags componentsSeparatedByString:@","];
//        tlPictureTags.mode = TLTagsControlModeList;
//        tlPictureTags.tagsBackgroundColor = [UIColor colorWithRed:141.0/255.0 green:86.0/255.0 blue:136.0/255.0 alpha:0.8];
//        tlPictureTags.tagsTextColor = [UIColor whiteColor];
//        [tlPictureTags reloadTagSubviews];
        
        [self loadTopCustomView];
    }
    
    if ([cmntText respondsToSelector:@selector(setAttributedPlaceholder:)])
    {
        UIColor *color = [UIColor colorWithRed:251.0/255 green:211.0/255 blue:245.0/255 alpha:1];
        cmntText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add your view" attributes:@{NSForegroundColorAttributeName: color}];
    } else
    {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    
    newHeight = [self getCustomHeightForEachElement:selectedPost];
    
    heightDifference = newHeight - imgPostImage.frame.size.height;    
    
    imgPostImage.frame = CGRectMake(imgPostImage.frame.origin.x, imgPostImage.frame.origin.y, self.view.frame.size.width, newHeight);
    viewPictureProperties.frame = CGRectMake(viewPictureProperties.frame.origin.x, (imgPostImage.frame.origin.y + imgPostImage.frame.size.height) + 5,viewPictureProperties.frame.size.width, viewPictureProperties.frame.size.height);
    btnPostImage.frame = imgPostImage.frame;
    
    if([selectedPost.strAboutLook length] == 0)
    {
        viewLooksGuru.frame = CGRectMake(viewLooksGuru.frame.origin.x, viewPictureProperties.frame.origin.y + 5, viewLooksGuru.frame.size.width, viewLooksGuru.frame.size.height);
    }
    else
    {
        viewLooksGuru.frame = CGRectMake(viewLooksGuru.frame.origin.x, viewPictureProperties.frame.origin.y + viewPictureProperties.frame.size.height + 5, viewLooksGuru.frame.size.width, viewLooksGuru.frame.size.height);
    }
    
    tableVw.frame = CGRectMake(tableVw.frame.origin.x, viewLooksGuru.frame.origin.y + viewLooksGuru.frame.size.height + 5, tableVw.frame.size.width, tableVw.frame.size.height);
    lblImgVw.frame = CGRectMake(lblImgVw.frame.origin.x, tableVw.frame.origin.y, lblImgVw.frame.size.width, lblImgVw.frame.size.height);
    
    if(selectedPost.isLike)
    {
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
        [imgLikeImg  setImage:[UIImage imageNamed:@"like1.png"]];
        [imgDislike  setImage:[UIImage imageNamed:@"dislike.png"]];
        
    }
    else if (selectedPost.isDislike)
    {
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
        [imgLikeImg  setImage:[UIImage imageNamed:@"like.png"]];
        [imgDislike  setImage:[UIImage imageNamed:@"disliked.png"]];
    }
    else
    {
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
        [imgLikeImg  setImage:[UIImage imageNamed:@"like1.png"]];
        [imgDislike  setImage:[UIImage imageNamed:@"disliked.png"]];
    }
    
    if (selectedPost.arrComments.count>10)
    {
        rowCount = 10 + 1;
    }    
    else
    {
        rowCount = selectedPost.arrComments.count;
    }
    
    [cScrollVw setFrame:CGRectMake(0, 70, cScrollVw.frame.size.width, self.view.frame.size.height - (70 + viewCmmentBox.frame.size.height))];
    
    if (selectedPost.arrComments.count == 0)
    {
        lblImgVw.hidden = NO;
        cScrollVw.contentSize = CGSizeMake(0, viewLooksGuru.frame.origin.y + viewLooksGuru.frame.size.height + lblImgVw.frame.size.height + ((IS_IPAD) ? 20 : 10)) ;
    }
    else if (selectedPost.arrComments.count >= 1 && selectedPost.arrComments.count <= 6)
    {
        cScrollVw.contentSize = CGSizeMake(0, (selectedPost.arrComments.count * ((IS_IPAD)? 124 : 50)) + viewLooksGuru.frame.origin.y + viewLooksGuru.frame.size.height + 5);
    }
    else
    {
        cScrollVw.contentSize = CGSizeMake(0, tableVw.frame.origin.y + tableVw.frame.size.height + 5);
    }
    
    
    defaultFrame_imgLikeImg     = imgLikeImg.frame;
    defaultFrame_lblLikelbl =lblLikelbl.frame;
    defaultFrame_btnLike    =btnLike.frame;
    defaultFrame_imgDislike =imgDislike.frame;
    defaultFrame_lblDislike =lblDislike.frame;
    defaultFrame_btnDislike =btnDislike.frame;
    defaultFrame_imgCmtImage    =imgCmtImage.frame;
    defaultFrame_lblCmnt    =lblCmnt.frame;
    defaultFrame_btnCmment  =btnCmment.frame;
    defaultFrame_imgShare   =imgShare.frame;
    defaultFrame_btnShaere  =btnShaere.frame;
    
    
    btnSaveLook = [[UIButton alloc]initWithFrame:CGRectMake( defaultFrame_btnShaere.origin.x- 15*3, defaultFrame_btnShaere.origin.y, defaultFrame_btnShaere.size.width, defaultFrame_btnShaere.size.height)];
//        [self.view addSubview:btnSaveLook];
    btnSaveLook.hidden = true;
    
}

//- (void)btnNewsFeedClicked:(id)sender{
//    NSLog(@"btnNewsFeedClicked  :  ");
////    [tblPosts setContentOffset:CGPointZero animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)backSearchberClicked:(id)sender{
    NSLog(@"Search bar clicked :  ");
    
    UIViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSearchViewController"];
    [self.navigationController pushViewController:obj animated:NO];
    
    [self.view endEditing:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = scviewZoomImage.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / scviewZoomImage.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / scviewZoomImage.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    scviewZoomImage.minimumZoomScale = minScale;
    scviewZoomImage.maximumZoomScale = 1.0f;
    scviewZoomImage.zoomScale = minScale;
    
    [self centerScrollViewContents];
    
    if(cScrollVw.contentSize.height > cScrollVw.bounds.size.height && !isFromImage)
    {
        CGPoint bottomOffset = CGPointMake(0, cScrollVw.contentSize.height - cScrollVw.bounds.size.height);
        [cScrollVw setContentOffset:bottomOffset animated:YES];
    }
//    [cScrollVw scrollRectToVisible:CGRectMake(cScrollVw.contentSize.width - 1, cScrollVw.contentSize.height - 1, 1, 1) animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Looks Guru Comments Page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [tableVw reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    isCommentScreen = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


#pragma mark - User Likes Method

-(void)btnUserLikesClicked
{
    [self performSegueWithIdentifier:@"SeeLikes" sender:self];
}

#pragma mark - Report User Image

- (void)btnReportImageClicked
{
    alertForReport = [[UIAlertView alloc] initWithTitle:@"Report" message:@"Do you think that this look contains offensive content" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertForReport show];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && alertView == alertForReport)
    {
        NSLog(@"Report Image");
        [GMDCircleLoader setOnView:self.view withTitle:@"" animated:YES];
        [self performSelectorInBackground:@selector(reportUserLookToAdmin) withObject:nil];
    }
    else if(buttonIndex == 1 && alertView == alertForDeletionComment)
    {
        NSLog(@"Delete Comment");
        [GMDCircleLoader setOnView:self.view withTitle:@"" animated:YES];
        [self performSelectorInBackground:@selector(reportToDeleteComment) withObject:nil];
    }
    else
    {
        NSLog(@"Image not reported");
    }
}

#pragma mark - HTTP Request For Report Look

- (void)reportUserLookToAdmin
{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_REPORT_USER_LOOKS]];

    [request setPostValue:[loginData strUserId] forKey:@"user_id"];
    [request setPostValue:[selectedPost strPostId] forKey:@"post_id"];
    
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
            [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Thank you for reporting this look. Our team will review and take appropriate action soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to submit your report! Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        [GMDCircleLoader hideFromView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@",error);
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [CommonFunctions alertForNoInternetConnection];
    }];
    [request startAsynchronous];
}

#pragma mark - HTTP Request For Delete Comment

- (void)reportToDeleteComment
{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_DELETE_USER_COMMENT]];
    
    [request setPostValue:[selectedComment strCommentId] forKey:@"comment_id"];
    
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
            [[selectedPost arrComments] removeObject:selectedComment];
            rowCount--;
            [lblCmnt setText:[NSString stringWithFormat:@"%d", (int)[selectedPost.arrComments count]]];
            selectedPost.strCommentCount = [NSString stringWithFormat:@"%d", (int)[selectedPost.arrComments count]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableVw reloadData];
            });
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete your comment! Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        [GMDCircleLoader hideFromView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"%@",error);
        [GMDCircleLoader hideFromView:self.view animated:YES];
        [CommonFunctions alertForNoInternetConnection];
    }];
    [request startAsynchronous];
}

#pragma mark - Get Rect Size for Text

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

#pragma mark - Rate Now Button Clicked

- (void)btnRateNowClicked:(id)sender
{
    [self performSegueWithIdentifier:@"RateNow" sender:self];
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
    
    viewCmmentBox.frame = CGRectMake(viewCmmentBox.frame.origin.x, viewCmmentBox.frame.origin.y - (kbStartPosition.y - kbEndPosition.y), viewCmmentBox.frame.size.width, viewCmmentBox.frame.size.height);
    
}

- (CGFloat)getCustomHeightForEachElement:(LGPostData *)deal
{
    // Image Height Auto Adjustment
    int maxImgWidth = (IS_IPAD)? 768 : (IS_IPHONE_6_PLUS) ? 414 : (IS_IPHONE_6) ? 371 : 320;
    float oldWidth = maxImgWidth, oldHeight = (IS_IPAD)?542 : 210;
    if(deal.imgPostImage)
    {
        oldWidth = deal.imgPostImage.size.width;
        oldHeight = deal.imgPostImage.size.height;
    }
    float scaleFactor = maxImgWidth / oldWidth;
    float newHeight = oldHeight * scaleFactor;
    int finalHeight =  newHeight ;
   
    return finalHeight;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return imgZoomPostImage ;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
        [self centerScrollViewContents];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}


- (void)centerScrollViewContents
{
    CGSize boundsSize = scviewZoomImage.bounds.size;
    CGRect contentsFrame = imgZoomPostImage.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    imgZoomPostImage.frame = contentsFrame;
}

//
- (NSString *)getDifferenceFromToday:(NSString *)dateString
{
    NSDate *currentDate = [NSDate date];
    NSLog(@"%@", currentDate);
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromGivenDate = [f dateFromString:dateString];
    NSLog(@"%@",fromGivenDate);
    
    fromGivenDate = [CommonFunctions getLocalTimeWithDate:fromGivenDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                        fromDate:fromGivenDate
                                                          toDate:currentDate
                                                         options:0];
    
    NSLog(@"%d,%d,%d", components.hour, components.minute, components.second);
    
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
                        return [NSString stringWithFormat:@"%ds ago", (int)components.second];
                    }
                    else
                    {
                        return [NSString stringWithFormat:@"%dm %ds ago", (int)components.minute, (int)components.second];
                    }
                }
                else
                {
                    return [NSString stringWithFormat:@"%dh %dm ago", (int)components.hour, (int)components.minute];
                }
            }
            else
            {
                return [NSString stringWithFormat:@"%d %@ ago", (int)components.day, (components.day > 1) ? @"days":@"day"];
            }
        }
        else
        {
            f.dateFormat = @"MMM dd";
            NSLog(@"%@",[f stringFromDate:fromGivenDate]);
            return [NSString stringWithFormat:@"%@", [f stringFromDate:fromGivenDate]];
        }
    }
    else
    {
        f.dateFormat = @"MMM dd, YYYY";
        NSLog(@"%@",[f stringFromDate:fromGivenDate]);
        return [NSString stringWithFormat:@"%@", [f stringFromDate:fromGivenDate]];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel * nameLbl = (UILabel*)[cell viewWithTag:7];
    UILabel  *commntLbl = (UILabel *) [cell viewWithTag:8];
    UIImageView *imgTbleVw = (UIImageView *)[cell viewWithTag:6];
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:1];
    UILabel *lblPublishTime = (UILabel*)[cell viewWithTag:2];
    UIButton * btnLoadMore = (UIButton*)[cell viewWithTag:10];
    CustomButton *cbtnUserImage = (CustomButton *)[cell viewWithTag:3];
    UIImageView *imgTime = (UIImageView *)[cell viewWithTag:11];
    UIView *viewTimeContainer = (UIView *)[cell viewWithTag:12];
    
    CustomButton *cbtnDeleteComment = (CustomButton *)[cell viewWithTag:15];
    
    nameLbl.font = BRANDON_REGULAR_FONT((IS_IPAD)?25: 14);
    //commntLbl.font = BRANDON_FONT((IS_IPAD)?20: 11);
    [cbtnUserImage setHidden:NO];
    if (indexPath.row == rowCount - 1 && rowCount != selectedPost.arrComments.count)
    {
        [btnLoadMore addTarget:self action:@selector(btnLoadMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnLoadMore setHidden:NO];
    
        [nameLbl setHidden:YES];
        [commntLbl setHidden:YES];
        [imgTbleVw setHidden:YES];
        [indicator setHidden:YES];
        [lblPublishTime setHidden:YES];
        [imgTime setHidden:YES];
        [viewTimeContainer setHidden:YES];
        [cbtnDeleteComment setHidden:YES];
    }
    else
    {
        [btnLoadMore setHidden:YES];
        [nameLbl setHidden:NO];
        [commntLbl setHidden:NO];
        [imgTbleVw setHidden:NO];
        [indicator setHidden:NO];
        [lblPublishTime setHidden:NO];
        [imgTime setHidden:NO];
        [viewTimeContainer setHidden:NO];
        
        LGCommentsData *data = [selectedPost.arrComments objectAtIndex:indexPath.row];
        
        if([[data strUserid] isEqualToString:[loginData strUserId]] || [[selectedPost strUserId] isEqualToString:[loginData strUserId]])
        {
            [cbtnDeleteComment setHidden:NO];
            [cbtnDeleteComment setIndexPath:indexPath];
            [cbtnDeleteComment addTarget:self action:@selector(cbtnDeleteCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [cbtnDeleteComment setHidden:YES];
        }
        
        nameLbl.text = [data strUserName];
        NSString *strPublishTime = [self getDifferenceFromToday:data.strPublishDate];
        lblPublishTime.text = strPublishTime;

        CGSize maximumLabelSize = CGSizeMake(tableVw.frame.size.width - (IS_IPAD ? 400: 200), (IS_IPAD)? 40 : 20);
        CGRect titleRect = [self rectForText:strPublishTime
                                   usingFont:[lblPublishTime font]
                               boundedBySize:maximumLabelSize];
        int x = (cell.frame.size.width - (titleRect.size.width + imgTime.frame.size.width + (IS_IPAD ? 10 : 5)));
        NSLog(@"X value %ld: %f, %f, %d", indexPath.row, cell.frame.size.width ,  cell.frame.size.width, x);
        [viewTimeContainer setFrame:CGRectMake(x - (IS_IPAD ? 10 : 5), viewTimeContainer.frame.origin.y, (titleRect.size.width + imgTime.frame.size.width + (IS_IPAD ? 10 : 5)), viewTimeContainer.frame.size.height)];
        imgTime.frame = CGRectMake(0, imgTime.frame.origin.y, imgTime.frame.size.width, imgTime.frame.size.height);
        lblPublishTime.frame = CGRectMake(imgTime.frame.origin.x + imgTime.frame.size.width + (IS_IPAD ? 10 : 5), lblPublishTime.frame.origin.y, titleRect.size.width, lblPublishTime.frame.size.height);
        
        commntLbl.text = [data strComment];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            if (![data.strUserImgURL containsString:URL_MAIN])
            {
                data.strUserImgURL = [NSString stringWithFormat:@"%@/%@", URL_MAIN,[data strUserImgURL]];
            }
        }
        else
        {
            if (!([data.strUserImgURL rangeOfString:URL_MAIN].location == NSNotFound))
            {
                data.strUserImgURL = [NSString stringWithFormat:@"%@/%@", URL_MAIN,[data strUserImgURL]];
            }
        }
        imgTbleVw.layer.cornerRadius = imgTbleVw.frame.size.width/2;
        imgTbleVw.layer.borderWidth = 1.0;
        imgTbleVw.layer.borderColor = [UIColor whiteColor].CGColor;
        
        if (data.strUserImgURL.length > 0)
        {
            if (!data.imgUserImg)
            {
                [self startIconDownload:data forIndexPath:indexPath];
                indicator.hidden = NO;
                imgTbleVw.image = nil;
                [indicator startAnimating];
            }
            else
            {
                [indicator stopAnimating];
                indicator.hidden = YES;
                [imgTbleVw setImage:data.imgUserImg];
                [cbtnUserImage setIndexPath:indexPath];
                [cbtnUserImage addTarget:self action:@selector(btnOpenUserLooks:) forControlEvents:UIControlEventTouchUpInside];
                [cell bringSubviewToFront:cbtnUserImage];
            }
        }
        
//        if (IS_IPHONE_6)
//        {
//            lblPublishTime.frame = CGRectMake(self.view.frame.size.width-(lblPublishTime.frame.size.width+10), lblPublishTime.frame.origin.y, lblPublishTime.frame.size.width, lblPublishTime.frame.size.height);
//        }
//        
//        if (IS_IPHONE_5)
//        {
//            lblPublishTime.frame = CGRectMake(self.view.frame.size.width-(lblPublishTime.frame.size.width+10), lblPublishTime.frame.origin.y, lblPublishTime.frame.size.width, lblPublishTime.frame.size.height);
//        }
//        
//        if (IS_IPHONE_6_PLUS)
//        {
//            lblPublishTime.frame = CGRectMake(self.view.frame.size.width-(lblPublishTime.frame.size.width+10), lblPublishTime.frame.origin.y, lblPublishTime.frame.size.width, lblPublishTime.frame.size.height);
//        }
    }
    
    return cell;
}

-(void)downLoadImage
{
    if(selectedPost.imgPostImage)
    {
        imgPostImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[selectedPost strPostImage]]]];
    }
    isDownloaded = true;
    indector.hidden = YES;
    [indictorFullImage stopAnimating];
    [self downloadFullsizeImages];
//    dispatch_async(dispatch_get_main_queue(), ^{
////        selectedPost.imgPostImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[selectedPost strPostImage]]]];
//        
//        isDownloaded = true;
//        indector.hidden = YES;
//        [indictorFullImage stopAnimating];
//        [self downloadFullsizeImages];
//    });
}

- (void)cbtnDeleteCommentClicked:(id)sender
{
    NSLog(@"Comment deleted......");
    CustomButton *btn = sender;
    //selectedIndex = btn.indexPath.row;
    
    selectedComment = [[selectedPost arrComments] objectAtIndex:btn.indexPath.row];
    
    alertForDeletionComment = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Do you really want to delete this comment!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertForDeletionComment show];
}

- (void)btnOpenUserLooks:(id)sender
{
    CustomButton *btn = sender;
    //selectedIndex = btn.indexPath.row;
    
    selectedComment = [[selectedPost arrComments] objectAtIndex:btn.indexPath.row];
    isCommentUserList = YES;
    [self performSegueWithIdentifier:@"ShowUserLooks" sender:self];
}

-(IBAction)btnUserImgClicked:(id)sender
{
    if (selectedPost.strUserId != nil && loginData.strUserId != selectedPost.strUserId)
    {
        isCommentUserList = NO;
        [self performSegueWithIdentifier:@"ShowUserLooks" sender:self];
    }
}

-(void)commentButtonClicked:(id)sender
{
    
    UITableViewCell *cell = [[NSUserDefaults standardUserDefaults] objectForKey:@"cell"];
    
    NSIndexPath *index = [self.tblViewRefer indexPathForCell:cell];
    
    selectedPost = [arrPosts objectAtIndex:index.row];
       
   // [self performSegueWithIdentifier:@"showComment" sender:self];
}


-(void)likePhotoClicked:(id)sender
{
   
//    if (selectedPost.isDislike)
//    {
//        int dlcount = [[selectedPost strDislikeCount] intValue] - 1;
//        selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d", dlcount];
//        selectedPost.isDislike = false;
//        
//        
//    }
//    int lcounts = [[selectedPost strLikeCount] intValue] + 1;
//    selectedPost.strLikeCount = [NSString stringWithFormat:@"%d",lcounts];
//    selectedPost.isLike = true;

//    lblDislike.text = selectedPost.strDislikeCount;
    
    
//    selectedPost = [arrPosts objectAtIndex:btn.indexPath.row];
    if (selectedPost.isLike) {

            int lcount = [[selectedPost strLikeCount] intValue] - 1;
            selectedPost.strLikeCount = [NSString stringWithFormat:@"%d", lcount];
            selectedPost.isLike = false;
            lblLikelbl.text = selectedPost.strLikeCount;
        
        [self performSelectorInBackground:@selector(UNlikePhoto) withObject:nil];
        
    }
    else {
      
        int lcounts = [[selectedPost strLikeCount] intValue] + 1;
        selectedPost.strLikeCount = [NSString stringWithFormat:@"%d",lcounts];
        selectedPost.isLike = true;
         lblLikelbl.text = selectedPost.strLikeCount;
        
        if (selectedPost.isDislike)
                {
                    int dlcount = [[selectedPost strDislikeCount] intValue] - 1;
                    selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d", dlcount];
                    selectedPost.isDislike = false;
                    lblDislike.text = selectedPost.strDislikeCount;
                }
        
        [self performSelectorInBackground:@selector(likePhoto) withObject:nil];
        
    }

    
    
    if(selectedPost.isLike)
    {
        
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
        [imgLikeImg  setImage:[UIImage imageNamed:@"like1.png"]];
        [imgDislike  setImage:[UIImage imageNamed:@"dislike.png"]];
    }
//    else if (selectedPost.isDislike)
//    {
//        [btnLike setUserInteractionEnabled:YES];
//        [btnDislike setUserInteractionEnabled:NO];
//        [imgLikeImg  setImage:[UIImage imageNamed:@"like.png"]];
//        [imgDislike  setImage:[UIImage imageNamed:@"disliked.png"]];
//    }
    
    else
    {
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
        [imgLikeImg  setImage:[UIImage imageNamed:@"like.png"]];
        
        if (selectedPost.isDislike)
            {
                [btnLike setUserInteractionEnabled:YES];
                [btnDislike setUserInteractionEnabled:YES];
                [imgLikeImg  setImage:[UIImage imageNamed:@"like.png"]];
                [imgDislike  setImage:[UIImage imageNamed:@"disliked.png"]];
            }

    }

//    [self performSelectorInBackground:@selector(likePhoto) withObject:nil];
}

-(void)likePhoto
{
    
    if (isAlreadyRequsted)
    {
        return;
        
    }
    isAlreadyRequsted = YES;
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_LIKE_UNLIKE]];     [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    [request setPostValue:@"1" forKey:@"post_like"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(likePhotoFail:)];
    [request setDidFinishSelector:@selector(likePhotoSuccess:)];
    [request startSynchronous];
}

- (void)likePhotoSuccess:(ASIHTTPRequest *)request
{
    
    isAlreadyRequsted = NO;
    
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
    
    isAlreadyRequsted = NO;
}

-(void)UNlikePhoto
{
    
    if (isAlreadyRequsted)
    {
        return;
        
    }
    isAlreadyRequsted = YES;

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_LIKE_UNLIKE]];     [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    [request setPostValue:@"0" forKey:@"post_like"];
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(UNlikePhotoFail:)];
    [request setDidFinishSelector:@selector(UNlikePhotoSuccess:)];
    [request startSynchronous];
}

- (void)UNlikePhotoSuccess:(ASIHTTPRequest *)request
{
    
    isAlreadyRequsted = NO;
    
    if(![loginData.strUserId isEqualToString:selectedPost.strUserId])
    {
//        NSMutableDictionary *pushDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[loginData strUserId], @"sender_id", [selectedPost strUserId], @"receiver_id", [NSString stringWithFormat:@"%@ likes your awesome look.", loginData.strDisplayName], @"message", @"Like", @"key", selectedPost.strPostId, @"post_id", nil];
//        [[LGRestInteraction restInteractionManager] sendPushNotification:pushDict];
    }
}

#pragma mark
#pragma mark - myMethods

-(void)movePostViewUP:(BOOL)direction
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    
//    if(direction)
//    {
////        if(IS_IPAD)
////            moveFactor = -264;
////        else
////            moveFactor = -216;
//        moveFactor = keyboardHeight * - 1;
//    }
//    else
//    {
////        if(IS_IPAD)
////            moveFactor = 264;
////        else
////            moveFactor = 216;
//        moveFactor = keyboardHeight;
//    }
////    if (moveFactor<0)
////    {
////        moveFactor -=36;
////    }
////    else
////    {
////        moveFactor +=36;
////    }
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 9.0)
//    {
////        if (moveFactor < 0)
////        {
////            moveFactor -= (IS_IPAD) ? 48 : 36;
////        }
////        else
////        {
////            moveFactor += (IS_IPAD) ? 48 : 36;
////        }
//    }
//    
//    viewCmmentBox.frame = CGRectMake(viewCmmentBox.frame.origin.x, viewCmmentBox.frame.origin.y + moveFactor, viewCmmentBox.frame.size.width, viewCmmentBox.frame.size.height);
//    
//    [UIView commitAnimations];
}

- (void)UNlikePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",error);
    });
    
    isAlreadyRequsted = NO;
}


-(void)dislikePhotoClicked:(id)sender
{
//    if (selectedPost.isLike)
//    {
//        int lcount = [[selectedPost strLikeCount] intValue] - 1;
//        selectedPost.strLikeCount = [NSString stringWithFormat:@"%d", lcount];
//        selectedPost.isLike = false;
//        
//        
//    }
//    int dlcounts = [[selectedPost strDislikeCount] intValue] + 1;
//    selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d",dlcounts];
//    selectedPost.isDislike = true;
//    lblLikelbl.text = selectedPost.strLikeCount;
//    lblDislike.text = selectedPost.strDislikeCount;
    
    //    if([[NSString stringWithFormat:@"%@", [[results objectAtIndex:i] objectForKey:@"like"]] isEqualToString:@"0"])
    //    {
    //        selectedPost.isLike = NO;
    //    }
    //    else
    //    {
    //        selectedPost.isLike = YES;
    //    }
    
    
    if (selectedPost.isDislike) {
        int dlcount = [[selectedPost strDislikeCount] intValue] - 1;
        selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d", dlcount];
        selectedPost.isDislike = false;
         lblDislike.text = selectedPost.strDislikeCount;
        [self performSelectorInBackground:@selector(likePhoto) withObject:nil];
    }
    
    else {
        int dlcounts = [[selectedPost strDislikeCount] intValue] + 1;
        selectedPost.strDislikeCount = [NSString stringWithFormat:@"%d",dlcounts];
        selectedPost.isDislike = true;
         lblDislike.text = selectedPost.strDislikeCount;
        if (selectedPost.isLike)
                {
                    int lcount = [[selectedPost strLikeCount] intValue] - 1;
                    selectedPost.strLikeCount = [NSString stringWithFormat:@"%d", lcount];
                    selectedPost.isLike = false;
                    lblLikelbl.text = selectedPost.strLikeCount;
                    
                }
        
        [self performSelectorInBackground:@selector(UNlikePhoto) withObject:nil];
    }
    
//    
//    if(selectedPost.isLike)
//    {
//        [btnLike setUserInteractionEnabled:NO];
//        [btnDislike setUserInteractionEnabled:YES];
//        [imgLikeImg  setImage:[UIImage imageNamed:@"like1.png"]];
//        [imgDislike  setImage:[UIImage imageNamed:@"dislike.png"]];
//    }
//    else
    
        if (selectedPost.isDislike)
    {
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
        [imgLikeImg  setImage:[UIImage imageNamed:@"like.png"]];
        [imgDislike  setImage:[UIImage imageNamed:@"disliked.png"]];
    }
    
    else
    {
        [btnLike setUserInteractionEnabled:YES];
        [btnDislike setUserInteractionEnabled:YES];
         [imgDislike  setImage:[UIImage imageNamed:@"dislike.png"]];
        if(selectedPost.isLike)
                {
                    [btnLike setUserInteractionEnabled:YES];
                    [btnDislike setUserInteractionEnabled:YES];
                    [imgLikeImg  setImage:[UIImage imageNamed:@"like1.png"]];
                    [imgDislike  setImage:[UIImage imageNamed:@"dislike.png"]];
                }
    }

//    [self performSelectorInBackground:@selector(dislikePhoto) withObject:nil];
}


-(void)dislikePhoto
{
    
    if (isAlreadyRequsted)
    {
        return;
        
    }
    isAlreadyRequsted = YES;

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
    isAlreadyRequsted = NO;

}




- (void)dislikePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", error);
    });
    
    isAlreadyRequsted = NO;
    
}

-(void)UNdislikePhoto
{
    
    if (isAlreadyRequsted)
    {
        return;
        
    }
    isAlreadyRequsted = YES;
    
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
    isAlreadyRequsted = NO;
}




- (void)UNdislikePhotoFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", error);
    });
    
    isAlreadyRequsted = NO;
    
}


-(void)btnLoadMoreClicked:(id)sender
{
    if (rowCount + 10 < selectedPost.arrComments.count)
    {
        rowCount = rowCount + 10 + 1;
    }
    else
    {
        rowCount = selectedPost.arrComments.count;
    }
    [tableVw reloadData];
    
}

-(IBAction)cmtBtnClicked:(id)sender
{
    BOOL isValid = YES;
    if (cmntText.text.length==0 || ![CommonFunctions checkForOnlySpaces:cmntText])
    {
        isValid = NO;
        LGAlertMessage *alert;
        for(int i = 0; i < [arrAlertMessages count]; i++)
        {
            alert = [arrAlertMessages objectAtIndex:i];
            if([[alert strALertType] isEqualToString:@"please insert comment"])
            {
                break;
            }
        }
        
        [[[UIAlertView alloc]initWithTitle:alert.strAlertTitle message:alert.strAlertContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
        
    }
    else
    {
        [GMDCircleLoader setOnView:self.view withTitle:@"" animated:YES];
        
        [cmntText resignFirstResponder];
        [self performSelectorInBackground:@selector(addComment) withObject:nil];
    }
}
-(void)addComment
{   
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:urlComments];
    
    NSDate *dt = [NSDate date];
    
    NSDate *currentDate = [CommonFunctions getCurrentGMTTime];
    
    NSLog(@"%@%@", dt, currentDate);
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [request setPostValue:[f stringFromDate:currentDate] forKey:@"publish_date"];

    [request setPostValue:loginData.strUserId forKey:@"user_id"];
    [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    
    NSData *data = [cmntText.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    goodValue = [goodValue stringByReplacingOccurrencesOfString:@"\\" withString:@"-@-"];
    //NSString *goodValue = [cmntText.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    goodValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                    (CFStringRef)[cmntText text],
                                                                                    NULL,
                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                    kCFStringEncodingUTF8 ));
    
    [request setPostValue:goodValue forKey:@"comment"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddCommentFail:)];
    [request setDidFinishSelector:@selector(requestAddCommentSuccess:)];
    
    [request setTimeOutSeconds:99999999999];
    [request startSynchronous];

}

-(void)requestAddCommentFail:(ASIFormDataRequest *)request
{
    [GMDCircleLoader hideFromView:self.view animated:YES];
    NSLog(@"%@", request.responseString);
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [CommonFunctions alertForNoInternetConnection];
                   });
}


-(void)requestAddCommentSuccess:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    SBJSON *parser = [[SBJSON alloc]init];
    
    
    NSMutableDictionary *results = [parser objectWithString:responseString error:nil];
    
    NSString *strResult = [results objectForKey:@"result"];
    NSString *strMessage = [results objectForKey:@"message"];
    
    
    dictUserData = [[NSMutableDictionary alloc] init];
    
   [GMDCircleLoader hideFromView:self.view animated:YES];
    if([strResult isEqualToString:@"success"])
    {
        NSString *strCommentId = [results objectForKey:@"comment_id"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           NSDate *dt = [NSDate date];
                           
                           NSDate *currentDate = [CommonFunctions getCurrentGMTTime];
                           
                           NSLog(@"%@%@", dt, currentDate);
                           
                           NSDateFormatter *f = [[NSDateFormatter alloc] init];
                           [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                           
                           LGCommentsData *data = [[LGCommentsData alloc] init];
                           data.strComment = cmntText.text;

                           data.strCommentId = strCommentId;
                           data.strUserImgURL = loginData.strUserProfile;
                           data.strUserName = loginData.strDisplayName;
                           data.strPublishDate = [f stringFromDate:currentDate];
                           data.strUserid = loginData.strUserId;
                           data.strPostId = selectedPost.strPostId;
                           
                           cmntText.text = @"";
                        
                           [[selectedPost arrComments] insertObject:data atIndex:0];
                           
                           selectedPost.strCommentCount = [NSString stringWithFormat:@"%d", (int)[selectedPost.arrComments count]];
                           
                           if (selectedPost.arrComments.count > 10)
                           {
                               rowCount = 10 + 1;
                           }
                           else
                           {
                               rowCount = selectedPost.arrComments.count;
                           }
                           
                           if (selectedPost.arrComments.count >= 1 && selectedPost.arrComments.count <= 6)
                           {
                               cScrollVw.contentSize = CGSizeMake(0, (selectedPost.arrComments.count * ((IS_IPAD)? 124 : 50)) + viewLooksGuru.frame.origin.y + viewLooksGuru.frame.size.height + 5);
                           }
                           else
                           {
                               cScrollVw.contentSize = CGSizeMake(0, tableVw.frame.origin.y + tableVw.frame.size.height + 5);
                           }
                        
                           lblImgVw.hidden = YES;
                           lblCmnt.text = [NSString stringWithFormat:@"%d", (int)[selectedPost.arrComments count]];
                           [tableVw reloadData];
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                           
                           if(![loginData.strUserId isEqualToString:selectedPost.strUserId])
                           {
//                               NSMutableDictionary *pushDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[loginData strUserId], @"sender_id", [selectedPost strUserId], @"receiver_id", [NSString stringWithFormat:@"%@ commented on your awesome look.", loginData.strDisplayName], @"message", @"Comment", @"key",selectedPost.strPostId, @"post_id", nil];
//                               [[LGRestInteraction restInteractionManager] sendPushNotification:pushDict];
                           }
                       });
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[[UIAlertView alloc] initWithTitle:@"" message:@"Failed to add comment!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                           
                           [GMDCircleLoader hideFromView:self.view animated:YES];
                       });
    }
}

//- (IBAction)btnShowImage:(id)sender
//{
//    if (isDownloaded)
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        
//        [cmntText resignFirstResponder];
//        
//        // [self centerScrollViewContents];
//        
//        [self.view bringSubviewToFront:viewShowImage];
//        [self.view bringSubviewToFront:btnClose];
//        
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        
//        viewShowImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        
//        [imgZoomPostImage setImage:imgPostImage.image];
//        
//        
//        [UIView commitAnimations];
//        [btnClose setHidden:NO];
//        [viewShowImage setHidden:NO];
//    }
//    else
//    {
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Loading image..." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//
//    }
//    
//}

- (IBAction)btnShowImage:(id)sender
{
    if (isDownloaded)
    {
        CGFloat FrameY = [UIScreen mainScreen].bounds.size.height - 35;
        
//        [btnClose setHidden:NO];
//        [viewShowImage setHidden:NO];
         [viewFooter setHidden:YES];
        btnSaveLook.hidden = false;
        
        [indictorFullImage startAnimating];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
        [cmntText resignFirstResponder];
        
        // [self centerScrollViewContents];
        
        [self.view bringSubviewToFront:viewShowImage];
        [self.view bringSubviewToFront:btnClose];
        
        [self.view bringSubviewToFront:imgLikeImg];
        [self.view bringSubviewToFront:lblLikelbl];
        [self.view bringSubviewToFront:btnLike];
        [self.view bringSubviewToFront:imgDislike];
        [self.view bringSubviewToFront:lblDislike];
        [self.view bringSubviewToFront:btnDislike];
        [self.view bringSubviewToFront:imgCmtImage];
        [self.view bringSubviewToFront:lblCmnt];
        [self.view bringSubviewToFront:btnCmment];
        [self.view bringSubviewToFront:imgShare];
        [self.view bringSubviewToFront:btnShaere];
        [self.view bringSubviewToFront:btnSaveLook];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        
        CGRect Frame_imgLikeImg =  imgLikeImg.frame;
        Frame_imgLikeImg.origin.y = FrameY;
        imgLikeImg.frame = Frame_imgLikeImg;
        
        CGRect Frame_lblLikelbl = lblLikelbl.frame;
        Frame_lblLikelbl.origin.y = FrameY;
        lblLikelbl.frame = Frame_lblLikelbl;
        
        CGRect Frame_btnLike =  btnLike.frame;
        Frame_btnLike.origin.y = FrameY;
        btnLike.frame = Frame_btnLike;
        
        CGRect Frame_imgDislike = imgDislike.frame;
        Frame_imgDislike.origin.y = FrameY;
         Frame_imgDislike.origin.x = Frame_imgDislike.origin.x - 15;
        imgDislike.frame = Frame_imgDislike;
        
        CGRect Frame_lblDislike = lblDislike.frame;
        Frame_lblDislike.origin.y = FrameY;
        Frame_lblDislike.origin.x = Frame_lblDislike.origin.x - 15;
        lblDislike.frame = Frame_lblDislike;
        
        CGRect Frame_btnDislike = btnDislike.frame;
        Frame_btnDislike.origin.y = FrameY;
        Frame_btnDislike.origin.x = Frame_btnDislike.origin.x - 15;
        btnDislike.frame = Frame_btnDislike;
        
        CGRect Frame_imgCmtImage = imgCmtImage.frame;
        Frame_imgCmtImage.origin.y = FrameY + 2;
         Frame_imgCmtImage.origin.x = Frame_imgCmtImage.origin.x - 15*2;
        imgCmtImage.frame = Frame_imgCmtImage;
        
        CGRect Frame_lblCmnt = lblCmnt.frame;
        Frame_lblCmnt.origin.y = FrameY;
         Frame_lblCmnt.origin.x = Frame_lblCmnt.origin.x - 15*2;
        lblCmnt.frame = Frame_lblCmnt;
        
        CGRect Frame_btnCmment = btnCmment.frame;
        Frame_btnCmment.origin.y = FrameY;
         Frame_btnCmment.origin.x = Frame_btnCmment.origin.x - 15*2;
        btnCmment.frame = Frame_btnCmment;
        
        CGRect Frame_imgShare = imgShare.frame;
        Frame_imgShare.origin.y = FrameY;
        imgShare.frame = Frame_imgShare;
        
        CGRect Frame_btnShaere = btnShaere.frame;
        Frame_btnShaere.origin.y = FrameY;
        btnShaere.frame = Frame_btnShaere;
        
        
        UIView *viewbg = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ((IS_IPAD) ? 65 : 50), [UIScreen mainScreen].bounds.size.width, (IS_IPAD) ? 65 : 50)];
        viewbg.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:17.0/255.0 blue:33.0/255.0 alpha:1.0];
         [viewShowImage addSubview:viewbg];
        
        if ([UIScreen mainScreen].bounds.size.width == 320) {
             btnSaveLook.frame = CGRectMake( Frame_btnShaere.origin.x- 47, Frame_btnShaere.origin.y, Frame_btnShaere.size.width, Frame_btnShaere.size.height);
        }
        else if ([UIScreen mainScreen].bounds.size.width == 375) {
             btnSaveLook.frame = CGRectMake( Frame_btnShaere.origin.x- 50, Frame_btnShaere.origin.y, Frame_btnShaere.size.width, Frame_btnShaere.size.height);
        }
        else if ([UIScreen mainScreen].bounds.size.width == 414) {
             btnSaveLook.frame = CGRectMake( Frame_btnShaere.origin.x - 66, Frame_btnShaere.origin.y, Frame_btnShaere.size.width, Frame_btnShaere.size.height);
        }
        else if ([UIScreen mainScreen].bounds.size.width == 768) {
             btnSaveLook.frame = CGRectMake( Frame_btnShaere.origin.x- 100, Frame_btnShaere.origin.y, Frame_btnShaere.size.width, Frame_btnShaere.size.height);
        }
        else
        {
             btnSaveLook.frame = CGRectMake( Frame_btnShaere.origin.x- 15*6, Frame_btnShaere.origin.y, Frame_btnShaere.size.width, Frame_btnShaere.size.height);
        
        }
       
        btnSaveLook.backgroundColor = [UIColor clearColor];
        btnSaveLook.imageEdgeInsets = UIEdgeInsetsMake((IS_IPAD)? 5 : 2, (IS_IPAD)? 30 : 16, (IS_IPAD)? 10 : 2, (IS_IPAD)? 30 : 16);
        if (selectedPost.isSave) {
            [btnSaveLook setImage:[UIImage imageNamed:@"filledstar.png"] forState:UIControlStateNormal];
        }
        else {
            
            [btnSaveLook setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        }
        btnSaveLook.hidden = false;
        [btnSaveLook addTarget:self action:@selector(saveLookClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:imgLikeImg];
        [self.view addSubview:lblLikelbl];
        [self.view addSubview:btnLike];
        [self.view addSubview:imgDislike];
        [self.view addSubview:lblDislike];
        [self.view addSubview:btnDislike];
        [self.view addSubview:imgCmtImage];
        [self.view addSubview:lblCmnt];
        [self.view addSubview:btnCmment];
        [self.view addSubview:imgShare];
        [self.view addSubview:btnShaere];
        
        [self.view addSubview:btnSaveLook];
        
        viewShowImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        imgZoomPostImage.frame = CGRectMake(0, 25, self.view.frame.size.width , self.view.frame.size.height-75);
        
        [imgZoomPostImage setImage:imgPostImage.image];
        
        [UIView commitAnimations];
        [btnClose setHidden:NO];
        [viewShowImage setHidden:NO];
        
//        [self performSelectorInBackground:@selector(downLoadImage) withObject:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Loading image..." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)downloadFullsizeImages
{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    
//    [cmntText resignFirstResponder];
//    
//    // [self centerScrollViewContents];
//    
////    [self.view bringSubviewToFront:viewShowImage];
////    [self.view bringSubviewToFront:btnClose];
//    
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    
//    viewShowImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [imgZoomPostImage setImage:imgPostImage.image];
    
    
//    [UIView commitAnimations];
//    [btnClose setHidden:NO];
//    [viewShowImage setHidden:NO];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    cmntText.tag = 1;
    
    [self.view bringSubviewToFront:viewCmmentBox];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    cmntText.tag = 2;
    [self movePostViewUP:NO];
    keyboardHeight = 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [cmntText resignFirstResponder];
    
    if(cmntText.tag == 1)
    {
        [self movePostViewUP:NO];
        keyboardHeight = 0;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [cmntText resignFirstResponder];
    return YES;
}

- (void)startIconDownload:(LGCommentsData *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        stopDownload = NO;
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.commentData = appRecord;
        [iconDownloader setCompletionHandler:^{
            if (!stopDownload) {
                UITableViewCell *cell = [tableVw cellForRowAtIndexPath:indexPath];
                UIImageView *imageView = (UIImageView *)[cell viewWithTag:6];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:1];
                CustomButton *cbtnUserImage = (CustomButton *)[cell viewWithTag:3];
                
                [indicator stopAnimating];
                indicator.hidden = YES;
                
                {
                    CGSize newSize = [CommonFunctions getCustomHeightForProfilePic:appRecord.imgUserImg];
                    NSLog(@"New Height: %f %f", newSize.width, newSize.height);
                    
                    appRecord.imgUserImg = [CommonFunctions imageWithImage:appRecord.imgUserImg scaledToSize:newSize];

                    [imageView setImage:appRecord.imgUserImg];
                    [cbtnUserImage setIndexPath:indexPath];
                    [cbtnUserImage addTarget:self action:@selector(btnOpenUserLooks:) forControlEvents:UIControlEventTouchUpInside];
                    [cell bringSubviewToFront:cbtnUserImage];
                }
                
                [imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                imageView.clipsToBounds = YES;
                
                [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            }else
            {
                appRecord.imgUserImg = nil;
            }
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (IBAction)btnHideImage:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];    
  
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
     [viewFooter setHidden:YES];
    
     btnSaveLook.frame =CGRectMake( defaultFrame_btnShaere.origin.x- 15*3, defaultFrame_btnShaere.origin.y, defaultFrame_btnShaere.size.width, defaultFrame_btnShaere.size.height);
    
    viewShowImage.frame = CGRectMake(imgPostImage.frame.size.width/2,(imgPostImage.frame.size.height/2)+(imgPostImage.frame.origin.y)+(viewHeader.frame.size.height), 1, 1);
    
          imgLikeImg.frame = defaultFrame_imgLikeImg;
     lblLikelbl.frame =defaultFrame_lblLikelbl;
        btnLike.frame =defaultFrame_btnLike;
     imgDislike.frame =defaultFrame_imgDislike;
     lblDislike.frame =defaultFrame_lblDislike;
     btnDislike.frame =defaultFrame_btnDislike;
        imgCmtImage.frame =defaultFrame_imgCmtImage;
        lblCmnt.frame =defaultFrame_lblCmnt;
      btnCmment.frame =defaultFrame_btnCmment;
       imgShare.frame =defaultFrame_imgShare;
      btnShaere.frame =defaultFrame_btnShaere;
    
    
    [viewShare addSubview:imgLikeImg];
    [viewShare addSubview:lblLikelbl];
    [viewShare addSubview:btnLike];
    [viewShare addSubview:imgDislike];
    [viewShare addSubview:lblDislike];
    [viewShare addSubview:btnDislike];
    [viewShare addSubview:imgCmtImage];
    [viewShare addSubview:lblCmnt];
    [viewShare addSubview:btnCmment];
    [viewShare addSubview:imgShare];
    [viewShare addSubview:btnShaere];
   
    [btnClose setHidden:YES];
    [btnSaveLook setHidden:YES];
    
    [UIView commitAnimations];
    
    imgZoomPostImage.frame = defaultFrame;
    
    CGRect scrollViewFrame = scviewZoomImage.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / imgPostImage.image.size.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / imgPostImage.image.size.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    scviewZoomImage.minimumZoomScale = minScale;
    scviewZoomImage.maximumZoomScale = 1.0f;
    scviewZoomImage.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)cbtnShareClicked:(id)sender
{
    if([CommonFunctions isConnectedToInternet])
    {
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

//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    {
//        slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        __weak typeof(self) bself = self;
//        [slComposerSheet setInitialText:[NSString stringWithFormat:@"Checkout my new look \n %@ \n %@", selectedPost.strDisplayName, selectedPost.strAboutLook]];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowUserLooks"] && isCommentUserList)
    {
        LGUserLooksViewController * userlooks = (LGUserLooksViewController *) [segue destinationViewController];
        userlooks.selectedCommentData = selectedComment;
        userlooks.isCommentUserLIst = isCommentUserList;
        userlooks.selectedpost = [[LGPostData alloc] init];
        userlooks.selectedpost.strUserId = selectedComment.strUserid;
        userlooks.selectedpost.strUserImg = selectedComment.strUserImgURL;
        userlooks.selectedpost.imgUserImage = selectedComment.imgUserImg;
        userlooks.selectedpost.strDisplayName = selectedComment.strUserName;
    }
    else if ([[segue identifier] isEqualToString:@"ShowUserLooks"])
    {
        LGUserLooksViewController * userlooks = (LGUserLooksViewController *) [segue destinationViewController];
        userlooks.selectedpost = selectedPost;
        userlooks.isCommentUserLIst = isCommentUserList;
    }
    else if ([[segue identifier] isEqualToString:@"RateNow"])
    {
        LGRatingsViewController *rating = (LGRatingsViewController *)[segue destinationViewController];
        rating.dictRateData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:selectedPost.strPostId, @"id", selectedPost.strPostImage, @"image", selectedPost.strMediumThumbURL, @"image_400", selectedPost.strUserId, @"user_id", selectedPost.strSmallThumbURL, @"image_200", nil];
        rating.isComingFromCommentScreenToRate = YES;
    }
    else if ([[segue identifier] isEqualToString:@"SeeLikes"])
    {
        LGUserLikesViewController *likesVC = (LGUserLikesViewController *)[segue destinationViewController];
        likesVC.strSelectedPostID = selectedPost.strPostId;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadTopCustomView
{
    int lastX = 0;
    float widthTotal = 0;
    NSMutableArray *arrAvailableTags = (NSMutableArray *)[[selectedPost strImageTags] componentsSeparatedByString:@","];
    for(int i = 0; i < [arrAvailableTags count]; i++)
    {
        CGSize maximumLabelSize = CGSizeMake((IS_IPAD)? 450 : 300, scviewSelectedTags.frame.size.height - 5);
        CGRect titleRect = [self  rectForText:[arrAvailableTags objectAtIndex:i]
                                    usingFont:[UIFont fontWithName:@"Helvetica-Bold" size:(IS_IPAD)?25: 10.0]
                                boundedBySize:maximumLabelSize];
        widthTotal += (titleRect.size.width + ((IS_IPAD)? 39 : 25));
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(lastX, 2, titleRect.size.width + ((IS_IPAD)? 30 : 20), scviewSelectedTags.frame.size.height - 5)];
        [scviewSelectedTags addSubview:view];
        [view setClipsToBounds:YES];
        [[view layer] setCornerRadius: view.frame.size.height / 2];
        [[view layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [[view layer] setBorderWidth:((IS_IPAD)? 1.0 : 0.5)];
        [[view layer] setBackgroundColor:[[UIColor colorWithRed:141.0/255.0 green:86.0/255.0 blue:136.0/255.0 alpha:0.8] CGColor]];
        [view setTag: 1000 + i];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(((IS_IPAD)? 15 : 10), 0, titleRect.size.width, scviewSelectedTags.frame.size.height - 5)];
        [lbl setText:[arrAvailableTags objectAtIndex:i]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:(IS_IPAD)?25: 10.0]];
        [view addSubview:lbl];
        
        UIButton *btnClose1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [btnClose1 setTitle:@"" forState:UIControlStateNormal];
        [btnClose1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnClose1 setClipsToBounds:YES];
        [[btnClose1 layer] setCornerRadius:17.5];
        [view addSubview:btnClose1];
        [btnClose setTag: 1000 + i];
        //[btnClose addTarget:self action:@selector(btnTagSelectedClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        lastX = lastX + titleRect.size.width + ((IS_IPAD)? 39 : 25);
    }
    [scviewSelectedTags setContentSize:CGSizeMake(widthTotal, 0)];
}

#pragma mark Save look
-(void)saveLookClicked:(id)sender
{
    if (selectedPost.isSave) {
        [btnSaveLook setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        
        [self performSelectorInBackground:@selector(saveLook:) withObject:@"0"];
        selectedPost.isSave = NO;
    }
    else {
        
        [btnSaveLook setImage:[UIImage imageNamed:@"filledstar.png"] forState:UIControlStateNormal];
        selectedPost.isSave = YES;
        [self performSelectorInBackground:@selector(saveLook:) withObject:@"1"];
    }
}
-(void)saveLook:(NSString*)saveValue
{
    
    if (isAlreadyRequsted)
    {
        return;
        
    }
    isAlreadyRequsted = YES;
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SAVE_UNSAVE]];   [request setPostValue:loginData.strUserId forKey:@"user_id"];
    
//http://api.looksguru.com/first_look/54798_avatar.jpg
    
    NSUInteger characterCount = [URL_MAIN length];

    NSString *str = selectedPost.strPostImage;
    NSString *newStr = [str substringFromIndex:characterCount];
    
    NSLog(@"%@",newStr);
    
    [request setPostValue:newStr forKey:@"image_name"];
     [request setPostValue:selectedPost.strUserId forKey:@"image_user_id"];
    [request setPostValue:saveValue forKey:@"status"];
     [request setPostValue:selectedPost.strPostId forKey:@"post_id"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(saveLookFail:)];
    [request setDidFinishSelector:@selector(saveLookSuccess:)];
    [request startSynchronous];
}
- (void)saveLookSuccess:(ASIHTTPRequest *)request
{
    isAlreadyRequsted = NO;
    
    
}
- (void)saveLookFail:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",error);
    });
    isAlreadyRequsted = NO;
}


@end
