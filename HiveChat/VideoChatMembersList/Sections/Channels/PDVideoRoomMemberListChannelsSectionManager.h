//
//  PDVideoRoomMemberListChannelsSectionManager.h
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDGenericCollectionViewSectionManager.h"

@class PDVideoRoomMemberListViewModel;

/**
 Channels section manager for video room member list
 */
@interface PDVideoRoomMemberListChannelsSectionManager : NSObject <PDGenericCollectionViewSectionManager>
/**
 Init
 
 @param viewModel view model
 @return instance
 */
- (instancetype)initWithViewModel:(PDVideoRoomMemberListViewModel *)viewModel;


- (instancetype)init __unavailable;

@end
