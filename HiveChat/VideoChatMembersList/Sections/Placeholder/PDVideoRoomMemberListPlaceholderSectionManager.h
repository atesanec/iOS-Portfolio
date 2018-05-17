//
//  PDVideoRoomMemberListPlaceholderSectionManager.h
//  PlayDay
//
//  Created by Marina Shilnikova on 30.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDGenericCollectionViewSectionManager.h"

@class PDVideoRoomViewModel;
@class PDNewAPIEntityListLoader;

/**
 Section manager for video room members placeholder
 */
@interface PDVideoRoomMemberListPlaceholderSectionManager : NSObject <PDGenericCollectionViewSectionManager>
/**
 Init

 @param viewModel view model
 @param peopleSectionIndex people section index
 @param loader entity loader
 */
- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel
               peopleSectionIndex:(NSUInteger)peopleSectionIndex
                     entityLoader:(PDNewAPIEntityListLoader *)loader;

@end
