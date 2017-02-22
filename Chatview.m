//
//  Chatview.m
//  Looks Guru
//
//  Created by Techno Softwares on 22/02/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "Chatview.h"

@implementation Chatview

+ (id) newChatview
{
    UINib *nib = [UINib nibWithNibName:@"Chatview" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    Chatview *obj = [nibArray objectAtIndex: 0];
    return obj;
}

@end
