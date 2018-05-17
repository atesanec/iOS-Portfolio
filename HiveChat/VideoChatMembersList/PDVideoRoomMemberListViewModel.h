//
//  PDVideoRoomMemberListViewModel.h
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDVideoRoomViewModel;
@class PDNewAPIEntityListLoader;

@interface PDVideoRoomMemberListViewModel : NSObject

/**
 Video room view model
 */
@property (nonatomic, strong) PDVideoRoomViewModel *videoRoomViewModel;
/**
 Entity list loader
 */
@property (nonatomic, strong) PDNewAPIEntityListLoader *channelsEntityListLoader;
/**
 Load more
 */
@property (nonatomic, strong) id loadMoreChannelsSignal;

@end
