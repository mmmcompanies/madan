//
//  Constants.h
//  SportShout
//
//  Created by Techno Softwares on 15/09/14.
//  Copyright (c) 2014 TechnoSoftwares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE_4S ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define BRANDON_FONT(s) [UIFont fontWithName:@"BrandonGrotesque-Bold" size:s]
#define BRANDON_THIN_FONT(s) [UIFont fontWithName:@"BrandonGrotesque-Thin" size:s]
#define BRANDON_REGULAR_FONT(s) [UIFont fontWithName:@"BrandonGrotesque-Regular" size:s]
#define MYRIAD_PRO_REGULAR_FONT(s) [UIFont fontWithName:@"MyriadPro-Regular" size:s]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define USER_ID @"userid"

#define URL_MAIN @"http://api.looksguru.com/"
#define URL_LOGIN [NSString stringWithFormat:@"%@login.php", URL_MAIN]
#define URL_REGISTER [NSString stringWithFormat:@"%@signup.php", URL_MAIN]
#define URL_UPDATE_DEVICE_TOKEN [NSString stringWithFormat:@"%@add_deviceToken.php", URL_MAIN]

#define URL_CREATE_PROFILE [NSString stringWithFormat:@"%@create_profile.php", URL_MAIN]
#define URL_FORGOT_PASSWORD [NSString stringWithFormat:@"%@forgot_password.php", URL_MAIN]
#define URL_FIRST_LOOK [NSString stringWithFormat:@"%@first_look.php", URL_MAIN]
#define URL_UPLOAD_LOOK [NSString stringWithFormat:@"%@upload_looks.php", URL_MAIN]
#define URL_FETCH_POST [NSString stringWithFormat:@"%@home1.php", URL_MAIN]
#define URL_ADD_COMMENT [NSString stringWithFormat:@"%@insert_post_comment.php", URL_MAIN]
#define URL_FETCH_MY_POST [NSString stringWithFormat:@"%@fetch_looks.php", URL_MAIN]
#define URL_UPDATE_PROFILE [NSString stringWithFormat:@"%@update_profile.php", URL_MAIN]
#define URL_UPDATE_ACCOUNT [NSString stringWithFormat:@"%@my_account.php", URL_MAIN]
#define URL_FOLLOW_UNFOLLOW_USER [NSString stringWithFormat:@"%@follow_user.php", URL_MAIN]
#define URL_FETCH_TAGS [NSString stringWithFormat:@"%@fetch_tag.php", URL_MAIN]
#define URL_SEARCH_IMAGES_WITH_TAGS [NSString stringWithFormat:@"%@tag_search.php", URL_MAIN]
#define URL_SEARCH_NA_TAG_FROM_SERVER [NSString stringWithFormat:@"%@search_selected_tag.php", URL_MAIN]
#define URL_POST_PRIVACY [NSString stringWithFormat:@"%@privacy_status.php", URL_MAIN]
#define URL_USER_SEARCH [NSString stringWithFormat:@"%@user_search.php", URL_MAIN]
#define URL_FOLLOWING_USER_LIST [NSString stringWithFormat:@"%@following_user_detail.php", URL_MAIN]
#define URL_FOLLOWER_USER_LIST [NSString stringWithFormat:@"%@follower_user_detail.php", URL_MAIN]
#define URL_FETCH_RANDOM_LOOK [NSString stringWithFormat:@"%@fetch_randomlook.php", URL_MAIN]
#define URL_RATING_LOOK [NSString stringWithFormat:@"%@rating.php", URL_MAIN]
#define URL_LIKE_UNLIKE [NSString stringWithFormat:@"%@likepost.php", URL_MAIN]
#define URL_DISLIKE_UNDISLIKE [NSString stringWithFormat:@"%@post_dislike.php", URL_MAIN]
#define URL_ALERT_MESSAGES_CONTENTS [NSString stringWithFormat:@"%@alert_message.php", URL_MAIN]
#define URL_SEND_NOTIFICATION [NSString stringWithFormat:@"%@admin/notify_push.php", URL_MAIN]
#define URL_GET_POST_DATA [NSString stringWithFormat:@"%@get_post_details.php", URL_MAIN]
#define URL_FETCH_NOTIFICATIONS [NSString stringWithFormat:@"%@fetch_notification.php", URL_MAIN]
#define URL_REPORT_USER_LOOKS [NSString stringWithFormat:@"%@report_user_look.php", URL_MAIN]
#define URL_DELETE_USER_COMMENT [NSString stringWithFormat:@"%@delete_user_comment.php", URL_MAIN]
#define URL_GET_MOST_POPULAR_USER [NSString stringWithFormat:@"%@most_popular_users.php", URL_MAIN]
#define URL_GET_USER_LIKES [NSString stringWithFormat:@"%@user_likes.php", URL_MAIN]
#define URL_USER_FEEDBACK [NSString stringWithFormat:@"%@feedback.php", URL_MAIN]

#define URL_LOGOUT [NSString stringWithFormat:@"%@logout.php", URL_MAIN]
#define URL_SAVE_UNSAVE [NSString stringWithFormat:@"%@image_save.php", URL_MAIN]
#define URL_FETCH_SAVE_LOOKS [NSString stringWithFormat:@"%@fetch_saved_image.php", URL_MAIN]
#define URL_USERS_LIST [NSString stringWithFormat:@"%@fetch_user_list.php", URL_MAIN]
#define URL_ADD_FRIENDS [NSString stringWithFormat:@"%@send_friend_request.php", URL_MAIN]
#define URL_CHAT_FRIENDS_LIST [NSString stringWithFormat:@"%@fetch_friends_list.php", URL_MAIN]
#define URL_FRIENDS_REQUEST [NSString stringWithFormat:@"%@fetch_friend_request_list.php", URL_MAIN]
#define URL_FRIENDS_REQUEST_CONFIRM [NSString stringWithFormat:@"%@update_friend_request_status.php", URL_MAIN]

#define URL_CHAT [NSString stringWithFormat:@"%@conversation.php", URL_MAIN]
#define URL_CHAT_LIST [NSString stringWithFormat:@"%@conversation_list.php", URL_MAIN]
#define URL_CHAT_SAVE [NSString stringWithFormat:@"%@conversation_save.php", URL_MAIN]




@end