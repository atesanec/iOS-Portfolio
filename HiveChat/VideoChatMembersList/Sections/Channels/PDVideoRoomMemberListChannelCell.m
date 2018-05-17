//
//  PDVideoRoomMemberListChannelCell.m
//  PlayDay
//
//  Created by Pavel Sokolov on 31/10/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListChannelCell.h"

#import "PDGenericMemberListInviteButtonAnimationAdapter.h"
#import "PDGenericUnidirectionalEventChannel.h"

#import "PDVideoRoomMemberListChannelsSectionPrimaryInfo.h"

#import "UIFont+PDWeightPreset.h"

static const CGFloat kPDChannelTypeImageSizeWidth = 20;

static const CGSize kPDChannelTypeImageSize = {kPDChannelTypeImageSizeWidth, 20};
static const CGFloat kPDChannelTypeImageLeftOffset = 36;

static const CGSize kPDInviteButtonSize = {60, 32};
static const CGFloat kPDInviteButtonLeftOffset = 16;
static const CGFloat kPDInviteButtonFontSize = 26;
static NSString *const kPDInviteButtonTitle = @"👋";

static const CGFloat kPDNameLabelFontSize = 16;
static const CGFloat kPDNameLabelLeftOffset = kPDChannelTypeImageLeftOffset+kPDChannelTypeImageSizeWidth+12;
static const CGFloat kPDNameLabelRightOffset = 16+60+kPDInviteButtonLeftOffset+8;


@interface PDVideoRoomMemberListChannelCell ()
/**
 Image view
 */
@property (nonatomic, strong) UIImageView *channelTypeImageView;
/**
 Name label
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 Invite button
 */
@property (nonatomic, strong) UIButton *inviteButton;
/**
 Invite button tap handler
 */
@property (nonatomic, copy) void(^inviteButtonTapHandler)();
/**
 Animation adapter
 */
@property (nonatomic, strong) PDGenericMemberListInviteButtonAnimationAdapter *animationAdapter;
/**
 Event channel
 */
@property (nonatomic, strong) PDGenericUnidirectionalEventChannel *eventChannel;

@end

@implementation PDVideoRoomMemberListChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.channelTypeImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, kPDChannelTypeImageSize}];
        self.channelTypeImageView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.channelTypeImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.nameLabel setFont:[UIFont pdSemiboldSystemFontWithSize:kPDNameLabelFontSize]];
        [self.nameLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.nameLabel];
        
        self.inviteButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, kPDInviteButtonSize}];
        [self.inviteButton.titleLabel setFont:[UIFont systemFontOfSize:kPDInviteButtonFontSize]];
        [self.inviteButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.inviteButton setTitle:kPDInviteButtonTitle forState:UIControlStateNormal];
        [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"button_translation_invite"] forState:UIControlStateNormal];
        [self.inviteButton addTarget:self action:@selector(onInvite:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.inviteButton];
        
        self.animationAdapter = [[PDGenericMemberListInviteButtonAnimationAdapter alloc] initWithButton:self.inviteButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.channelTypeImageView.frame;
    frame.origin.x = kPDChannelTypeImageLeftOffset;
    frame.origin.y = (self.bounds.size.height - kPDChannelTypeImageSize.height) / 2;
    self.channelTypeImageView.frame = frame;
    
    self.nameLabel.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0,
                                                                               kPDNameLabelLeftOffset,
                                                                               0,
                                                                               kPDNameLabelRightOffset));
    
    frame = self.inviteButton.frame;
    frame.origin.x = self.bounds.size.width - kPDInviteButtonSize.width - kPDInviteButtonLeftOffset;
    frame.origin.y = (self.bounds.size.height - kPDInviteButtonSize.height) / 2;
    self.inviteButton.frame = frame;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.animationAdapter stopAllAnimations];
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 52;
}

#pragma mark - configuration

- (void)configureWithPrimaryInfo:(PDVideoRoomMemberListChannelsSectionPrimaryInfo *)info {
    self.nameLabel.text = info.channelName;
    self.inviteButtonTapHandler = info.inviteButtonTapHandler;
    switch (info.itemType) {
        case PDVideoRoomMemberListChannelsItemTypeOpen:
            self.channelTypeImageView.image = [UIImage imageNamed:@"icPublicChannelVideoroom"];
            break;
        case PDVideoRoomMemberListChannelsItemTypeBroadcast:
            self.channelTypeImageView.image = [UIImage imageNamed:@"icRssChannelVideoroom"];
            break;
        case PDVideoRoomMemberListChannelsItemTypePrivate:
            self.channelTypeImageView.image = [UIImage imageNamed:@"icPrivateChannelVideoroom"];
            break;

        default:
            NSAssert(NO, @"Unexpected chat type");
            break;
    }
    
    self.eventChannel = info.eventChannel;
    __weak typeof(self) wSelf = self;
    self.eventChannel.eventHandler = ^(id event) {
        [wSelf.animationAdapter animateInvitationSentPrompt];
    };
}

#pragma mark - actions

- (void)onInvite:(id)sender {
    self.inviteButtonTapHandler();
}

@end
