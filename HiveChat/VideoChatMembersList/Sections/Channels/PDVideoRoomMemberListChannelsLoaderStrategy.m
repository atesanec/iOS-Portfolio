//
//  PDVideoRoomMemberListChannelsLoaderStrategy.m
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListChannelsLoaderStrategy.h"

#import "PDNewPersistentAPI.h"
#import "PDNewAPIVideoRoomTranslationPersistentAdapter.h"
#import "PDNewAPIPager.h"
#import "PDNewAPIPersistentObjectIdPagerAdapter.h"

#import "PDMiniChatListItem.h"
#import "PDMiniPost.h"

#import "PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo.h"

#import "PDNewAPIResourcePaths.h"

@interface PDVideoRoomMemberListChannelsLoaderStrategy ()
/**
 Circle id
 */
@property (nonatomic, strong) NSNumber *circleId;
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

@implementation PDVideoRoomMemberListChannelsLoaderStrategy

#pragma mark - Initialization

- (instancetype)initWithCircleId:(NSNumber *)circleId {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.persistentAPI = [[PDNewPersistentAPI alloc] init];
    self.persistentAPI.autoSaveToPersistentStore = YES;
    
    self.circleId = circleId;
    self.dataManagerSectionItem = [self generateDataManagerSectionItem];
    
    return self;
}

- (id)generateDataManagerSectionItem {
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:[PDMiniChatListItem entityName]];
    NSMutableArray *subpredicates = [[NSMutableArray alloc] init];
    // path
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"%K = %@",
                              PDMiniChatListItemAttributes.urlPath,
                              [PDNewAPIResourcePaths postStreamingList]]];
    //circle id
    [subpredicates addObject: [NSPredicate predicateWithFormat:@"%K = %@",
                               PDMiniChatListItemAttributes.circleId,
                               self.circleId]];
    
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:PDMiniChatListItemAttributes.postTitle ascending:YES]];
    
    PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo *sectionItem = [[PDNewAPIGenericCollectionViewDataManagerEntitySectionInfo alloc] init];
    sectionItem.fetchRequest = request;
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
    _stepDownPager = [adapter channelsListPagerForCircleId:self.circleId];
    return _stepDownPager;
}
@end
