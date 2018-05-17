//
//  PDVideoRoomMemberListPeopleSectionManager.m
//  PlayDay
//
//  Created by Marina Shilnikova on 28.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListPeopleSectionManager.h"
#import "PDVideoRoomMemberListPeopleCell.h"
#import "PDVideoRoomMemberListPeopleSectionPrimaryInfo.h"
#import "PDVideoRoomMemberListTitledSeparatorManager.h"
#import "PDVideoRoomViewModel.h"
#import "PDMiniProfileListItem.h"
#import "PDMiniProfile.h"
#import "PDVideoRoomMemberListPeopleLoaderStrategy.h"
#import "PDVideoRoomMemberListActionManager.h"
#import "UIView+PDDefaultCellIdentifiers.h"
#import "PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo.h"
#import "PDNewAPIGenericCollectionViewDataManager.h"
#import "PDImages.h"
#import "PDImage.h"
#import "NSCache+PDSafeOperations.h"
#import "PDProfileInGroupInfoViewController.h"
#import "PDVideoRoomTranslationMember.h"
#import "PDGenericUnidirectionalEventChannel.h"

#import "PDAppUsageEventsManager.h"

@interface PDVideoRoomMemberListPeopleSectionManager ()
/**
 View model
 */
@property (nonatomic, weak) PDVideoRoomViewModel *viewModel;
/**
 *  Entity list loader strategy
 */
@property (nonatomic, strong) PDVideoRoomMemberListPeopleLoaderStrategy *entityListLoaderStrategy;
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
/**
 Cache
 */
@property (nonatomic, strong) NSCache *cache;

@end

@implementation PDVideoRoomMemberListPeopleSectionManager
@synthesize dataManager;
@synthesize sectionIndex;

- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        self.entityListLoaderStrategy = [[PDVideoRoomMemberListPeopleLoaderStrategy alloc] initWithViewModel:viewModel];
        self.sectionItem = self.entityListLoaderStrategy.dataManagerSectionItem;
        self.actionManager = [[PDVideoRoomMemberListActionManager alloc] initWithViewModel:viewModel];
        self.sectionSeparatorManager = [[PDVideoRoomMemberListTitledSeparatorManager alloc] init];
        self.sectionSeparatorManager.text = LOCALIZED(@"video_room_invite_members");

        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - PDGenericCollectionViewSectionManager methods

- (CGSize)sizeForCellAtIndex:(NSUInteger)index collectionViewSize:(CGSize)size {
    return CGSizeMake(size.width, [PDVideoRoomMemberListPeopleCell defaultHeight]);
}

- (NSString *)reuseIdForCellAtIndex:(NSUInteger)index {
    return [PDVideoRoomMemberListPeopleCell reuseId];
}

- (void)registerSectionCellsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[PDVideoRoomMemberListPeopleCell class] forCellWithReuseIdentifier:[PDVideoRoomMemberListPeopleCell reuseId]];
}

- (void)didSelectCellAtIndex:(NSInteger)pathItem {
    PDMiniProfileListItem *listItem = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:pathItem inSection:self.sectionIndex]];
    PDProfileInGroupInfoViewController *controller = [[PDProfileInGroupInfoViewController alloc] initWithProfileId:listItem.miniProfile.profileId];
    [controller presentGroupInfoController];
}

#pragma mark - Cells configuration

- (id)primaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    PDVideoRoomMemberListPeopleSectionPrimaryInfo *primaryInfo = [[PDVideoRoomMemberListPeopleSectionPrimaryInfo alloc] init];
    primaryInfo.profileItem = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];

    BOOL isLive = NO;
    for (PDVideoRoomTranslationMember *member in primaryInfo.profileItem.miniProfile.translationMembers) {
        if (member.translationId != nil) {
            isLive = YES;
            break;
        }
    }

    primaryInfo.isLive = isLive;
    __weak typeof(self) wSelf = self;
    __weak PDMiniProfileListItem *wProfileItem = primaryInfo.profileItem;

    PDGenericUnidirectionalEventChannel *eventChannel = [[PDGenericUnidirectionalEventChannel alloc] init];
    primaryInfo.eventChannel = eventChannel;
    __weak PDGenericUnidirectionalEventChannel *wChannel = eventChannel;
    [primaryInfo setInviteButtonTapHandler:^{
        [wSelf.actionManager inviteProfileWithId:wProfileItem.profileId completion:^(BOOL success) {
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
    PDMiniProfileListItem *listItem = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    return listItem.miniProfile.avatar != nil;
}

- (NSArray *)querySecondaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell
                               atIndex:(NSUInteger)index
                            completion:(void (^)(id))completion {
    PDMiniProfileListItem *listItem = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    __weak typeof(self) wSelf = self;
    NSOperation *operation = [PDImages load:listItem.miniProfile.avatar.url
                                      width:PDImagesSizePresetSmall
                                     height:PDImagesSizePresetSmall
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        [wSelf.cache setObjectSafely:image forKey:listItem.profileId];
                                        completion(image);
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        completion(nil);
                                    }];
    return operation == nil ? @[] : @[operation];
}

- (id)cachedSecondaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    PDMiniProfileListItem *listItem = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    return [self.cache objectForKey:listItem.profileId];
}

@end
