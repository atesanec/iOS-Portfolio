//
//  PDVideoRoomMembersListTranslationsSectionManager.h
//  PlayDay
//
//  Created by Pavel Sokolov on 28/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDGenericCollectionViewSectionManager.h"

@class PDVideoRoomViewModel;

@interface PDVideoRoomMembersListTranslationSectionManager : NSObject <PDGenericCollectionViewSectionManager>

/**
 *  Init with view model
 */
- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel;



- (instancetype)init __unavailable;

@end

