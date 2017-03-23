//
//  recordingListView.m
//  MPlayer
//
//  Created by Techno Softwares on 22/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "recordingListView.h"

@interface recordingListView ()

{
    NSMutableArray *arrplaylist;
    
    BOOL isConstraintUpdated,isHindi,isSearching;
    
    NSIndexPath *selectedIndex;
    NSString *selectedSectionname;
    NSString *selectedmain_category;
    Global *global;
    MBProgressHUD *hud;
    BOOL isNoThanksClicked;
}

@end

@implementation recordingListView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    global = [Global sharedInstance];
    
    self.navigationController.navigationBar.hidden = YES;
    
    MVYSideMenuController *sideMenu = [self sideMenuController];
    if (sideMenu) {
        [sideMenu disable];
    }
    
    
    
    
    [_tblDetail registerNib:[UINib nibWithNibName:@"playlistsCell" bundle:nil] forCellReuseIdentifier:@"playlistsCell"];
    
    _tblDetail.backgroundColor = [UIColor clearColor];
    [_tblDetail setShowsHorizontalScrollIndicator:NO];
    [_tblDetail setShowsVerticalScrollIndicator:NO];
    
    int checkFor24Hrs = 0;
    BOOL needToShow = NO;
    double timeStamp;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"lastratetimestamp"])
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"Rated"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"NoThanks"])
        {
            needToShow = NO;
        }
        else
        {
            needToShow = YES;
        }
    }
    else
    {
        double lastTImeStamp = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setValue:[@(lastTImeStamp) stringValue] forKey:@"lastratetimestamp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        timeStamp = 0;
        needToShow = YES;
    }
    
    if(needToShow)
    {
        double lastTImeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastratetimestamp"] doubleValue];
        timeStamp = ([[NSDate date] timeIntervalSince1970]);
        checkFor24Hrs = timeStamp - lastTImeStamp;
        if(checkFor24Hrs >= (SECONDS_IN_24HRS * 5))
        {
            [self showRateNowPopup];
        }
    }
