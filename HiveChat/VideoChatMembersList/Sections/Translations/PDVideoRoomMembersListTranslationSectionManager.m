//
//  PDVideoRoomMembersListTranslationsSectionManager.m
//  PlayDay
//
//  Created by Pavel Sokolov on 28/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMembersListTranslationSectionManager.h"

#import "PDNewAPIObservableObjectListContainer.h"
#import "PDMemoryPressureDiscardableCache.h"
#import "PDNewAPIGenericCollectionViewDataManager.h"
#import "PDVideoRoomMembersListTranslationMemberGridLoader.h"

#import "PDVideoRoomViewModel.h"
#import "PDVideoRoomMembersListTranslationCellPrimaryInfo.h"
#import "PDVideoRoomMembersListTranslationCellSecondaryInfo.h"
#import "PDUniformGridViewPrimaryInfo.h"
#import "PDUniformGridViewLayoutAttributes.h"
#import "PDUniformGridViewSecondaryInfo.h"
#import "PDVideoRoomMembersListTranslationMemberGridLoaderInfo.h"
#import "PDVideoRoomMembersListTranslationMemberGridPrimaryInfo.h"

#import "PDVideoRoomTranslation.h"
#import "PDVideoRoomTranslationMember.h"

#import "PDVideoRoomMembersListTranslationCell.h"
#import "PDVideoRoomMembersListTranslationMemberGridCell.h"
#import "PDUniformGridView.h"
#import "PDMiniProfile.h"

#import "PDAppUsageEventsManager.h"

#import "NSManagedObject+RKAdditions.h"
#import "UIView+PDDefaultCellIdentifiers.h"

@interface PDVideoRoomMembersListTranslationSectionManager ()

/**
 *  Grid secondary info loader
 */
@property (nonatomic, strong) PDVideoRoomMembersListTranslationMemberGridLoader * gridSecondaryInfoLoader;
/**
 *  View model
 */
@property (nonatomic, strong) PDVideoRoomViewModel * viewModel;

@end

@implementation PDVideoRoomMembersListTranslationSectionManager
@synthesize sectionIndex = _sectionIndex;
@synthesize dataManager = _dataManager;

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.viewModel = viewModel;
    self.gridSecondaryInfoLoader = [[PDVideoRoomMembersListTranslationMemberGridLoader alloc] init];
    
    return self;
}

#pragma mark - PDGenericCollectionViewSectionManager

- (NSFetchRequest *)sectionItem {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[PDVideoRoomTranslation entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"%K.@count > 0", PDVideoRoomTranslationRelationships.translationMembers];
    return request;
}

- (void)registerSectionCellsForCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[PDVideoRoomMembersListTranslationCell class]
       forCellWithReuseIdentifier:[PDVideoRoomMembersListTranslationCell reuseId]];
}

- (NSString *)reuseIdForCellAtIndex:(NSUInteger)index {
    return [PDVideoRoomMembersListTranslationCell reuseId];
}

- (CGSize)sizeForCellAtIndex:(NSUInteger)index collectionViewSize:(CGSize)size {
    PDVideoRoomTranslation *translation = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    
    PDUniformGridViewLayoutAttributes *attributes = [self gridLayoutAttributes];
    UIEdgeInsets insets = [PDVideoRoomMembersListTranslationCell translationMembersGridInsets];
    CGFloat maxWidth = self.dataManager.collectionView.frame.size.width - insets.left - insets.right;
    CGSize gridSize = [PDUniformGridView estimateContentSizeForItemCount:[translation.translationMembers count]
                                                              attributes:attributes
                                                                maxWidth:maxWidth];
    
    return CGSizeMake(size.width, gridSize.height + insets.top + insets.bottom);
}

- (void)didSelectCellAtIndex:(NSInteger)pathItem {

}

