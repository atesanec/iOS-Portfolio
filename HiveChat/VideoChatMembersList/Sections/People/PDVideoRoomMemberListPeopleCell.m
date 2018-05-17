//
//  PDVideoRoomMemberListPeopleCell.m
//  PlayDay
//
//  Created by Marina Shilnikova on 29.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListPeopleCell.h"
#import "PDVideoRoomMemberListPeopleSectionPrimaryInfo.h"
#import "UIView+PDLocalized.h"
#import "PDAvatarButton.h"
#import "PDAvatarButtonPlaceholderAdapter.h"
#import "PDGenericMemberListInviteButtonAnimationAdapter.h"
#import "PDMiniProfileListItem.h"
#import "PDMiniProfile.h"
#import "PDGenericUnidirectionalEventChannel.h"

static const CGSize kVideoRoomMemberListPeopleCellAvatarButtonSize = {40, 40};
static const CGFloat kVideoRoomMemberListPeopleCellAvatarButtonLeftOffset = 16;
static const CGFloat kVideoRoomMemberListPeopleCellNameLabelLeftOffset = 16+40+12;
static const CGFloat kVideoRoomMemberListPeopleCellNameLabelRightOffset = 16+60+16+8;
static const CGFloat kVideoRoomMemberListPeopleCellNameLabelFontSize = 16;
static const CGSize kVideoRoomMemberListPeopleCellInviteButtonSize = {60, 32};
static const CGFloat kVideoRoomMemberListPeopleCellInviteButtonLeftOffset = 16;
static const CGFloat kVideoRoomMemberListPeopleCellInviteButtonFontSize = 26;
static const NSString *kVideoRoomMemberListPeopleCellInviteButtonTitle = @"👋";
static const CGFloat kVideoRoomMemberListPeopleCellLiveLabelFontSize = 13;

@interface PDVideoRoomMemberListPeopleCell ()
/**
 Avatar button
 */
@property (nonatomic, strong) PDAvatarButton *avatarButton;
/**
 Name label
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 Invite button
 */
@property (nonatomic, strong) UIButton *inviteButton;
/**
 Live label
 */
@property (nonatomic, strong) UILabel *liveLabel;
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

@implementation PDVideoRoomMemberListPeopleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarButton = [[PDAvatarButton alloc] initWithFrame:(CGRect){CGPointZero, kVideoRoomMemberListPeopleCellAvatarButtonSize}];
        self.avatarButton.userInteractionEnabled = NO;
        [self.contentView addSubview:self.avatarButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self.nameLabel setFont:[UIFont pdSemiboldSystemFontWithSize:kVideoRoomMemberListPeopleCellNameLabelFontSize]];
        [self.nameLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.nameLabel];
        
        self.inviteButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, kVideoRoomMemberListPeopleCellInviteButtonSize}];
        [self.inviteButton.titleLabel setFont:[UIFont systemFontOfSize:kVideoRoomMemberListPeopleCellInviteButtonFontSize]];
        [self.inviteButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.inviteButton setTitle:(NSString *)kVideoRoomMemberListPeopleCellInviteButtonTitle forState:UIControlStateNormal];
        [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"button_translation_invite"] forState:UIControlStateNormal];
        [self.inviteButton addTarget:self action:@selector(onInvite:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.inviteButton];
        
        self.liveLabel = [[UILabel alloc] initWithFrame:self.inviteButton.frame];
        [self.liveLabel setFont:[UIFont pdMediumFontWithSize:kVideoRoomMemberListPeopleCellLiveLabelFontSize]];
        [self.liveLabel setTextColor:[UIColor whiteColor]];
        [self.liveLabel setText:LOCALIZED(@"video_room_live")];
        [self.liveLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.liveLabel];

        self.animationAdapter = [[PDGenericMemberListInviteButtonAnimationAdapter alloc] initWithButton:self.inviteButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.avatarButton.frame;
    frame.origin.x = kVideoRoomMemberListPeopleCellAvatarButtonLeftOffset;
    frame.origin.y = (self.bounds.size.height - kVideoRoomMemberListPeopleCellAvatarButtonSize.height) / 2;
    self.avatarButton.frame = frame;
    
    self.nameLabel.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0,
                                                                               kVideoRoomMemberListPeopleCellNameLabelLeftOffset,
                                                                               0,
                                                                               kVideoRoomMemberListPeopleCellNameLabelRightOffset));
    
    frame = self.inviteButton.frame;
    frame.origin.x = self.bounds.size.width - kVideoRoomMemberListPeopleCellInviteButtonSize.width -
    kVideoRoomMemberListPeopleCellInviteButtonLeftOffset;
    frame.origin.y = (self.bounds.size.height - kVideoRoomMemberListPeopleCellInviteButtonSize.height) / 2;
    self.inviteButton.frame = frame;
    
    self.liveLabel.frame = self.inviteButton.frame;
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

- (void)configureWithPrimaryInfo:(PDVideoRoomMemberListPeopleSectionPrimaryInfo *)info {
    self.nameLabel.text = info.profileItem.miniProfile.fullName;
    self.inviteButton.hidden = info.isLive;
    self.liveLabel.hidden = !info.isLive;
    self.inviteButtonTapHandler = info.inviteButtonTapHandler;
    
    PDAvatarButtonPlaceholderAdapter *placeholderAdapter = [[PDAvatarButtonPlaceholderAdapter alloc] initWithAvatarButton:self.avatarButton];
    [placeholderAdapter setupPlaceholderForMiniProfile:info.profileItem.miniProfile];
    
    self.eventChannel = info.eventChannel;
    __weak typeof(self) wSelf = self;
    self.eventChannel.eventHandler = ^(id event) {
        [wSelf.animationAdapter animateInvitationSentPrompt];
    };
}

- (void)configureWithSecondaryInfo:(UIImage *)image {
    if (image) {
        [self.avatarButton setImage:image forState:UIControlStateNormal];
    }
}

#pragma mark - actions

- (IBAction)onInvite:(id)sender {
    self.inviteButtonTapHandler();
}

@end