#pragma mark Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadcomplete:) name:@"download" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaylistNotification:) name:@"updatePlaylistNotification" object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    isSearching = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoadPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RateAppNoThanks" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"download" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    _viewPlayerBar.hidden = YES;
    
    if(global.isPlaying)
    {
        [self.btn_playpause setImage: global.playpause.imageView.image forState:UIControlStateNormal] ;
        _viewPlayerBar.hidden = NO;
        
        _lblPlayerBarTitle.text = global.strSongTitle;
        if (IS_IPAD)
        {
            [_lblPlayerBarTitle setFont:[UIFont fontWithName:@"LucidaCalligraphy-Italic" size:21]];
        }
        global.playpause = self.btn_playpause;
        global.favorite = self.btn_favorite;
        global.playlist = self.btn_playlist;
        global.download = self.btn_download;
        global.lblPlayBarTitle =  _lblPlayerBarTitle ;
        
        [self.btn_favorite setImage:[UIImage imageNamed:@"favorite_white"] forState:UIControlStateNormal];
        [self.btn_playlist setImage:[UIImage imageNamed:@"playlist_white"] forState:UIControlStateNormal];
        [self.btn_download setImage:[UIImage imageNamed:@"download_white"] forState:UIControlStateNormal];
        NSString *song_Id = [[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"id"];
        for(int i=0;i<global.arrfavoritelist.count;i++)
        {
            
            if([[[global.arrfavoritelist objectAtIndex:i] objectForKey:@"id"] isEqualToString:song_Id])
            {
                NSLog(@"chane favorite");
                [self.btn_favorite setImage:[UIImage imageNamed:@"favorite_done"] forState:UIControlStateNormal];
                break;
            }
        }
        
        for(int i=0;i<global.arr_playlistAllsongs.count;i++)
        {
            if([[[global.arr_playlistAllsongs objectAtIndex:i] objectForKey:@"id"] isEqualToString:song_Id])
            {
                NSLog(@"chane playlist icon");
                [self.btn_playlist setImage:[UIImage imageNamed:@"playlist_done"] forState:UIControlStateNormal];
                break;
            }
        }
        
        for(int i=0;i<global.arrDownloadAllsongs.count;i++)
        {
            
            if([[[global.arrDownloadAllsongs objectAtIndex:i] objectForKey:@"id"] isEqualToString:song_Id])
            {
                NSString *Path =[global LoadSongFromLocal:[NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/%@",[[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"url"]]] ;
                if ([Path isEqualToString:@"no"] )
                {
                    
                }
                else
                {
                    NSLog(@"chane download icon");
                    [self.btn_download setImage:[UIImage imageNamed:@"download_done"] forState:UIControlStateNormal];
                }
                break;
            }
        }
        
        if (IS_IPAD)
        {
            self.bottom_constraint_free.constant = 0;
        }
        else
        {
            self.bottom_constraint_free.constant = 0;
        }
        
    }
    else
    {
        if (IS_IPAD)
        {
            self.bottom_constraint_free.constant = -80;
        }
        else
        {
            self.bottom_constraint_free.constant = -65;
        }
        
    }
    
    switch ((int)[UIScreen mainScreen].bounds.size.height) {
        case 480:
        {
            if(!isConstraintUpdated)
            {
                isConstraintUpdated = YES;
                
            }
            break;
        }
        case 568:
        {
            if(!isConstraintUpdated)
            {
                
                isConstraintUpdated = YES;
                
            }
            break;
        }
        case 667:
        {
            if(!isConstraintUpdated)
            {
                
                _headerHeightConstraint.constant = _headerHeightConstraint.constant+5;
                _search_width_layout.constant = _search_width_layout.constant+5;
                _search_height_layout.constant = _search_height_layout.constant+5;
                
                _btnBackNavigation.imageEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 42);
                
                isConstraintUpdated = YES;
                
            }
            break;
        }
        case 736:
        {
            if(!isConstraintUpdated)
            {
                _headerHeightConstraint.constant = _headerHeightConstraint.constant+15;
                _search_width_layout.constant = _search_width_layout.constant+10;
                _search_height_layout.constant = _search_height_layout.constant+10;
                
                _btnBackNavigation.imageEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 44);
                
                isConstraintUpdated = YES;
                
            }
            break;
        }
        case 1024:
        {
            if(!isConstraintUpdated)
            {
                
                _headerHeightConstraint.constant = _headerHeightConstraint.constant+35;
                isConstraintUpdated = YES;
                lbl_myplaylist.font = [UIFont fontWithName:@"LucidaCalligraphy-Italic" size:25.0];
                
            }
            break;
        }
            
        default:
            break;
    }
    
    [self.view layoutIfNeeded];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPlayerScreen) name:@"LoadPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noThanksClicked) name:@"RateAppNoThanks" object:nil];
    
   
    
    [self UserPlaylist];
}
#pragma mark - Custom Alert View

- (void)showRateNowPopup
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    [alert addButton:@"YES, Rate Mobile Pandit Pro" target:self selector:@selector(rateNowClicked)];
    
    SCLButton *remindLater = [alert addButton:@"Remind me Later" target:self selector:@selector(remindLaterClicked)];
    remindLater.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor whiteColor];
        buttonConfig[@"textColor"] = [UIColor blackColor];
        buttonConfig[@"borderWidth"] = @2.0f;
        buttonConfig[@"borderColor"] = UIColorFromHEX(0xB9131C);//[UIColor greenColor];
        
        return buttonConfig;
    };
    
    [alert showSuccess:@"Rate App" subTitle:@"If you are satisfied using Mobile Pandit Pro kindly spare a moment to rate.\n Thanks for your Patronage!" closeButtonTitle:@"No Thanks" duration:0.0f];
    isNoThanksClicked = YES;
}

#pragma mark - Custom Alert Button Selector

- (void)rateNowClicked
{
    NSString *itunes = @"itms://itunes.apple.com/us/app/apple-store/id1090309772?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunes]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Rated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    isNoThanksClicked = NO;
}

- (void)remindLaterClicked
{
    double lastTImeStamp = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setValue:[@(lastTImeStamp) stringValue] forKey:@"lastratetimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    isNoThanksClicked = NO;
}

