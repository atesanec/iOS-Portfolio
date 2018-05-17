//
//  PDVideoRoomMemberListPeopleSectionPrimaryInfo.h
//  PlayDay
//
//  Created by Marina Shilnikova on 29.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDMiniProfileListItem.h"

@class PDGenericUnidirectionalEventChannel;

/**
 Primary info for people cell in video room member list
 */
@interface PDVideoRoomMemberListPeopleSectionPrimaryInfo : NSObject
/**
 Profile item
 */
@property (nonatomic, strong) PDMiniProfileListItem *profileItem;
/**
 Is live
 */
@property (nonatomic, assign) BOOL isLive;
/**
 Invite button tap handler
 */
@property (nonatomic, copy) void(^inviteButtonTapHandler)();
/**
 Event channel
 */
@property (nonatomic, strong) PDGenericUnidirectionalEventChannel *eventChannel;

@end
