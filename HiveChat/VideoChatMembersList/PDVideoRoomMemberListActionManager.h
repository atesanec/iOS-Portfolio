//
//  PDVideoRoomMemberListActionManager.h
//  PlayDay
//
//  Created by Marina Shilnikova on 29.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

@class PDVideoRoomViewModel;

@interface PDVideoRoomMemberListActionManager : NSObject
/**
 Init
 
 @param viewModel view model
 @return instance
 */
- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel;

/**
 Invite profile with id

 @param profileId profile id
 */
- (void)inviteProfileWithId:(NSNumber *)profileId completion:(void(^)(BOOL success))completion;
/**
 Invite chat with id

 @param chatId chat id
 @param completion completion
 */
- (void)inviteChatWithId:(NSNumber *)chatId completion:(void(^)(BOOL success))completion;

@end