- (void)noThanksClicked
{
    if(isNoThanksClicked)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NoThanks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - Load Player Screen

- (void)loadPlayerScreen
{
    [self.navigationController pushViewController:global.playerViewController animated:YES];
}

#pragma mark - Back Button Pressed

-(IBAction)btnBackPressed:(id)sender
{
    MVYSideMenuController *sideMenu = [self sideMenuController];
    if (sideMenu) {
        [sideMenu openMenu];
    }
}

#pragma mark
#pragma mark-TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrplaylist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"playlistsCell";
    
    playlistsCell *cell = (playlistsCell *)[_tblDetail dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"playlistsCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lbl_Snumber.text = [NSString stringWithFormat:@"%ld.",indexPath.row + 1];
    cell.lbl_playlistName.text = [[arrplaylist objectAtIndex:indexPath.row] objectForKey:@"recording_song"];
    
    [cell.btn_edit addTarget:self action:@selector(editPlaylist:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn_edit setImage:[UIImage imageNamed:@"icon-2.png"] forState:UIControlStateNormal];
    [cell.btn_delete addTarget:self action:@selector(deletePlaylist:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 90;
    }
    
    return 45;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SectionView *secDetail = segue.destinationViewController;
    
    secDetail.arrSelectedSection = [NSMutableArray new];
    
    secDetail.main_category = selectedmain_category;
    secDetail.SectionIndexpath = selectedIndex;
    secDetail.isselectedlanguage = isHindi;
    secDetail.sectionName = selectedSectionname;
    
    
    for(int i=0;i<global.arrSongs.count;i++)
    {
        if([selectedmain_category isEqualToString:[[global.arrSongs objectAtIndex:i] objectForKey:@"main_category"]])
        {
            [secDetail.arrSelectedSection addObject:[global.arrSongs objectAtIndex:i]];
        }
    }
    
}

#pragma mark
#pragma mark User playlists web service
-(void)UserPlaylist
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //    http://mplayer.tridentsoftech.com/fetch_user_playlists.php?user_id=5
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/recording_list.php"];
        NSDictionary *parameter;
        parameter = @{@"userid":userid,@"upload_on":@"local"};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            NSArray *temp;
            if([responseObject isKindOfClass:[NSArray class]])
            {
                temp = responseObject;
                
            }
            arrplaylist = [[NSMutableArray alloc]init];
            for(int i=0;i<temp.count;i++)
            {
            
                if ([self checkRecordingsong:[[temp objectAtIndex:i] objectForKey:@"path"]]) {
                    [arrplaylist addObject:[temp objectAtIndex:i]];
                }
            }
            
//            global.arrplaylistname =[responseObject objectForKey:@"user_playlist"];
            
            [hud hideAnimated:YES];
            
            self.tblDetail.dataSource= self;
            self.tblDetail.delegate = self;
            [self.tblDetail reloadData];
            [self UserFavorites];
            
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            [hud hideAnimated:YES];
            if(error.code == 3840)
            {
                alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Internal Server Error, Try Again", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
                
                [alert show];
            }
            else
            {
                alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Weak internet connection", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            NSLog(@"Error: %@", error);
        }];
        
    }
    
}

#pragma mark
#pragma edit and delete action
-(void)editPlaylist:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tblDetail];
    NSIndexPath *clickedIP = [self.tblDetail indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"%ld",(long)clickedIP.row);
    
    self.playlist_id = [[arrplaylist objectAtIndex:clickedIP.row] objectForKey:@"recording_song_id"] ;
    
   }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == deletealert)
    {
        if (buttonIndex == 0)
        {
            
        }
        else
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self deletePlaylistWebservice:self.playlist_id];
            
            
        }
        
    }
    else
    {
        if (buttonIndex == 0)
        {
            
        }
        else
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSLog(@"%@", [alertView textFieldAtIndex:0].text);
            [self editPlaylistWebservice:self.playlist_id playlistname:[alertView textFieldAtIndex:0].text];
        }
    }
    
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [self BlankTextValidation:[alertView textFieldAtIndex:0].text];
}

-(BOOL)BlankTextValidation:(NSString*)text
{
    
    if ([text isEqualToString:@""])
    {
        return false;
    }
    else
    {
        return true;
        
    }
}

