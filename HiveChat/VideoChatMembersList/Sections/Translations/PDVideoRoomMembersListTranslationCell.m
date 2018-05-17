//
//  PDVideoRoomMembersListTranslationCell.m
//  PlayDay
//
//  Created by Pavel Sokolov on 28/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMembersListTranslationCell.h"

#import "PDVideoRoomMembersListTranslationCellPrimaryInfo.h"
#import "PDVideoRoomMembersListTranslationCellSecondaryInfo.h"

#import "PDUniformGridView.h"

#import "PDVideoRoomTranslation.h"
#import "UIView+PDViewFrameLayoutHelper.h"

static const CGFloat kPDRightOffset = 16.0;
static const CGSize  kPDJoinButtonSize = {60.0, 32.0};
static const UIEdgeInsets kPDTranslationMembersGridInsets = {8, 36, 8, 16+60+kPDRightOffset};
static const CGFloat kOffsetBetweenLockAndHereLabel = 0;

@interface PDVideoRoomMembersListTranslationCell ()

// UI elements
@property (nonatomic, strong) PDUniformGridView *translationMembersGrid;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UILabel *hereLabel;
@property (nonatomic, strong) UILabel *lockMarkLabel;

/**
 Join button tap handler
 */
@property (nonatomic, copy)   void(^joinButtonTapHandler)(void);

@end

@implementation PDVideoRoomMembersListTranslationCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self == nil) {
        return self;
    }

    [self innerInit];
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self == nil) {
        return self;
    }

    [self innerInit];
 
    return self;
}

- (void)innerInit {
    self.translationMembersGrid = [[PDUniformGridView alloc] init];
    [self.contentView addSubview:self.translationMembersGrid];
    
    self.joinButton = [[UIButton alloc] init];
    self.joinButton.titleLabel.font = [UIFont pdMediumFontWithSize:13];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"rectangle3"] forState:UIControlStateNormal];
    [self.joinButton setTitle:LOCALIZED(@"video_room_join") forState:UIControlStateNormal];
    [self.joinButton addTarget:self action:@selector(onJoinButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.joinButton];
    
    self.hereLabel = [[UILabel alloc] init];
    self.hereLabel.font = [UIFont pdMediumFontWithSize:13];
    self.hereLabel.textColor = [UIColor whiteColor];
    self.hereLabel.textAlignment = NSTextAlignmentCenter;
    self.hereLabel.text = LOCALIZED(@"video_room_you_are_here");
    [self.hereLabel sizeToFit];
    [self.contentView addSubview:self.hereLabel];
    
    self.lockMarkLabel = [[UILabel alloc] init];
    self.lockMarkLabel.font = [UIFont systemFontOfSize:15];
    self.lockMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.lockMarkLabel.text = @"🔒";
    [self.lockMarkLabel sizeToFit];
    [self.contentView addSubview:self.lockMarkLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.translationMembersGrid.frame = UIEdgeInsetsInsetRect(self.bounds, [[self class] translationMembersGridInsets]);
    self.joinButton.frame = CGRectMake(self.bounds.size.width - kPDJoinButtonSize.width - kPDRightOffset,
                                       (self.bounds.size.height-kPDJoinButtonSize.height)/2.0,
                                       kPDJoinButtonSize.width,
                                       kPDJoinButtonSize.height);
    [self.hereLabel pdMakeCenterPositionX:self.joinButton.center.x];
    [self.hereLabel pdMakeCenterY];

    [self.lockMarkLabel pdMakeCenterY];
    if (self.hereLabel.hidden) {
        [self.lockMarkLabel pdMakeCenterPositionX:self.hereLabel.pdCenter.x];
    } else {
        [self.lockMarkLabel pdMakeFromView:self.hereLabel left:kOffsetBetweenLockAndHereLabel];
    }
}

- (void)onJoinButtonTap:(UIButton *)sender {
    self.joinButtonTapHandler();
}

#pragma mark - Public

+ (UIEdgeInsets)translationMembersGridInsets {
    return kPDTranslationMembersGridInsets;
}

#pragma mark - PDGenericCollectionViewCellConfiguration

- (void)configureWithPrimaryInfo:(PDVideoRoomMembersListTranslationCellPrimaryInfo *)info {
    self.joinButtonTapHandler = info.joinButtonTapHandler;
    
    [self.translationMembersGrid configureWithPrimaryInfo:info.translationMembersGridInfo];
    self.translationMembersGrid.layoutAttributes = info.translationMembersGridAttributes;

    self.joinButton.hidden = info.isMeInTranslation || info.translation.isLockedValue;
    self.hereLabel.hidden = !info.isMeInTranslation;
    self.lockMarkLabel.hidden = !info.translation.isLockedValue;
    
    [self setNeedsLayout];
}

- (void)configureWithSecondaryInfo:(PDVideoRoomMembersListTranslationCellSecondaryInfo *)info {
    if (info == nil) {
        return;
    }
    [self.translationMembersGrid configureWithSecondaryInfo:info.translationMembersGridInfo];
}

@end

