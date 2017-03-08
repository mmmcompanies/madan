/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Helper object for managing the downloading of a particular app's icon.
  It uses NSURLSession/NSURLSessionDataTask to download the app's icon in the background if it does not
  yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 */

#import "IconDownloader.h"

#define kAppIconSize 48


@interface IconDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


#pragma mark -

@implementation IconDownloader
@synthesize isHomeImage;

// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload
{
    isListData = YES;
    isProfile = NO;
    NSURLRequest *request;
    
    if (isHomeImage && self.appRecord.strMediumThumbURL.length > 0)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.strMediumThumbURL]];
    }
    else if(self.appRecord.strSmallThumbURL.length > 0)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.strSmallThumbURL]];
    }
    else if(self.commentData.strUserImgURL.length > 0)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.commentData.strUserImgURL]];
    }
    else if(self.userData.strUserProfile.length > 0)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.userData.strUserProfile]];
    }
    else if(self.notifData.strUserImage.length > 0)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.notifData.strUserImage]];
    }
    else if(self.Usersdata.strPostImage.length > 0)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.Usersdata.strPostImage]];
    }
   
  else if(self.ChatusersData.strPostImage.length > 0)
  {
      request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ChatusersData.strPostImage]];
  }
  else if(self.Savelook.strPostImage.length > 0)
  {
      request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.Savelook.strPostImage]];
  }


    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       // in case we want to know the response status code
                                                       //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                       
                                                       if (error != nil)
                                                       {
                                                           //            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                           //            {
                                                           //                // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                           //                // then your Info.plist has not been properly configured to match the target server.
                                                           //                //
                                                           //abort();
                                                           //            }
                                                           NSLog(@"%@", error);
                                                       }
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           
                                                           [self imageDownloaded:data];
                                                       }];
                                                   }];
    
    [self.sessionTask resume];
}

- (void)startDownloadForProfileImage
{
    isProfile = YES;
    isListData = NO;
    isUser = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.strUserImg]];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       // in case we want to know the response status code
                                                       //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                       
                                                       if (error != nil)
                                                       {
//                                                                       if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
//                                                                       {
//                                                                           // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
//                                                                           // then your Info.plist has not been properly configured to match the target server.
//                                                                           //
                                                           //abort();
//                                                                       }
                                                       }
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           
                                                           [self imageDownloaded:data];
                                                       }];
                                                   }];
    
    [self.sessionTask resume];
}

// -------------------------------------------------------------------------------
//	cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

- (void)imageDownloaded:(NSData *)imageData
{
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    if (isHomeImage && self.appRecord.strMediumThumbURL.length > 0)
    {
        self.appRecord.imgPostImage = image;
    }
    else if(self.appRecord.strSmallThumbURL.length > 0 && isListData)
    {
        self.appRecord.imgPostImage = image;
    }
    if(self.appRecord.strUserImg.length > 0 && isProfile)
    {
        self.appRecord.imgUserImage = image;
    }
    else if (self.commentData.strUserImgURL.length > 0)
    {
        self.commentData.imgUserImg = image;
    }
    else if(self.userData.strUserProfile.length > 0)
    {
        self.userData.imgProfile = image;
    }
    else if(self.notifData.strUserImage.length > 0)
    {
        self.notifData.imgUserImage = image;
    }
    
    else if(self.Savelook.strPostImage.length > 0)
    {
        self.Savelook.imgPostImage = image;
    }
  
    else if(self.ChatusersData.strPostImage.length > 0)
    {
        self.ChatusersData.imgPostImage = image;
    }
    else if(self.Usersdata.strPostImage.length > 0)
    {
        self.Usersdata.imgPostImage = image;
    }
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}


@end