-(void)deletePlaylist:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tblDetail];
    NSIndexPath *clickedIP = [self.tblDetail indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"%ld",(long)clickedIP.row);
    
    self.playlist_id = [[global.arrplaylistname objectAtIndex:clickedIP.row] objectForKey:@"playlist_id"] ;
    
    deletealert = [[UIAlertView alloc] initWithTitle:@"Mobile Pandit Pro"
                                             message:@"Are you sure delete to playlist."
                                            delegate:self
                                   cancelButtonTitle:@"No"
                                   otherButtonTitles:@"YES",nil];
    
    [deletealert show];
    
}


#pragma mark
#pragma mark delete playlist

-(void)deletePlaylistWebservice:(NSString*)playlist_id
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //   http://mplayer.tridentsoftech.com/delete_user_playlist.php?user_id=5&playlist_id=3
        //            http://mplayer.tridentsoftech.com/edit_user_playlists.php?user_id=5&playlist_id=3&playlist_name=abc
        
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/delete_user_playlist.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid,@"playlist_id":playlist_id};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"Delete success"])
            {
                [self UserPlaylist];
                
            }
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@", error);
        }];
        
    }
}

#pragma mark
#pragma mark delete playlist

-(void)editPlaylistWebservice:(NSString*)playlist_id playlistname:(NSString*)name
{
    
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //   http://mplayer.tridentsoftech.com/delete_user_playlist.php?user_id=5&playlist_id=3
        //    http://mplayer.tridentsoftech.com/edit_user_playlists.php?user_id=5&playlist_id=3&playlist_name=abc
        
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/edit_user_playlists.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid,@"playlist_id":playlist_id,@"playlist_name":name};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"success"])
            {
                [self UserPlaylist];
                
            }
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@", error);
        }];
        
    }
}


#pragma mark
#pragma mark player screen

-(IBAction)btnPlayerBarPressed:(id)sender
{
    if(global.playerViewController)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadPlayer" object:nil];
    }
}

-(IBAction)btn_1Action:(id)sender
{
    song_id = [[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"id"];
    
    UIButton *button = (UIButton*)sender;
    UIImage *image1 = [UIImage imageNamed:@"favorite_white"];
    
    bool compare = [self firstimage:button.imageView.image isEqualTo:image1];
    
    if (compare)
    {
        [sender setImage:[UIImage imageNamed:@"favorite_done"] forState:UIControlStateNormal];
        [self addToFavorite:song_id];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"favorite_white"] forState:UIControlStateNormal];
        [self deletefavorite:song_id];
    }
}
-(IBAction)btn_2Action:(id)sender
{
    song_id = [[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"id"];
    
    CustomPlaylistView *contentVC = [[CustomPlaylistView alloc]init];
    contentVC.definesPresentationContext = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:song_id forKey:@"songid"];
    
    contentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    contentVC.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:contentVC animated:YES completion:nil];
}

-(BOOL)firstimage:(UIImage *)image1 isEqualTo:(UIImage *)image2 {
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqualToData:data2];
}

