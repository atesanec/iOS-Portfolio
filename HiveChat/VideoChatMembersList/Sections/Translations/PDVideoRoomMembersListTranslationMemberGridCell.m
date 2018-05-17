//
//  PDVideoRoomMembersListTranslationMemberGridCell.m
//  PlayDay
//
//  Created by Pavel Sokolov on 28/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMembersListTranslationMemberGridCell.h"

#import "PDAvatarButtonPlaceholderAdapter.h"

#import "PDVideoRoomMembersListTranslationMemberGridPrimaryInfo.h"

#import "PDVideoRoomTranslationMember.h"
#import "PDMiniProfile.h"

#import "PDAvatarButton.h"

#import "UIFont+PDWeightPreset.h"

static const CGSize  kPDAvatarButtonSize = {20.0, 20.0};
static const CGFloat kPDNameLabelLeftOffset = 12.0 + 20.0;

@interface PDVideoRoomMembersListTranslationMemberGridCell ()

// UI elements
@property (nonatomic, strong) PDAvatarButton *avatarButton;
@property (nonatomic, strong) UILabel *nameLabel;

/**
 Placeholder adapter
 */
@property (nonatomic, strong) PDAvatarButtonPlaceholderAdapter *placeholderAdapter;

@end

@implementation PDVideoRoomMembersListTranslationMemberGridCell

#pragma mark - Public

+ (CGFloat)defaultHeight {
    return 26;
}

#pragma mark - Init

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
    self.avatarButton = [[PDAvatarButton alloc] init];
    [self addSubview:self.avatarButton];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont pdSemiboldSystemFontWithSize:16];
    [self addSubview:self.nameLabel];
    
    self.placeholderAdapter = [[PDAvatarButtonPlaceholderAdapter alloc] initWithAvatarButton:self.avatarButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarButton.frame = CGRectMake(0,
                                         (self.bounds.size.height-kPDAvatarButtonSize.height)/2.0,
                                         kPDAvatarButtonSize.width,
                                         kPDAvatarButtonSize.height);
    
    self.nameLabel.frame = CGRectMake(kPDNameLabelLeftOffset,
                                      0,
                                      self.bounds.size.width - kPDNameLabelLeftOffset,
                                      self.bounds.size.height);
}

#pragma mark - Configuration

- (void)configureWithPrimaryInfo:(PDVideoRoomMembersListTranslationMemberGridPrimaryInfo *)info {
    [self.placeholderAdapter setupPlaceholderForString:info.translationMember.miniProfile.fullName
                                                 style:PDAvatarButtonStyleRound
                                            titleStyle:PDAvatarButtonPlaceholderAdapterTitleStyleSingleLetter];
    self.nameLabel.text = info.translationMember.miniProfile.fullName;
}

- (void)configureWithSecondaryInfo:(UIImage *)info {
    if (info) {
        [self.avatarButton setImage:info forState:UIControlStateNormal];
    }
}

@end
