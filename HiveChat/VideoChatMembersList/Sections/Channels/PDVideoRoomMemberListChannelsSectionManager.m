//
//  PDVideoRoomMemberListChannelsSectionManager.m
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListChannelsSectionManager.h"

#import "PDNewAPIGenericCollectionViewDataManager.h"
#import "PDVideoRoomMemberListChannelsLoaderStrategy.h"
#import "PDVideoRoomMemberListTitledSeparatorManager.h"
#import "PDVideoRoomMemberListActionManager.h"
#import "PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo.h"
#import "PDGenericUnidirectionalEventChannel.h"
#import "PDAppUsageEventsManager.h"
#import "PDAppUsageEventsEvents.h"
#import "PDNewAPIEntityListLoader.h"

#import "PDVideoRoomMemberListChannelCell.h"

#import "PDVideoRoomMemberListViewModel.h"
#import "PDVideoRoomViewModel.h"
#import "PDVideoRoomMemberListChannelsSectionPrimaryInfo.h"

#import "PDCircle.h"
#import "PDMiniChatListItem.h"
#import "PDMiniChat.h"
#import "PDMiniPost.h"

#import "UIView+PDDefaultCellIdentifiers.h"

static const NSUInteger kDefaultBatchSize = 10;

@interface PDVideoRoomMemberListChannelsSectionManager ()
/**
 View model
 */
@property (nonatomic, weak) PDVideoRoomMemberListViewModel *viewModel;
/**
 Section separator manager
 */
@property (nonatomic, strong) PDVideoRoomMemberListTitledSeparatorManager *sectionSeparatorManager;
/**
 Action manager
 */
@property (nonatomic, strong) PDVideoRoomMemberListActionManager *actionManager;
/**
 Section item
 */
@property (nonatomic, strong) PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo *sectionItem;

@end

@implementation PDVideoRoomMemberListChannelsSectionManager
@synthesize dataManager = _dataManager;
@synthesize sectionIndex = _sectionIndex;

- (instancetype)initWithViewModel:(PDVideoRoomMemberListViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        
        NSNumber *circleId = self.viewModel.videoRoomViewModel.circle.circleId;
        PDNewAPIEntityListLoader *loadManager = [[PDNewAPIEntityListLoader alloc] init];
        loadManager.batchItemCount = kDefaultBatchSize;
        loadManager.loaderStrategy = [[PDVideoRoomMemberListChannelsLoaderStrategy alloc] initWithCircleId:circleId];
        self.viewModel.channelsEntityListLoader = loadManager;
        
        self.sectionItem = loadManager.loaderStrategy.dataManagerSectionItem;
        self.actionManager = [[PDVideoRoomMemberListActionManager alloc] initWithViewModel:self.viewModel.videoRoomViewModel];
        self.sectionSeparatorManager = [[PDVideoRoomMemberListTitledSeparatorManager alloc] init];
        self.sectionSeparatorManager.text = LOCALIZED(@"video_room_invite_channel_members");
    }
    return self;
}

- (void)setSectionIndex:(NSUInteger)sectionIndex {
    _sectionIndex = sectionIndex;
    self.viewModel.channelsEntityListLoader.entityListSectionIndex = sectionIndex;
}

- (void)setDataManager:(PDNewAPIGenericCollectionViewDataManager *)dataManager {
    _dataManager = dataManager;
    self.viewModel.channelsEntityListLoader.collectionViewDataManager = dataManager;
}

#pragma mark - PDGenericCollectionViewSectionManager methods

- (CGSize)sizeForCellAtIndex:(NSUInteger)index collectionViewSize:(CGSize)size {
    return CGSizeMake(size.width, [PDVideoRoomMemberListChannelCell defaultHeight]);
}

- (NSString *)reuseIdForCellAtIndex:(NSUInteger)index {
    return [PDVideoRoomMemberListChannelCell reuseId];
}

- (void)registerSectionCellsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[PDVideoRoomMemberListChannelCell class] forCellWithReuseIdentifier:[PDVideoRoomMemberListChannelCell reuseId]];
}

- (void)didSelectCellAtIndex:(NSInteger)pathItem {
}

#pragma mark - Cells configuration

- (id)primaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    __weak typeof(self) wSelf = self;

    PDMiniChatListItem *item = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    PDGenericUnidirectionalEventChannel *eventChannel = [[PDGenericUnidirectionalEventChannel alloc] init];
    __weak PDGenericUnidirectionalEventChannel *wChannel = eventChannel;

    PDVideoRoomMemberListChannelsItemType type = PDVideoRoomMemberListChannelsItemTypeOpen;
    if (((PDMiniPost *)item.miniChat).isPublicValue) {
        if (((PDMiniPost *)item.miniChat).isBroadcastValue) {
            type = PDVideoRoomMemberListChannelsItemTypeBroadcast;
        }
    } else {
        type = PDVideoRoomMemberListChannelsItemTypePrivate;
    }
    
    PDVideoRoomMemberListChannelsSectionPrimaryInfo *primaryInfo = [[PDVideoRoomMemberListChannelsSectionPrimaryInfo alloc] init];
    primaryInfo.channelName = item.postTitle;
    primaryInfo.eventChannel = eventChannel;
    primaryInfo.itemType = type;
    [primaryInfo setInviteButtonTapHandler:^{
        [wSelf.actionManager inviteChatWithId:item.chatId completion:^(BOOL success) {
            if (success) {
                [[PDAppUsageEventsManager instance] tagEvent:[PDAppUsageEventsEvents videoRoomInviteButtonPressed]];
                if (wChannel) {
                    wChannel.eventHandler([[NSObject alloc] init]);
                }
            }
        }];
    }];
    return primaryInfo;
}

- (BOOL)hasSecondaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    return NO;
}

@end
