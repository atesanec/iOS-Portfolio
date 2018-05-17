//
//  PDVideoRoomMembersListTranslationCellPrimaryInfo.h
//  PlayDay
//
//  Created by Pavel Sokolov on 28/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

@class PDVideoRoomTranslation;
@class PDUniformGridViewPrimaryInfo;
@class PDUniformGridViewLayoutAttributes;

@interface PDVideoRoomMembersListTranslationCellPrimaryInfo : NSObject 

/**
 Translation
 */
@property (nonatomic, strong) PDVideoRoomTranslation *translation;
/**
 Join button tap handler
 */
@property (nonatomic, copy)   void(^joinButtonTapHandler)(void);
/**
 Translation members grid info
 */
@property (nonatomic, strong) PDUniformGridViewPrimaryInfo *translationMembersGridInfo;
/**
 Translation members grid attributes
 */
@property (nonatomic, strong) PDUniformGridViewLayoutAttributes *translationMembersGridAttributes;
/**
 Is me in translation
 */
@property (nonatomic, assign) BOOL isMeInTranslation;

@end

