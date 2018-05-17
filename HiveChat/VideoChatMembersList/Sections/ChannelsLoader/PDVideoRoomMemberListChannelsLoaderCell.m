//
//  PDPDVideoRoomMemberListChannelsLoaderCell.m
//  PlayDay
//
//  Created by Pavel Sokolov on 12/09/16.
//  Copyright © 2016 Pavel Sokolov. All rights reserved.
//

#import "PDVideoRoomMemberListChannelsLoaderCell.h"

#import "PDActivityIndicatorView.h"

#import "PDVideoRoomMemberListChannelsLoaderCellPrimaryInfo.h"

#import "UIView+PDViewFrameLayoutHelper.h"
#import "UIColor+PDColorScheme.h"

static const CGPoint kPDLabelOffset = {68, 8};

@interface PDVideoRoomMemberListChannelsLoaderCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) PDActivityIndicatorView *loadIndicator;

@end

@implementation PDVideoRoomMemberListChannelsLoaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.text = LOCALIZED(@"video_room_show_more");
    self.textLabel.font = [UIFont pdMediumFontWithSize:13];
    self.textLabel.textColor = [UIColor pd_white60pcColor];
    [self.textLabel sizeToFit];
    [self.contentView addSubview:self.textLabel];
    
    self.loadIndicator = [[PDActivityIndicatorView alloc] init];
    self.loadIndicator.hidesWhenStopped = YES;
    [self.contentView addSubview:self.loadIndicator];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel pdMakeLeft:kPDLabelOffset.x];
    [self.textLabel pdMakeTop:kPDLabelOffset.y];
    [self.loadIndicator pdMakeCenterPosition:self.textLabel.center];
}
#pragma mark - Public

+ (CGFloat)defaultHeight {
    return 40;
}

#pragma mark - PDGenericCollectionViewCellConfiguration

- (void)configureWithPrimaryInfo:(PDVideoRoomMemberListChannelsLoaderCellPrimaryInfo *)info {
    self.textLabel.hidden = info.isLoading;
    self.loadIndicator.animating = info.isLoading;
    
}

@end

