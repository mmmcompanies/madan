//
//  VRView.m
//  MPlayer
//
//  Created by Techno Softwares on 17/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//
#import "DailyView.h"
#import "VRView.h"

@interface VRView ()

@end

@implementation VRView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     global = [Global sharedInstance];
    self.navigationController.navigationBar.hidden = YES;
    
    MVYSideMenuController *sideMenu = [self sideMenuController];
    if (sideMenu) {
        [sideMenu disable];
    }
    selectRedioButton = 11;
    
    SubView = [DailyView newQueueListView];
  
        
        SubView.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        
    [SubView.btn_daily addTarget:self action:@selector(BtnEventSelect:) forControlEvents:UIControlEventTouchUpInside];
    [SubView.btn_weekly addTarget:self action:@selector(BtnEventSelect:) forControlEvents:UIControlEventTouchUpInside];
    [SubView.btn_monthly addTarget:self action:@selector(BtnEventSelect:) forControlEvents:UIControlEventTouchUpInside];
    [SubView.btn_yearly addTarget:self action:@selector(BtnEventSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [SubView.btn_save addTarget:self action:@selector(SaveRecording:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:SubView];
    
    [self datepickerview];
    
    SubView.hidden = TRUE;
    song_Name =@"temp.aac";
    song_NameWithout = @"Temp";
    progressView.progress = 0.0;
    lbl_progress.text = @"0";
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"my.aac",
                               nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
      [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
   
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    
    [recorder prepareToRecord];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(IBAction)btnBackPressed:(id)sender
{
    MVYSideMenuController *sideMenu = [self sideMenuController];
    if (sideMenu) {
        [sideMenu openMenu];
    }
}

- (IBAction)strat:(id)sender {
     UIButton *button = (UIButton*)sender;
    if (myplayer.playing) {
        [myplayer stop];
    }

    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [session setActive:YES error:nil];
        
        btn_start.alpha = 0.5;
        btn_start.userInteractionEnabled = false;
        
        btn_pause.alpha = 1.0;
        btn_pause.userInteractionEnabled = true;
        
        btn_stop.alpha = 1.0;
        btn_stop.userInteractionEnabled = true;
        
        btn_play.alpha = 0.5;
        btn_play.userInteractionEnabled = false;
        
        btn_save.alpha = 0.5;
        btn_save.userInteractionEnabled = false;
        
        btn_upload.alpha = 0.5;
        btn_upload.userInteractionEnabled = false;
        
        // Start recording
        [recorder recordForDuration:3601];
        [recorder record];
        
         myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES]; 
    }
}
- (IBAction)pause:(id)sender {
     UIButton *button = (UIButton*)sender;
    
    
    btn_pause.alpha = 0.5;
    btn_pause.userInteractionEnabled = false;
    
    btn_stop.alpha = 1.0;
    btn_stop.userInteractionEnabled = true;
    
    btn_save.alpha = 0.5;
    btn_save.userInteractionEnabled = false;
    
    btn_upload.alpha = 0.5;
    btn_upload.userInteractionEnabled = false;
    
    if([myplayer isPlaying])
    {
        btn_play.alpha = 1.0;
        btn_play.userInteractionEnabled = true;
        
        btn_start.alpha = 0.5;
        btn_start.userInteractionEnabled = false;
        
        [myplayer pause];
    }
    
    if([recorder isRecording])
    {
        btn_start.alpha = 1.0;
        btn_start.userInteractionEnabled = true;

        btn_play.alpha = 0.5;
        btn_play.userInteractionEnabled = false;
         [recorder pause];
    }
    
    
}
- (IBAction)stop:(id)sender {
     UIButton *button = (UIButton*)sender;
   
        [myplayer stop];
        [recorder stop];

    btn_start.alpha = 1.0;
    btn_start.userInteractionEnabled = true;
    
    btn_pause.alpha = 0.5;
    btn_pause.userInteractionEnabled = false;
    
    btn_stop.alpha = 0.5;
    btn_stop.userInteractionEnabled = false;
    
    btn_play.alpha = 1.0;
    btn_play.userInteractionEnabled = true;
    
    btn_save.alpha = 1.0;
    btn_save.userInteractionEnabled = true;
    
    btn_upload.alpha = 0.5;
    btn_upload.userInteractionEnabled = false;
    
    [myTimer invalidate];
     lbl_time.text = @"00:00:00";
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}
- (IBAction)play:(id)sender {
     UIButton *button = (UIButton*)sender;
    
    btn_start.alpha = 0.5;
    btn_start.userInteractionEnabled = false;
    
    btn_pause.alpha = 1.0;
    btn_pause.userInteractionEnabled = true;
    
    btn_stop.alpha = 1.0;
    btn_stop.userInteractionEnabled = true;
    
    btn_play.alpha = 0.5;
    btn_play.userInteractionEnabled = false;
    
    btn_save.alpha = 1.0;
    btn_save.userInteractionEnabled = true;
    
    btn_upload.alpha = 0.5;
    btn_upload.userInteractionEnabled = false;
    
    if (!recorder.recording)
    {
        [self play];
    }
    
}

- (void)renameFileWithName:(NSString *)srcName toName:(NSString *)dstName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:srcName];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:dstName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else
    {
        NSLog(@"File %@ doesn't exists", srcName);
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (alertviewSave == alertView) {
         if (buttonIndex == 0)
         {
             btn_save.alpha = 1.0;
             btn_save.userInteractionEnabled = true;
         }
         else
         {
             NSLog(@"%@", [alertView textFieldAtIndex:0].text);
             
             song_Name =[NSString stringWithFormat:@"%@.aac",[alertView textFieldAtIndex:0].text];
             song_NameWithout = [alertView textFieldAtIndex:0].text;
             [self renameFileWithName:@"my.aac" toName:[NSString stringWithFormat:@"%@.aac",[alertView textFieldAtIndex:0].text]];
             
             SubView.hidden = false;
             [[SubView superview] bringSubviewToFront:SubView];
         }
     }
    if (alertviewUpload == alertView) {
        
        if (buttonIndex == 0)
        {
            btn_upload.alpha = 1.0;
            btn_upload.userInteractionEnabled = true;
        }
        else
        {
            alertviewPublic = [[UIAlertView alloc] initWithTitle:@"Upload"
                                                         message:[NSString stringWithFormat:@"Do you want to public or private %@ pujan",song_NameWithout]
                                                        delegate:self
                                               cancelButtonTitle:@"Private"
                                               otherButtonTitles:@"Public",nil];
            [alertviewPublic show];
        }
        
    }
     if (alertviewPublic == alertView) {
     
         if (buttonIndex == 0)
         {
             privacy = @"private";
             [self uploadPujanSong];
         }
         else
         {
              privacy = @"public";
              [self uploadPujanSong];
         }
     }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertviewSave == alertView) {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""])
        {
            return false;
        }
        else
        {
            return TRUE;
        }
    }
    else
    {
        return TRUE;
    }
}
- (IBAction)save:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    if (button.tag == 0)
    {
        
        btn_save.alpha = 0.5;
        btn_save.userInteractionEnabled = false;
        
            alertviewSave = [[UIAlertView alloc] initWithTitle:@"File Name"
                                                                message:@"Please Enter file name."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Save",nil];
            alertviewSave.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertviewSave show];

    }
    
    if (button.tag == 1) {
        
        btn_upload.alpha = 0.5;
        btn_upload.userInteractionEnabled = false;
        
        alertviewUpload = [[UIAlertView alloc] initWithTitle:@"Upload"
                                                   message:[NSString stringWithFormat:@"Do you want upload %@ pujan",song_NameWithout]
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Ok",nil];
        [alertviewUpload show];
        
        
    }
    
    
}

