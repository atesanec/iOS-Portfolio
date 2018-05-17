//
//  PDVideoRoomMembersListTranslationMemberGridLoader.h
//  PlayDay
//
//  Created by Pavel Sokolov on 29/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDVideoRoomTranslation;
@class PDVideoRoomMembersListTranslationMemberGridLoaderInfo;

@interface PDVideoRoomMembersListTranslationMemberGridLoader : NSObject

/**
 Load secondary info

 @param translation translation
 @param completion completion
 */
- (NSArray *)loadSecondaryInfoForTranslation:(PDVideoRoomTranslation *)translation
                                  completion:(void(^)(PDVideoRoomMembersListTranslationMemberGridLoaderInfo *))completion;

@end