- (id)primaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    __weak typeof(self) wSelf = self;
    
    PDVideoRoomTranslation *translation = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    NSArray *members = [self sortedMembersForTranslation:translation];
    
    PDUniformGridViewPrimaryInfo *gridInfo = [[PDUniformGridViewPrimaryInfo alloc] init];
    gridInfo.itemCountHandler = ^NSUInteger() {
        return [translation.translationMembers count];
    };
    gridInfo.primaryInfoAtIndexHandler = ^id(NSUInteger index, NSString *nibOrClassName) {
        PDVideoRoomMembersListTranslationMemberGridPrimaryInfo *gridItemInfo = [[PDVideoRoomMembersListTranslationMemberGridPrimaryInfo alloc] init];
        gridItemInfo.translationMember = members[index];
        return gridItemInfo;
    };
    gridInfo.itemNibOrClassNameAtIndexHandler = ^NSString *(NSUInteger index) {
        return [PDVideoRoomMembersListTranslationMemberGridCell nibName];
    };

    
    PDVideoRoomMembersListTranslationCellPrimaryInfo *info = [[PDVideoRoomMembersListTranslationCellPrimaryInfo alloc] init];
    info.translation = translation;
    info.joinButtonTapHandler = ^() {
        [[PDAppUsageEventsManager instance] tagEvent:[PDAppUsageEventsEvents videoRoomJoinedTranslation]];
        
        wSelf.viewModel.hideMemberListControllerSignal = [[NSObject alloc] init];
        wSelf.viewModel.activeTranslationId = translation.translationId;
    };
    info.translationMembersGridInfo = gridInfo;
    info.translationMembersGridAttributes = [self gridLayoutAttributes];
    
    NSUInteger memberIndex =
    [translation.translationMembers.allObjects indexOfObjectPassingTest:^BOOL(PDVideoRoomTranslationMember *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.miniProfile.isMeValue;
    }];
    info.isMeInTranslation = memberIndex != NSNotFound;
    return info;
}

- (BOOL)hasSecondaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell atIndex:(NSUInteger)index {
    return YES;
}

- (id)querySecondaryInfoForCell:(UIView<PDGenericCollectionViewCellConfiguration> *)cell
                        atIndex:(NSUInteger)index
                     completion:(void(^)(id info))completion {
    PDVideoRoomTranslation *translation = [self.dataManager entityForIndexPath:[NSIndexPath indexPathForRow:index inSection:self.sectionIndex]];
    NSArray *members = [self sortedMembersForTranslation:translation];
    PDVideoRoomMembersListTranslationMemberGridLoader * loader = self.gridSecondaryInfoLoader;
    NSArray *operations = [loader loadSecondaryInfoForTranslation:translation
                                                       completion:^(PDVideoRoomMembersListTranslationMemberGridLoaderInfo *loaderInfo) {
                                                           if (translation.hasBeenDeleted || translation.isDeleted) {
                                                               completion(nil);
                                                               return;
                                                           }
                                                           PDVideoRoomMembersListTranslationCellSecondaryInfo *info = nil;
                                                           info = [[PDVideoRoomMembersListTranslationCellSecondaryInfo alloc] init];
                                                           info.translationMembersGridInfo = [[PDUniformGridViewSecondaryInfo alloc] init];
                                                           info.translationMembersGridInfo.secondaryInfoAtIndexHandler = ^id(NSUInteger index) {
                                                               return loaderInfo.connectionIdToProfileAvatarImage[[members[index] connectionId]];
                                                           };

                                                           completion(info);
                                                       }];
    return operations ?: nil ;
}

#pragma mark - Helpers

- (PDUniformGridViewLayoutAttributes *)gridLayoutAttributes {
    PDUniformGridViewLayoutAttributes *attributes = [[PDUniformGridViewLayoutAttributes alloc] init];
    
    UIEdgeInsets insets = [PDVideoRoomMembersListTranslationCell translationMembersGridInsets];
    attributes.itemSize = CGSizeMake(self.dataManager.collectionView.frame.size.width - insets.left - insets.right,
                                     [PDVideoRoomMembersListTranslationMemberGridCell defaultHeight]);
    return attributes;
}

- (NSArray *)sortedMembersForTranslation:(PDVideoRoomTranslation *)translation {
    NSArray *members = [translation.translationMembers allObjects];
    
    NSString *isMeKey = [NSString stringWithFormat:@"%@.%@",
                         PDVideoRoomTranslationMemberRelationships.miniProfile,
                         PDMiniProfileAttributes.isMe];
    
    NSSortDescriptor *isMeDescriptor = [NSSortDescriptor sortDescriptorWithKey:isMeKey
                                                                     ascending:YES];
    NSSortDescriptor *translationOrderDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:PDVideoRoomTranslationMemberAttributes.translationOrderId
                                  ascending:YES];
    
    
    members = [members sortedArrayUsingDescriptors:@[isMeDescriptor, translationOrderDescriptor]];
    return members;
}

@end

