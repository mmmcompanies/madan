/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Helper object for managing the downloading of a particular app's icon.
  It uses NSURLSession/NSURLSessionDataTask to download the app's icon in the background if it does not
  yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 */

#import <Foundation/Foundation.h>
#import "LGPostData.h"
#import "LGLoginData.h"

@class LGPostData;

@interface IconDownloader : NSObject
{
    BOOL isListData;
    BOOL isUser;
    BOOL isProfile;
}

@property (nonatomic, strong) LGLoginData *userData;
@property (nonatomic, strong) LGPostData *appRecord;
@property (nonatomic, strong) LGPostData *Savelook;
@property (nonatomic, strong) LGPostData *Usersdata;
@property (nonatomic, strong) LGPostData *ChatusersData;
@property (nonatomic, strong) LGCommentsData * commentData;
@property (nonatomic, strong) LGNotificationData * notifData;
@property (assign) BOOL  isHomeImage;


@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;
- (void)startDownloadForProfileImage;

@end
