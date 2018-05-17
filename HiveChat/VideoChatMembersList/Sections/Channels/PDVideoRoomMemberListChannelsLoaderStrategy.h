//
//  PDVideoRoomMemberListChannelsLoaderStrategy.h
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDNewAPIEntityListLoaderStrategy.h"

@protocol PDNewAPIPager;
@class PDVideoRoomViewModel;

/**
 Strategy for video room member list channels loader
 */
@interface PDVideoRoomMemberListChannelsLoaderStrategy : NSObject<PDNewAPIEntityListLoaderStrategy>

/**
 Init
 
 @param viewModel view model
 @return instance
 */
- (instancetype)initWithCircleId:(NSNumber *)circleId;

// PDNewAPIEntityListLoaderStrategy methods
@property (nonatomic, strong, readonly) id dataManagerSectionItem;
@property (nonatomic, strong, readonly) id<PDNewAPIPager> stepUpPager;
@property (nonatomic, strong, readonly) id<PDNewAPIPager> stepDownPager;


@end
