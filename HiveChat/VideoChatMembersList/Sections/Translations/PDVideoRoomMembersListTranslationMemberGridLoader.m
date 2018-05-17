//
//  PDVideoRoomMembersListTranslationMemberGridLoader.m
//  PlayDay
//
//  Created by Pavel Sokolov on 29/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMembersListTranslationMemberGridLoader.h"

#import "PDVideoRoomMembersListTranslationMemberGridLoaderInfo.h"
#import "PDImages.h"

#import "PDVideoRoomTranslation.h"
#import "PDVideoRoomTranslationMember.h"
#import "PDMiniProfile.h"
#import "PDImage.h"
#import "NSManagedObject+RKAdditions.h"

@implementation PDVideoRoomMembersListTranslationMemberGridLoader

- (NSArray *)loadSecondaryInfoForTranslation:(PDVideoRoomTranslation *)translation
                                  completion:(void(^)(PDVideoRoomMembersListTranslationMemberGridLoaderInfo *))completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *operations = [NSMutableArray array];
    
    PDVideoRoomMembersListTranslationMemberGridLoaderInfo *gridInfo = [[PDVideoRoomMembersListTranslationMemberGridLoaderInfo alloc] init];
    gridInfo.connectionIdToProfileAvatarImage = [NSMutableDictionary dictionary];
    
    for (PDVideoRoomTranslationMember *member in translation.translationMembers) {
        dispatch_group_enter(group);
        NSOperation *operation = [PDImages load:member.miniProfile.avatar.url
                                          width:PDImagesSizePresetTiny
                                         height:PDImagesSizePresetTiny
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            if (member.hasBeenDeleted == NO && member.isDeleted == NO) {
                                                gridInfo.connectionIdToProfileAvatarImage[member.connectionId] = image;
                                            }
                                            dispatch_group_leave(group);
                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            dispatch_group_leave(group);
                                        }];
        if (operation) {
            [operations addObject:operation];
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(gridInfo);
    });
    
    return operations.count > 0 ? operations : nil;
}

@end
