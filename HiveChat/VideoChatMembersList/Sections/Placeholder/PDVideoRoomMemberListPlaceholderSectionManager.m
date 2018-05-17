//
//  PDVideoRoomMemberListPlaceholderSectionManager.m
//  PlayDay
//
//  Created by Marina Shilnikova on 30.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListPlaceholderSectionManager.h"

#import "PDVideoRoomViewModel.h"
#import "PDVideoRoomMemberListPlaceholderPrimaryInfo.h"
#import "PDVideoRoomMemberListPlaceholderCell.h"
#import "PDVideoRoomMemberListAddMembersCell.h"

#import "PDNewAPIGenericCollectionViewDataManager.h"
#import "PDNewAPIEntityListLoader.h"
#import "PDNewAPIEntityCollectionMonitor.h"
#import "MTKObserving.h"
#import "PDNewAPIObservableHideableObjectListContainer.h"
#import "PDNewAPIEntityCollectionChangeInfo.h"
#import "PDGroupInviteShareMenuPresenter.h"

#import "PDAppUsageEventsManager.h"

#import "UIView+PDDefaultCellIdentifiers.h"
#import "UIViewController+PDControllerHierarchy.h"
#import "NSString+PDMeasuring.h"

static const NSUInteger kVideoRoomMemberListPlaceholderSectionManagerFirstCellIndexNumber = 0;
static const NSUInteger kVideoRoomMemberListPlaceholderSectionManagerSecondCellIndexNumber = 1;

@interface PDVideoRoomMemberListPlaceholderSectionManager ()
/**
 *    Section item
 */
@property (nonatomic, strong) PDNewAPIObservableHideableObjectListContainer *sectionItem;
/**
 *    Model
 */
@property (nonatomic, weak) PDVideoRoomViewModel *viewModel;

/**
 Entity list loader
 */
@property (nonatomic, strong) PDNewAPIEntityListLoader *entityListLoader;

/**
 People section index
 */
@property (nonatomic, assign) NSUInteger peopleSectionIndex;

/**
 Menu presenter
 */
@property (nonatomic, strong) PDGroupInviteShareMenuPresenter *menuPresenter;

@end

@implementation PDVideoRoomMemberListPlaceholderSectionManager
@synthesize dataManager = _dataManager;
@synthesize sectionIndex;


- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel
               peopleSectionIndex:(NSUInteger)peopleSectionIndex
                     entityLoader:(PDNewAPIEntityListLoader *)loader {
    self = [super init];
    NSAssert(viewModel, @"Need to call initWithViewModel:");
    if (self) {
        self.viewModel = viewModel;
        self.peopleSectionIndex = peopleSectionIndex;
        self.entityListLoader = loader;
        
        PDVideoRoomMemberListPlaceholderPrimaryInfo *info = [[PDVideoRoomMemberListPlaceholderPrimaryInfo alloc] init];
        info.placeholderText = LOCALIZED(@"video_room_empty_group_placeholder");
        info.showLoader = self.entityListLoader.isLoading;
        self.sectionItem = [[PDNewAPIObservableHideableObjectListContainer alloc] initWithList:@[info, [NSNull null]]];
        
        [self setupObservers];
    }
    return self;
}

- (void)dealloc {
    [self.dataManager removeChangeObserver:self forSection:self.peopleSectionIndex];
    [self removeObservers];
}

#pragma mark - PDGenericCollectionViewSectionManager methods

- (void)setDataManager:(PDNewAPIGenericCollectionViewDataManager *)dataManager {
    _dataManager = dataManager;
    [self.dataManager addChangeObserver:self forSection:self.peopleSectionIndex];
}


- (void)didSelectCellAtIndex:(NSInteger)pathItem {
    if (pathItem == kVideoRoomMemberListPlaceholderSectionManagerSecondCellIndexNumber) {
        if (!self.menuPresenter) {
            self.menuPresenter = [[PDGroupInviteShareMenuPresenter alloc] initWithCircle:self.viewModel.circle];
        }
        
        [[PDAppUsageEventsManager instance] tagEvent:[PDAppUsageEventsEvents shareLinkStart]
                                           attribute:[PDAppUsageEventsAttributes fromVideoRoomMembersPlaceholder]];

        [self.menuPresenter presentMenu];
    }
}

- (CGSize)sizeForCellAtIndex:(NSUInteger)index collectionViewSize:(CGSize)size {
    if (index == kVideoRoomMemberListPlaceholderSectionManagerFirstCellIndexNumber) {
        PDVideoRoomMemberListPlaceholderPrimaryInfo *info = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                                    inSection:self.sectionIndex]];
        NSString *text = info.placeholderText;
        UIEdgeInsets cellOffsets = [PDVideoRoomMemberListPlaceholderCell placeholderInsets];
        CGSize cellSize = [NSString pdSizeOfString:text
                                withAttributes:[PDVideoRoomMemberListPlaceholderCell textAttributes]
                           constraintedToWidth:self.dataManager.collectionView.frame.size.width - cellOffsets.right - cellOffsets.left];
        cellSize.width = size.width;
        cellSize.height += cellOffsets.top + cellOffsets.bottom;
        return cellSize;
    } else {
        return CGSizeMake(size.width, [PDVideoRoomMemberListAddMembersCell defaultHeight]);
    }
}

- (NSString *)reuseIdForCellAtIndex:(NSUInteger)index {
    if (index == kVideoRoomMemberListPlaceholderSectionManagerFirstCellIndexNumber) {
        return [PDVideoRoomMemberListPlaceholderCell reuseId];
    } else {
        return [PDVideoRoomMemberListAddMembersCell reuseId];
    }
}

- (void)registerSectionCellsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[PDVideoRoomMemberListPlaceholderCell class]
       forCellWithReuseIdentifier:[PDVideoRoomMemberListPlaceholderCell reuseId]];
    [collectionView registerClass:[PDVideoRoomMemberListAddMembersCell class]
       forCellWithReuseIdentifier:[PDVideoRoomMemberListAddMembersCell reuseId]];
}


#pragma mark - Cells configuration

- (id)primaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    return [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
}

#pragma mark - private

- (void)setupObservers {
    [self observeObject:self.entityListLoader
               property:@"isLoading"
              withBlock:^(__weak PDVideoRoomMemberListPlaceholderSectionManager *wSelf, __weak id object, id old, id newVal) {
                  if (old == nil && newVal == nil) {
                      // Skip initial observation
                      return;
                  }
                  PDVideoRoomMemberListPlaceholderPrimaryInfo *info = [[wSelf.sectionItem observableList] firstObject];
                  info.showLoader = wSelf.entityListLoader.isLoading;
                  [wSelf.sectionItem updateAllObjects];
              }];
}

- (void)removeObservers {
    [self removeAllObservationsOfObject:self.entityListLoader];
}

#pragma mark - PDNewAPIEntityCollectionMonitorDelegate

- (void)entityCollectionMonitor:(PDNewAPIEntityCollectionMonitor *)monitor didChangeCollectionWithInfo:(PDNewAPIEntityCollectionChangeInfo *)info {
    [self.sectionItem setItemsListHidden:(monitor.entityCollection.count > 0)];
}


@end
