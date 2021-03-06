//
//  VRView.h
//  MPlayer
//
//  Created by Techno Softwares on 17/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//
#import "DailyView.h"
#import "Global.h"
#import <UIKit/UIKit.h>


#import "AppDelegate.h"
@import AVFoundation;
@import CoreAudio;
@import CoreMedia;
@import CoreAudioKit;

@interface VRView : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextFieldDelegate,NSURLSessionTaskDelegate>
{
AVAudioRecorder *recorder;
AVAudioPlayer *myplayer;
     UIDatePicker *datePicker;
    IBOutlet UILabel *lbl_progress;
    IBOutlet UIProgressView *progressView;
    IBOutlet UILabel *lbl_time;
    NSTimer *myTimer;
    NSString* fullfilePath;
     NSString* song_Name;
    NSString* song_NameWithout;
    NSString *listening_on;
     NSString *dateForweb;
      NSString *privacy;
    NSArray *arrayListOfRecordSound;
    DailyView *SubView;
    int selectRedioButton;
     Global *global;
    bool myplayerStatus;
    AFHTTPSessionManager *manager;
    UIAlertView *alertviewSave;
    UIAlertView *alertviewUpload;
    UIAlertView *alertviewPublic;
    
    IBOutlet UILabel *lbl_sanskrit;
    IBOutlet UILabel *lbl_hindi;
    IBOutlet UIButton *btn_sanstrit;
    IBOutlet UIButton *btn_hindi;
    IBOutlet UIView *view_language;
    
    IBOutlet UIButton *btn_saveLanguage;
    NSString *language;
    NSString *songeTime;

    
    IBOutlet UIButton *btn_start;
    
    IBOutlet UIButton *btn_pause;
    
    IBOutlet UIButton *btn_stop;
    
    IBOutlet UIButton *btn_play;
    
    IBOutlet UIButton *btn_save;
    
    IBOutlet UIButton *btn_upload;
}
@end
