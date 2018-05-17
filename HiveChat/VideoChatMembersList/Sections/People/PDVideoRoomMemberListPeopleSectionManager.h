//
//  PDVideoRoomMemberListPeopleSectionManager.h
//  PlayDay
//
//  Created by Marina Shilnikova on 28.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDGenericCollectionViewLoadableSectionManager.h"

@class PDVideoRoomViewModel;

/**
 People section manager for video room member list
 */
@interface PDVideoRoomMemberListPeopleSectionManager : NSObject <PDGenericCollectionViewLoadableSectionManager>
/**
 Init
 
 @param viewModel view model
 @return instance
 */
- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel;

@end
