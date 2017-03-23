//
//  DailyView.m
//  MPlayer
//
//  Created by Techno Softwares on 22/03/17.
//  Copyright © 2017 Techno Softwares. All rights reserved.
//

#import "DailyView.h"

@implementation DailyView

+ (id) newQueueListView
{
    
    UINib *nib = [UINib nibWithNibName:@"DailyView" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    DailyView *me = [nibArray objectAtIndex: 0];
    return me;
}

@end
