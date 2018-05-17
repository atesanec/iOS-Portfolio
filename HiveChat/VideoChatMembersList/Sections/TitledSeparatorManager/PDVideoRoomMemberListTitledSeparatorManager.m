//
//  PDVideoRoomMemberListTitledSeparatorManager.m
//  PlayDay
//
//  Created by Pavel Sokolov on 01/11/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListTitledSeparatorManager.h"

#import "PDNewAPIGenericCollectionViewDataManager.h"

#import "PDVideoRoomMemberListTitledSeparatorView.h"

#import "PDCollectionViewSeparatorFlowLayout.h"

#import "PDVideoRoomMemberListTitledSeparatorPrimaryInfo.h"

#import "UIView+PDDefaultCellIdentifiers.h"

@implementation PDVideoRoomMemberListTitledSeparatorManager
@synthesize dataManager;
@synthesize sectionIndex;

- (BOOL)hasSeparatorAtIndex:(NSUInteger)index {
    return index == 0;
}

- (CGFloat)separatorHeightAtIndex:(NSUInteger)index {
    return [PDVideoRoomMemberListTitledSeparatorView defaultHeight];
}

- (id)separatorItemAtIndex:(NSUInteger)index {
    PDVideoRoomMemberListTitledSeparatorPrimaryInfo *info = [[PDVideoRoomMemberListTitledSeparatorPrimaryInfo alloc] init];
    info.text = self.text;
    return info;
}

- (NSString *)reuseIdForSeparatorAtIndex:(NSUInteger)index {
    return [PDVideoRoomMemberListTitledSeparatorView reuseId];
}

- (void)registerSectionSeparatorsForCollectionView:(UICollectionView*)collectionView {
    [collectionView registerClass:[PDVideoRoomMemberListTitledSeparatorView class]
       forSupplementaryViewOfKind:kPDCollectionViewSeparatorFlowLayoutSeparatorKind
              withReuseIdentifier:[PDVideoRoomMemberListTitledSeparatorView reuseId]];
}

@end
