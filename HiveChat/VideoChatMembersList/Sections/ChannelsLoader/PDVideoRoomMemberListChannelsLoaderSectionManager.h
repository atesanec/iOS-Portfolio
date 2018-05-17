//
//  PDPDVideoRoomMemberListChannelsLoaderSectionManager.h
//  PlayDay
//
//  Created by Pavel Sokolov on 12/09/16.
//  Copyright © 2016 Pavel Sokolov. All rights reserved.
//

#import "PDGenericCollectionViewSectionManager.h"

@class PDVideoRoomMemberListViewModel;

@interface PDVideoRoomMemberListChannelsLoaderSectionManager : NSObject <PDGenericCollectionViewSectionManager>

/**
 *  Init with view model
 */
- (instancetype)initWithViewModel:(PDVideoRoomMemberListViewModel *)viewModel;


- (instancetype)init __unavailable;

@end