-(void)uploadPujanSong{

    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:documentPath_])
    {
        
        arrayListOfRecordSound=[[NSMutableArray alloc]initWithArray:[fileManager  contentsOfDirectoryAtPath:documentPath_ error:nil]];
        
        NSLog(@"====%@",arrayListOfRecordSound);
        
    }
    NSString  *selectedSound = @"";
    for (int i=0; i<arrayListOfRecordSound.count; i++)
        
    {
        if ([arrayListOfRecordSound[i] isEqualToString:song_Name]) {
            selectedSound =  [documentPath_ stringByAppendingPathComponent:[arrayListOfRecordSound objectAtIndex:i]];
            break;
        }
    }
    
    if ([selectedSound isEqualToString:@""]) {
        
        selectedSound =  [documentPath_ stringByAppendingPathComponent:@"my.aac"];
    }
    
    lbl_progress.text = [NSString stringWithFormat:@"%.0f",progressView.progress * 100];
    
    NSData *songData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:selectedSound]];
    
    //        NSString *base64ImageString = [imageData base64EncodedStringWithOptions:kNilOptions];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
    
    //        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/edit_profile.php"];
    
    NSDictionary *parameter;
    parameter = @{@"user_id":userid,@"recording_song":song_Name,@"upload_on":@"server",@"listening_on":@"daily",@"privacy":privacy,@"date":dateForweb};
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://mplayer.tridentsoftech.com/recording.php" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        [formData appendPartWithFormData:songData name:@"recording_file"];
                                    } error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //                          dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                          //                          dispatch_async(queue, ^{
                          //Update the progress view
                          [progressView setProgress:uploadProgress.fractionCompleted];
                          lbl_progress.text = [NSString stringWithFormat:@"%.0f",progressView.progress * 100 -1];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      lbl_progress.text = @"100";
                      if (error) {
                          NSLog(@"Error: %@", error);
                          progressView.progress = 0.0;
                          lbl_progress.text = @"0";
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                                          message: @"Recording upload successfully"
                                                                         delegate: nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          [alert show];
                          
                          progressView.progress = 0.0;
                          lbl_progress.text = @"0";
                      }
                  }];
    
    [uploadTask resume];

}

