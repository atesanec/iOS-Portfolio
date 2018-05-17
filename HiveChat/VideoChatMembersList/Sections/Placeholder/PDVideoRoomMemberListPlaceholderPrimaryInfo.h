//
//  PDVideoRoomMemberListPlaceholderPrimaryInfo.h
//  PlayDay
//
//  Created by Marina Shilnikova on 30.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Primary info for video room member list placeholder cell
 */
@interface PDVideoRoomMemberListPlaceholderPrimaryInfo : NSObject

/**
 Placeholder text
 */
@property (nonatomic, strong) NSString *placeholderText;

/**
 Show loader
 */
@property (nonatomic, assign) BOOL showLoader;

@end
