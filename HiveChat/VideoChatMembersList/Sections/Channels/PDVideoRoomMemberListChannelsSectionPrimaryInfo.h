//
//  PDVideoRoomMemberListChannelsSectionPrimaryInfo.h
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDGenericUnidirectionalEventChannel;

typedef NS_ENUM(NSInteger, PDVideoRoomMemberListChannelsItemType) {
    PDVideoRoomMemberListChannelsItemTypeOpen,
    PDVideoRoomMemberListChannelsItemTypeBroadcast,
    PDVideoRoomMemberListChannelsItemTypePrivate,
};

@interface PDVideoRoomMemberListChannelsSectionPrimaryInfo : NSObject

@property (nonatomic, assign) PDVideoRoomMemberListChannelsItemType itemType;
/**
 Channel name
 */
@property (nonatomic, strong) NSString *channelName;
/**
 Invite button tap handler
 */
@property (nonatomic, copy) void(^inviteButtonTapHandler)();
/**
 Event channel
 */
@property (nonatomic, strong) PDGenericUnidirectionalEventChannel *eventChannel;

@end
