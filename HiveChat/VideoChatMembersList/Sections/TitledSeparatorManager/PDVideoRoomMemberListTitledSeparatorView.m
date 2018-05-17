//
//  PDVideoRoomMemberListTitledSeparatorView.m
//  PlayDay
//
//  Created by Pavel Sokolov on 01/11/2017.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListTitledSeparatorView.h"

#import "PDOnePixelSeparatorView.h"

#import "PDVideoRoomMemberListTitledSeparatorPrimaryInfo.h"

#import "UIColor+PDColorScheme.h"
#import "UIView+PDViewFrameLayoutHelper.h"

static CGFloat const kSeparatorViewTopInset = 8.;
static UIEdgeInsets const kLabelInsets = {20, 16, 12, 16};

@interface PDVideoRoomMemberListTitledSeparatorView ()
/**
 Separator view
 */
@property (nonatomic, strong) PDOnePixelSeparatorView *separatorView;
/**
 Title label
 */
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation PDVideoRoomMemberListTitledSeparatorView

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.separatorView = [[PDOnePixelSeparatorView alloc] initWithFrame:self.bounds];
    self.separatorView.backgroundColor = [UIColor pd_colorWhite14];
    [self addSubview:self.separatorView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont pdMediumFontWithSize:13];
    self.titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    [self addSubview:self.titleLabel];

    return self;
}

#pragma mark - public

+ (CGFloat)defaultHeight {
    return 48.;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.separatorView.frame;
    frame.origin.y = kSeparatorViewTopInset;
    frame.size.width = self.bounds.size.width;
    self.separatorView.frame = frame;
    
    [self.titleLabel pdMakeEdgeInsets:kLabelInsets];
}

#pragma mark - configuration

- (void)configureWithPrimaryInfo:(PDVideoRoomMemberListTitledSeparatorPrimaryInfo *)info {
    self.titleLabel.text = info.text;
}

@end