-(IBAction)btn_3Action:(id)sender
{
    
    song_id = [[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"id"];
    
    NSString *Path =[global LoadSongFromLocal:[NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/%@",[[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"url"]]] ;
    if ([Path isEqualToString:@"no"] )
    {
        
        alert = [[UIAlertView alloc]initWithTitle:@"Mobile Pandit Pro" message:NSLocalizedString(@"Your Song is Downloading...", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Continue", nil) otherButtonTitles:nil, nil];
        
        [alert show];
        BOOL result = [global downloadsong:[NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/%@",[[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"url"]]];
        if (result)
        {
            NSLog(@"%D",result);
            
            [sender setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
            
            UIButton *button = (UIButton*)sender;
            
            mySpinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0,button.frame.size.width + 2, button.frame.size.height + 2)];
            mySpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [sender addSubview:mySpinner];
            
            [mySpinner startAnimating];
            
            [self addToDownload:song_id];
        }
    }
    
}
-(IBAction)btn_4Action:(id)sender
{
    
    UIButton *button = (UIButton*)sender;
    UIImage *image1 = [UIImage imageNamed:@"play_white"];
    
    bool compare = [self firstimage:button.imageView.image isEqualTo:image1];
    
    if (compare)
    {
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"play_white"] forState:UIControlStateNormal];
    }
    
    ViewController *myVc =  (ViewController *)global.playerViewController;
    
    NSLog(@"%ld",(long)[[global audioPlayer] state]);
    
    if([[global audioPlayer] state] == STKAudioPlayerStatePaused)
    {
        [global.audioPlayer resume];
        [myVc enableTimer:YES];
        
        global.playStatus = global.playStatusOld;
        
        if([global.playStatus containsString:@"bell"])
        {
            [global.playerBell play];
        }
        else if([global.playStatus containsString:@"tanpura"])
        {
            [global.playerTanpura play];
        }
        else if([global.playStatus containsString:@"om"])
        {
            [global.playerOm play];
        }
        
    }
    else if([[global audioPlayer] state] == 3)
    {
        
        [global.audioPlayer pause];
        
        [myVc enableTimer:NO];
        
        global.playStatusOld = global.playStatus;
        global.playStatus = @"pause";
        
        [global.playerBell pause];
        [global.playerOm pause];
        [global.playerTanpura pause];
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark
#pragma mark User Favorites web service
-(void)UserFavorites
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //    http://mplayer.tridentsoftech.com/fetch_user_playlists.php?user_id=5
        
        
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/favourite_user_detail.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            NSString *result = [NSString stringWithFormat:@"%@",[responseObject  objectForKey:@"result"]];
            if ([result isEqualToString:@"success"])
                
                
            {
                arrfavoritelist = [[NSMutableArray alloc]init];
                
                [arrfavoritelist addObjectsFromArray:[responseObject objectForKey:@"favourite_songs"]];
                
                global.arrfavoritelist = [responseObject objectForKey:@"favourite_songs"];
                [self UserDownloads];
                
            }
            else
            {
                [self UserDownloads];
            }
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            [self UserDownloads];
            NSLog(@"Error: %@", error);
        }];
    }
}

#pragma mark
#pragma mark update view controller

#pragma mark
#pragma mark User playlists songs web service
-(void)UserPlaylistAllsong
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //          http://mplayer.tridentsoftech.com/fetch_playlist_songs.php?user_id=5
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/fetch_playlist_songs.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            arr_playlistAllsongs = [[NSMutableArray alloc]init];
            [arr_playlistAllsongs addObjectsFromArray:responseObject];
            global.arr_playlistAllsongs = responseObject;
            
            [self updatePlaylistNotification:nil];
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    
}

#pragma mark
#pragma mark User Favorites web service
-(void)UserDownloads
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //          http://mplayer.tridentsoftech.com/fetch_user_song_downloads.php?user_id=5
        
        
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/fetch_user_song_downloads.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            NSString *result = [NSString stringWithFormat:@"%@",[responseObject  objectForKey:@"result"]];
            
            if ([result isEqualToString:@"success"]) {
                NSArray *tenmp = [responseObject objectForKey:@"user_downloads"];
                arrDownloadAllsongs = [[NSMutableArray alloc]init];
                [arrDownloadAllsongs addObjectsFromArray:tenmp];
                global.arrDownloadAllsongs = tenmp;
                
                [self UserPlaylistAllsong];
            }
            else
            {
                [self UserPlaylistAllsong];
                
            }
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            [self UserPlaylistAllsong];
            
            NSLog(@"Error: %@", error);
        }];
        
    }
    
}

#pragma mark
#pragma addto favorite
-(void)addToFavorite:(NSString*)sond_id
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //    http://mplayer.tridentsoftech.com/insert_playlist_songs.php?user_id=5&playlist_name=XYZy&song_id=19
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/favourite.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid,@"song_id":sond_id};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"success"])
            {
                
                
            }
            
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            
            NSLog(@"Error: %@", error);
        }];
        
    }
    
    
}