- (BOOL)recordForDuration:(NSTimeInterval)duration{
    
    
    return YES;
}
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder{}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    
     [recorder stop];
    
    btn_start.alpha = 1.0;
    btn_start.userInteractionEnabled = true;
    
    btn_pause.alpha = 0.5;
    btn_pause.userInteractionEnabled = false;
    
    btn_stop.alpha = 0.5;
    btn_stop.userInteractionEnabled = false;
    
    btn_play.alpha = 1.0;
    btn_play.userInteractionEnabled = true;
    
    btn_save.alpha = 1.0;
    btn_save.userInteractionEnabled = true;
    
    btn_upload.alpha = 0.5;
    btn_upload.userInteractionEnabled = false;
    
    lbl_time.text = @"00:00:00";
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
        [player stop];
     [myTimer invalidate];
     AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    
    btn_start.alpha = 1.0;
    btn_start.userInteractionEnabled = true;
    
    btn_pause.alpha = 0.5;
    btn_pause.userInteractionEnabled = false;
    
    btn_stop.alpha = 0.5;
    btn_stop.userInteractionEnabled = false;
    
    btn_play.alpha = 1.0;
    btn_play.userInteractionEnabled = true;
    
    btn_save.alpha = 1.0;
    btn_save.userInteractionEnabled = true;
    
    btn_upload.alpha = 0.5;
    btn_upload.userInteractionEnabled = false;

    lbl_time.text = @"00:00:00";
}




- (void)updateLBL {
    // Update the slider about the music time
    if([myplayer isPlaying])
    {
        NSInteger hour = floor([myplayer currentTime]/3600);
        NSInteger minutes = floor([myplayer currentTime]/60);
        NSInteger seconds = [myplayer currentTime] - (minutes * 60);
        
        if (minutes <60) {
            NSString *time = [[NSString alloc]
                              initWithFormat:@"%02ld:%02ld:%02ld",(long)hour,
                              (long)minutes, (long)seconds];
            lbl_time.text = time;

        }
        else{
            minutes = minutes - 60;
            NSString *time = [[NSString alloc]
                              initWithFormat:@"%02ld:%02ld:%02ld",(long)hour,
                              (long)minutes, (long)seconds];
            lbl_time.text = time;

        }
        
    }
}
- (void)updateSlider {
    // Update the slider about the music time
    if([recorder isRecording])
    {
        NSInteger hour = floor(recorder.currentTime/3600);
        NSInteger minutes = floor(recorder.currentTime/60);
        NSInteger seconds = recorder.currentTime - (minutes * 60);
        
        NSString *time = [[NSString alloc]
                          initWithFormat:@"%02ld:%02ld:%02ld",(long)hour,
                          (long)minutes, (long)seconds];
        lbl_time.text = time;
    }
}

#pragma mark 
#pragma mark setup recording and save , play 


- (NSString *) dateString
{
    // return a formatted string for a file name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMMYY_hhmmssa";
    return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".acc"];
}

- (BOOL) startAudioSession
{
    // Prepare the audio session
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
    {
        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
        return NO;
    }
    
    if (![session setActive:YES error:&error])
    {
        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
        return NO;
    }
    
    return YES;
}

