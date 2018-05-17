//
//  PDVideoRoomMemberListAddMembersCell.m
//  PlayDay
//
//  Created by Marina Shilnikova on 30.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListAddMembersCell.h"
#import "PDOnePixelSeparatorView.h"
#import "UIColor+PDColorScheme.h"

static const CGSize kVideoRoomMemberListAddMembersCellImageViewSizeConstant = {40, 40};
static const CGFloat kVideoRoomMemberListAddMembersCellImageViewLeftConstant = 16;
static const CGFloat kVideoRoomMemberListAddMembersCellTextLabelLeftConstant = 68;

@interface PDVideoRoomMemberListAddMembersCell ()

/**
 Icon
 */
@property (nonatomic, strong) UIImageView *icon;
/**
 Text label
 */
@property (nonatomic, strong) UILabel *textLabel;
/**
 Top separator
 */
@property (nonatomic, strong) PDOnePixelSeparatorView *topSeparator;
/**
 Bottom separator
 */
@property (nonatomic, strong) PDOnePixelSeparatorView *bottomSeparator;

@end

@implementation PDVideoRoomMemberListAddMembersCell

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addMemberSms"]];
        [self addSubview:self.icon];
        
        self.textLabel = [[UILabel alloc] init];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor whiteColor]];
        [self.textLabel setText:LOCALIZED(@"video_room_invite_members")];
        [self.textLabel setFont:[UIFont pdSemiboldSystemFontWithSize:16]];
        [self addSubview:self.textLabel];
        
        self.topSeparator = [[PDOnePixelSeparatorView alloc] init];
        self.topSeparator.position = PDOnePixelSeparatorPositionTop;
        self.topSeparator.backgroundColor = [UIColor pd_colorWhite28];
        [self addSubview:self.topSeparator];
        
        self.bottomSeparator = [[PDOnePixelSeparatorView alloc] init];
        self.bottomSeparator.position = PDOnePixelSeparatorPositionBottom;
        self.bottomSeparator.backgroundColor = [UIColor pd_colorWhite28];
        [self addSubview:self.bottomSeparator];
    }
    return self;
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 68.;
}

#pragma mark - default

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(kVideoRoomMemberListAddMembersCellTextLabelLeftConstant,
                                      0,
                                      self.bounds.size.width - kVideoRoomMemberListAddMembersCellTextLabelLeftConstant,
                                      self.bounds.size.height);
    self.icon.frame = CGRectMake(kVideoRoomMemberListAddMembersCellImageViewLeftConstant,
                                 (self.bounds.size.height - kVideoRoomMemberListAddMembersCellImageViewSizeConstant.height)/2.,
                                 kVideoRoomMemberListAddMembersCellImageViewSizeConstant.width,
                                 kVideoRoomMemberListAddMembersCellImageViewSizeConstant.height);
    self.topSeparator.frame = CGRectMake(0,
                                         0,
                                         self.bounds.size.width,
                                         self.topSeparator.bounds.size.height);
    self.bottomSeparator.frame = CGRectMake(0,
                                            self.bounds.size.height-self.bottomSeparator.bounds.size.height,
                                            self.bounds.size.width,
                                            self.bottomSeparator.bounds.size.height);
}

#pragma mark - PDGenericCollectionViewCellConfiguration

- (void)configureWithPrimaryInfo:(id)info {
    //No config
}


@end