#pragma mark
#pragma addto download
-(void)addToDownload:(NSString*)sond_id
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //   http://mplayer.tridentsoftech.com/user_song_download.php?user_id=5&song_id=129
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/user_song_download.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid,@"song_id":sond_id};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"success"])
            {
            }
            
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            
            NSLog(@"Error: %@", error);
        }];
        
    }
    
    
}

#pragma mark
#pragma delete favorite
-(void)deletefavorite:(NSString*)sond_id
{
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
        //       http://mplayer.tridentsoftech.com/delete_favourite_songs.php?user_id=176&song_id=28
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/delete_favourite_songs.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid,@"song_id":sond_id};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"success"])
            {
                
            }
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    
    
}

#pragma mark
#pragma mark search button action
- (IBAction)btn_search_clicked:(id)sender
{
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    detailView *contentVC = [MainStoryboard instantiateViewControllerWithIdentifier:@"detailView"];
    [self.navigationController pushViewController:contentVC animated:YES];
}
#pragma mark
#pragma mark Download complete action
- (void)downloadcomplete:(NSNotification *)notification
{
    [mySpinner stopAnimating];
    
    alert = [[UIAlertView alloc]initWithTitle:@"Mobile Pandit Pro" message:NSLocalizedString(@"Your Song has been Downloaded Successfully.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (void)updatePlaylistNotification:(NSNotification *)notification
{
    if(global.isPlaying)
    {
        [self.btn_playpause setImage: global.playpause.imageView.image forState:UIControlStateNormal] ;
        _viewPlayerBar.hidden = NO;
        
        _lblPlayerBarTitle.text = global.strSongTitle;
        if (IS_IPAD)
        {
            [_lblPlayerBarTitle setFont:[UIFont fontWithName:@"LucidaCalligraphy-Italic" size:21]];
        }
        global.playpause = self.btn_playpause;
        global.favorite = self.btn_favorite;
        global.playlist = self.btn_playlist;
        global.download = self.btn_download;
        global.lblPlayBarTitle =  _lblPlayerBarTitle ;
        
        [self.btn_favorite setImage:[UIImage imageNamed:@"favorite_white"] forState:UIControlStateNormal];
        [self.btn_playlist setImage:[UIImage imageNamed:@"playlist_white"] forState:UIControlStateNormal];
        [self.btn_download setImage:[UIImage imageNamed:@"download_white"] forState:UIControlStateNormal];
        
        NSString *song_Id = [[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"id"];
        for(int i=0;i<global.arrfavoritelist.count;i++)
        {
            
            if([[[global.arrfavoritelist objectAtIndex:i] objectForKey:@"id"] isEqualToString:song_Id])
            {
                NSLog(@"chane favorite");
                [self.btn_favorite setImage:[UIImage imageNamed:@"favorite_done"] forState:UIControlStateNormal];
                break;
            }
        }
        
        for(int i=0;i<global.arr_playlistAllsongs.count;i++)
        {
            if([[[global.arr_playlistAllsongs objectAtIndex:i] objectForKey:@"id"] isEqualToString:song_Id])
            {
                NSLog(@"chane playlist icon");
                [self.btn_playlist setImage:[UIImage imageNamed:@"playlist_done"] forState:UIControlStateNormal];
                break;
            }
        }
        
        for(int i=0;i<global.arrDownloadAllsongs.count;i++)
        {
            
            if([[[global.arrDownloadAllsongs objectAtIndex:i] objectForKey:@"id"] isEqualToString:song_Id])
            {
                NSString *Path =[global LoadSongFromLocal:[NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/%@",[[global.arrPlaySection objectAtIndex:[[global currentSongIndex] row]] objectForKey:@"url"]]] ;
                if ([Path isEqualToString:@"no"] )
                {
                    
                }
                else
                {
                    NSLog(@"chane download icon");
                    [self.btn_download setImage:[UIImage imageNamed:@"download_done"] forState:UIControlStateNormal];
                }
                break;
            }
        }
    }
    
    [self.tblDetail reloadData];
    
}

-(BOOL)checkRecordingsong:(NSString*)pathForLocal
{
    
    NSURL *URL = [NSURL URLWithString:pathForLocal];
    NSString *fileName = [URL lastPathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager fileExistsAtPath:filePath];
    
    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    return success;
}

@end
