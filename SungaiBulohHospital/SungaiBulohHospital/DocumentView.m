//
//  DocumentView.m
//  SungaiBulohHospital
//
//  Created by Techno Softwares on 10/04/17.
//  Copyright © 2017 madan kumawat. All rights reserved.
//

#import "DocumentView.h"

@implementation DocumentView

+ (id) newDocumentView
{
    UINib *nib = [UINib nibWithNibName:@"DocumentView" bundle:nil];
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    DocumentView *me = [nibArray objectAtIndex: 0];
    return me;
}

@end
