//
//  PDPDVideoRoomMemberListChannelsLoaderSectionManager.m
//  PlayDay
//
//  Created by Pavel Sokolov on 12/09/16.
//  Copyright © 2016 Pavel Sokolov. All rights reserved.
//

#import "PDVideoRoomMemberListChannelsLoaderSectionManager.h"

#import "MTKObserving.h"

#import "PDNewAPIGenericCollectionViewDataManager.h"
#import "PDNewAPIObservableHideableObjectListContainer.h"
#import "PDNewAPIEntityListLoader.h"

#import "PDVideoRoomMemberListChannelsLoaderCell.h"

#import "PDVideoRoomMemberListViewModel.h"
#import "PDVideoRoomMemberListChannelsLoaderCellPrimaryInfo.h"

#import "UIView+PDDefaultCellIdentifiers.h"

@interface PDVideoRoomMemberListChannelsLoaderSectionManager ()

/**
 *  View model
 */
@property (nonatomic, strong) PDVideoRoomMemberListViewModel * viewModel;
/**
 Section item
 */
@property (nonatomic, strong) PDNewAPIObservableHideableObjectListContainer *sectionItem;

@end

@implementation PDVideoRoomMemberListChannelsLoaderSectionManager
@synthesize dataManager = _dataManager;
@synthesize sectionIndex = _sectionIndex;

#pragma mark - Lifecycle

- (void)dealloc {
    [self stopObservers];
}

- (instancetype)initWithViewModel:(PDVideoRoomMemberListViewModel *)viewModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.viewModel = viewModel;
    self.sectionItem = [[PDNewAPIObservableHideableObjectListContainer alloc] initWithIndexCount:1];
    [self startObservers];
    
    return self;
}

- (void)startObservers {
    [self observeObject:self.viewModel.channelsEntityListLoader
               property:@"isLoading"
              withBlock:^(__weak PDVideoRoomMemberListChannelsLoaderSectionManager *weakSelf,
                          __weak id viewModel, id old, id newVal) {
                  [weakSelf.dataManager pushVisibleCellReconfigurationUpdate];
              }];
    [self observeObject:self.viewModel.channelsEntityListLoader
               property:@"allLoaded"
              withBlock:^(__weak PDVideoRoomMemberListChannelsLoaderSectionManager *weakSelf,
                          __weak id viewModel, id old, id newVal) {
                  [weakSelf.sectionItem setItemsListHidden:[newVal boolValue]];
              }];
}

- (void)stopObservers {
    [self removeAllObservationsOfObject:self.viewModel.channelsEntityListLoader];
}

#pragma mark - PDGenericCollectionViewSectionManager

- (void)registerSectionCellsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[PDVideoRoomMemberListChannelsLoaderCell class]
       forCellWithReuseIdentifier:[PDVideoRoomMemberListChannelsLoaderCell reuseId]];
}

- (NSString *)reuseIdForCellAtIndex:(NSUInteger)index {
    return [PDVideoRoomMemberListChannelsLoaderCell reuseId];
}

- (CGSize)sizeForCellAtIndex:(NSUInteger)index collectionViewSize:(CGSize)size {
    return CGSizeMake(size.width, [PDVideoRoomMemberListChannelsLoaderCell defaultHeight]);
}

- (void)didSelectCellAtIndex:(NSInteger)pathItem {
    self.viewModel.loadMoreChannelsSignal = [[NSObject alloc] init];
}

- (id)primaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    PDVideoRoomMemberListChannelsLoaderCellPrimaryInfo *info = [[PDVideoRoomMemberListChannelsLoaderCellPrimaryInfo alloc] init];
    info.isLoading = self.viewModel.channelsEntityListLoader.isLoading;
    return info;
}

- (BOOL)hasSecondaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    return NO;
}

@end

