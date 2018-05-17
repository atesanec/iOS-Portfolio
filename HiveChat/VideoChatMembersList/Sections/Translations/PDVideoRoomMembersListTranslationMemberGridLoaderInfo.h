//
//  PDVideoRoomMembersListTranslationMemberGridLoaderInfo.h
//  PlayDay
//
//  Created by Pavel Sokolov on 29/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDVideoRoomMembersListTranslationMemberGridLoaderInfo : NSObject

/**
 ConnectionId to profile avatar image
 */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIImage *> *connectionIdToProfileAvatarImage;

@end
