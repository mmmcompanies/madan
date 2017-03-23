//
//  recordingListView.h
//  MPlayer
//
//  Created by Techno Softwares on 22/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recordingListView : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    UIAlertView *deletealert;
    UIAlertView *alert;
    bool isPlaying;
    IBOutlet UILabel *lbl_myplaylist;
    UIActivityIndicatorView *mySpinner;
    NSString *song_id;
    NSMutableArray *arrAddPlaylistName;
    NSString *song_idForPlaylist;
    NSMutableArray *arr_playlistAllsongs;
    NSMutableArray *arrDownloadAllsongs;
    NSMutableArray *arrfavoritelist;
    bool ischecked;
    
}
//==== player bar=====
@property (strong, nonatomic) IBOutlet UIButton *btn_favorite;
@property (strong, nonatomic) IBOutlet UIButton *btn_playlist;
@property (strong, nonatomic) IBOutlet UIButton *btn_download;
@property (strong, nonatomic) IBOutlet UIButton *btn_playpause;

@property(weak,nonatomic) IBOutlet UIView *viewPlayerBar;
@property(weak,nonatomic) IBOutlet UILabel *lblPlayerBarTitle;

-(IBAction)btnPlayerBarPressed:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottom_constraint_free;


//===end===

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *search_width_layout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *search_height_layout;
@property (strong, nonatomic) IBOutlet UIButton *btn_search;
@property(weak,nonatomic) IBOutlet UITableView *tblDetail;


@property(strong,nonatomic) NSMutableArray *arrSectionDetail;
@property(strong,nonatomic) NSString *sectionName;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CGFloat lastContentOffset;
@property(strong,nonatomic) NSString *playlist_id;

@property(weak,nonatomic) IBOutlet UIButton *btnBackNavigation;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuWconstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuHconstraint;
-(IBAction)btnBackPressed:(id)sender;
@property(weak,nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Tbl_Botm_constraint;
@end
