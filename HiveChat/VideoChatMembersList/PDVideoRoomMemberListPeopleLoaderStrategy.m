//
//  PDVideoRoomMemberListPeopleLoaderStrategy.m
//  PlayDay
//
//  Created by Marina Shilnikova on 29.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListPeopleLoaderStrategy.h"

#import "PDNewPersistentAPI.h"
#import "PDNewAPIVideoRoomTranslationPersistentAdapter.h"
#import "PDNewAPIPersistentOffsetPagerAdapter.h"
#import "PDVideoRoomViewModel.h"
#import "PDCircle.h"
#import "PDNewAPIPager.h"
#import "PDMiniProfileListItem.h"
#import "PDNewAPIResourcePaths.h"
#import "PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo.h"

@interface PDVideoRoomMemberListPeopleLoaderStrategy ()
/**
 View model
 */
@property (nonatomic, weak) PDVideoRoomViewModel *viewModel;
/**
 *  Step up pager
 */
@property (nonatomic, strong) id<PDNewAPIPager> stepDownPager;
/**
 *  Client for server, saves results to persistent storage
 */
@property (nonatomic, strong) PDNewPersistentAPI *persistentAPI;
/**
 Section Item
 */
@property (nonatomic, strong) id dataManagerSectionItem;

@end

@implementation PDVideoRoomMemberListPeopleLoaderStrategy

#pragma mark - Initialization

- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.persistentAPI = [[PDNewPersistentAPI alloc] init];
    self.persistentAPI.autoSaveToPersistentStore = YES;
    
    self.viewModel = viewModel;
    self.dataManagerSectionItem = [self generateDataManagerSectionItem];
    
    return self;
}

- (id)generateDataManagerSectionItem {
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:[PDMiniProfileListItem entityName]];
    NSMutableArray *subpredicates = [[NSMutableArray alloc] init];
    // path
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"%K = %@",
                              PDMiniProfileListItemAttributes.urlPath,
                              [PDNewAPIResourcePaths streamingProfileListInCircle]]];
    //circle id
    [subpredicates addObject: [NSPredicate predicateWithFormat:@"%K = %@",
                               PDMiniProfileListItemAttributes.circleId,
                               self.viewModel.circle.circleId]];
    
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:PDMiniProfileListItemAttributes.page ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:PDMiniProfileListItemAttributes.pageOffset ascending:YES]];
    
    PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo *sectionItem = [[PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo alloc] init];
    sectionItem.fetchRequest = request;
    sectionItem.trackedRelationKeys = @[ PDMiniProfileListItemRelationships.miniProfile ];
    return sectionItem;
}

#pragma mark - PDNewAPIEntityListLoaderStrategy methods

- (id<PDNewAPIPager>)stepUpPager {
    return nil;
}

- (id<PDNewAPIPager>)stepDownPager {
    if (_stepDownPager != nil) {
        return _stepDownPager;
    }
    
    PDNewAPIVideoRoomTranslationPersistentAdapter *adapter = [[PDNewAPIVideoRoomTranslationPersistentAdapter alloc] initWithAPI:self.persistentAPI];
    _stepDownPager = [adapter groupMemberListPagerForCircleId:self.viewModel.circle.circleId];
    return _stepDownPager;
}
@end
