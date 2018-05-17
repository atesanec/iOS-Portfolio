//
//  PDVideoRoomMemberListPeopleLoaderStrategy.h
//  PlayDay
//
//  Created by Marina Shilnikova on 29.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDNewAPIEntityListLoaderStrategy.h"

@protocol PDNewAPIPager;
@class PDVideoRoomViewModel;

/**
 Strategy for video room member list people loader
 */
@interface PDVideoRoomMemberListPeopleLoaderStrategy : NSObject<PDNewAPIEntityListLoaderStrategy>

/**
 Init
 
 @param viewModel view model
 @return instance
 */
- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel;

// PDNewAPIEntityListLoaderStrategy methods
@property (nonatomic, strong, readonly) id dataManagerSectionItem;
@property (nonatomic, strong, readonly) id<PDNewAPIPager> stepUpPager;
@property (nonatomic, strong, readonly) id<PDNewAPIPager> stepDownPager;


@end