- (BOOL) record
{
    NSError *error;
    
    // Recording settings
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
//    [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
//    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
        [settings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [settings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    
    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:@"my.acc"];
    
    // File URL
    NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
    
    // Create recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (!recorder)
    {
        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
        return NO;
    }
    
    // Initialize degate, metering, etc.
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    //self.title = @"0:00";
    
//    if (![recorder prepareToRecord])
//    {
//        NSLog(@"Error: Prepare to record failed");
//        //[self say:@"Error while preparing recording"];
//        return NO;
//    }
//    
//    if (![recorder record])
//    {
//        NSLog(@"Error: Record failed");
//        //  [self say:@"Error while attempting to record audio"];
//        return NO;
//    }
    
    // Set a timer to monitor levels, current time
//    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
     [recorder prepareToRecord];
    
    return YES;
}

-(void)play
{
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:documentPath_])
    {
        
        arrayListOfRecordSound=[[NSMutableArray alloc]initWithArray:[fileManager  contentsOfDirectoryAtPath:documentPath_ error:nil]];
        
        NSLog(@"====%@",arrayListOfRecordSound);
        
    }
    NSString  *selectedSound = @"";
    for (int i=0; i<arrayListOfRecordSound.count; i++)
    
    {
        if ([arrayListOfRecordSound[i] isEqualToString:song_Name]) {
            selectedSound =  [documentPath_ stringByAppendingPathComponent:[arrayListOfRecordSound objectAtIndex:i]];
            break;
        }
    }
    
    if ([selectedSound isEqualToString:@""]) {
        
        selectedSound =  [documentPath_ stringByAppendingPathComponent:@"my.aac"];
    }
    
    NSURL   *url =[NSURL fileURLWithPath:selectedSound];

    NSError *error;
    //Start playback
    myplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (!myplayer)
    {
        NSLog(@"Error establishing player for %@: %@", recorder.url, error.localizedFailureReason);
        return;
    }
    
    myplayer.delegate = self;
    
    // Change audio session for playback
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
    {
        NSLog(@"Error updating audio session: %@", error.localizedFailureReason);
        return;
    }
    [myplayer prepareToPlay];
    [myplayer play];
    
      myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLBL) userInfo:nil repeats:YES];
    
    
}

#pragma mark
#pragma mark save type

-(void)datepickerview{
    
    SubView.txt_Daily.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Date" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     SubView.txt_Weekly.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Weekly Date" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     SubView.txt_Monthly.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Monthly Date" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     SubView.txt_Yearly.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Yearly Date" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    SubView.btn_save.layer.cornerRadius = 7;
    SubView.btn_save.clipsToBounds = true;
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]]; //this returns today's date
    
    NSDate *now = [NSDate date];
    NSDate *tenYear = [now dateByAddingTimeInterval:-10*366*24*60*60];
    NSLog(@"7 days ago: %@", tenYear);
    
    [datePicker setMinimumDate:now]; //the min age restriction
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    
    UIView *dateview = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 216.0)];
    dateview.backgroundColor = [UIColor whiteColor];
    dateview.layer.borderWidth = 2;
    dateview.layer.borderColor =[UIColor colorWithRed:183.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:1.0].CGColor;
    
    datePicker.frame = CGRectMake(0.0, 0.0, 320.0, 216.0);
    datePicker.center = dateview.center;
    
    [dateview addSubview:datePicker];
    
    SubView.txt_Daily.text = [self formatDate:now];
    dateForweb  = [self formatDateForWebservice:now];
    listening_on = @"daily";
    
    SubView.txt_Daily.delegate = self;
    [SubView.txt_Daily setInputView:dateview];
    
    SubView.txt_Weekly.delegate = self;
    [SubView.txt_Weekly setInputView:dateview];
    
    SubView.txt_Monthly.delegate = self;
    [SubView.txt_Monthly setInputView:dateview];
    
    SubView.txt_Yearly.delegate = self;
    [SubView.txt_Yearly setInputView:dateview];
   
}

