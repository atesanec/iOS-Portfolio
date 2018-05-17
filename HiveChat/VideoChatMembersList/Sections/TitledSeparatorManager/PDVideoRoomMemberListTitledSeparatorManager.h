//
//  PDVideoRoomMemberListTitledSeparatorManager.h
//  PlayDay
//
//  Created by Pavel Sokolov on 01/11/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDGenericSectionSeparatorManager.h"

/**
 Seprator manager for video room member list
 */
@interface PDVideoRoomMemberListTitledSeparatorManager : NSObject <PDGenericSectionSeparatorManager>

/**
 Title text
 */
@property (nonatomic, strong) NSString *text;

@end