-(void)BtnEventSelect:(id)sender{
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 11) {
        
        selectRedioButton = 11;
        [SubView.btn_daily setImage:[UIImage imageNamed:@"redio.png"] forState:UIControlStateNormal];
        [SubView.btn_weekly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];

        [SubView.btn_monthly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];

        [SubView.btn_yearly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        
        listening_on = @"daily";
        SubView.txt_Daily.hidden = false;
        SubView.txt_Weekly.hidden = true;
        SubView.txt_Monthly.hidden = true;
        SubView.txt_Yearly.hidden = true;

    }
    if (button.tag == 12) {
        selectRedioButton = 12;
        [SubView.btn_daily setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        [SubView.btn_weekly setImage:[UIImage imageNamed:@"redio.png"] forState:UIControlStateNormal];
        
        [SubView.btn_monthly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        
        [SubView.btn_yearly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        
        listening_on = @"weekly";
        SubView.txt_Daily.hidden = true;
        SubView.txt_Weekly.hidden = false;
        SubView.txt_Monthly.hidden = true;
        SubView.txt_Yearly.hidden = true;
        
    }
    if (button.tag == 13) {
        selectRedioButton = 13;
        [SubView.btn_daily setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        [SubView.btn_weekly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        
        [SubView.btn_monthly setImage:[UIImage imageNamed:@"redio.png"] forState:UIControlStateNormal];
        
        [SubView.btn_yearly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        listening_on = @"monthly";
        SubView.txt_Daily.hidden = true;
        SubView.txt_Weekly.hidden = true;
        SubView.txt_Monthly.hidden = false;
        SubView.txt_Yearly.hidden = true;
        
    }
    if (button.tag == 14) {
        selectRedioButton = 14;
        [SubView.btn_daily setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        [SubView.btn_weekly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        
        [SubView.btn_monthly setImage:[UIImage imageNamed:@"redioselect.png"] forState:UIControlStateNormal];
        
        [SubView.btn_yearly setImage:[UIImage imageNamed:@"redio.png"] forState:UIControlStateNormal];
        listening_on = @"yearly";
        SubView.txt_Daily.hidden = true;
        SubView.txt_Weekly.hidden = true;
        SubView.txt_Monthly.hidden = true;
        SubView.txt_Yearly.hidden = false;
    }

}
-(void)SaveRecording:(id)sender{
    UIButton *button = (UIButton*)sender;
    
    if([global isConnectedToInternet])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager.requestSerializer setTimeoutInterval:30];
        
//        mplayer.tridentsoftech.com/recording.php?user_id=112&recording_song=ok&recording_file=ok&upload_on=server&date=current_date&listening_on=daily

        
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserId"];
        
        NSString *url = [NSString stringWithFormat:@"http://mplayer.tridentsoftech.com/recording.php"];
        NSDictionary *parameter;
        parameter = @{@"user_id":userid,@"recording_song":song_Name,@"upload_on":@"local",@"date":dateForweb,@"listening_on":listening_on,@"privacy":@"private"};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"url:%@ with paramiter = %@   JSONresponce :== %@",url,parameter,responseObject);
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"success"])
            {
                 SubView.hidden = true;
                btn_upload.alpha = 1.0;
                btn_upload.userInteractionEnabled = true;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save"
                                                             message:[NSString stringWithFormat:@"%@ pujan save successfully",song_NameWithout]
                                                            delegate:self
                                                      cancelButtonTitle:nil
                                                   otherButtonTitles:@"Ok",nil];
                [alert show];
                
            }
            
        }failure:^(NSURLSessionTask *task, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:[NSString stringWithFormat:@"Internal Error Please try again %@ pujan",song_NameWithout]
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Ok",nil];
            [alert show];
           
            NSLog(@"Error: %@", error);
        }];
        
    }

    
}

-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)sender;
    
    if ( selectRedioButton == 11 ) {
         SubView.txt_Daily.text = [self formatDate:picker.date];
        dateForweb  = [self formatDateForWebservice:picker.date];
    }
    else if ( selectRedioButton == 12 ) {
        SubView.txt_Weekly.text = [self formatDate:picker.date];
        dateForweb  = [self formatDateForWebservice:picker.date];
    }
    else if ( selectRedioButton == 13 ) {
        SubView.txt_Monthly.text = [self formatDate:picker.date];
        dateForweb  = [self formatDateForWebservice:picker.date];
    }
    else if ( selectRedioButton == 14 ) {
        SubView.txt_Yearly.text = [self formatDate:picker.date];
        dateForweb  = [self formatDateForWebservice:picker.date];
    }
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
- (NSString *)formatDateForWebservice:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

@end
