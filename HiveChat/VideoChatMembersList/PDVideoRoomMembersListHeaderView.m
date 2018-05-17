//
//  PDVideoRoomMembersListHeaderView.m
//  PlayDay
//
//  Created by Pavel Sokolov on 24/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMembersListHeaderView.h"

#import "PDAvatarButtonPlaceholderAdapter.h"
#import "PDDeviceInfo.h"

#import "PDAvatarButton.h"
#import "PDOnePixelSeparatorView.h"

#import "PDVideoRoomViewModel.h"

#import "PDCircle.h"

#import "UIColor+PDColorScheme.h"
#import "UIViewController+PDControllerHierarchy.h"
#import "UIView+PDViewFrameLayoutHelper.h"

static const CGFloat kPDDefaultHeight = 48;

@interface PDVideoRoomMembersListHeaderView ()

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PDOnePixelSeparatorView *bottomSeparatorView;

@end

@implementation PDVideoRoomMembersListHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomSeparatorView.backgroundColor = [UIColor pd_colorWhite28];
}

#pragma mark - Public

- (void)configureWithViewModel:(PDVideoRoomViewModel *)viewModel {
    self.titleLabel.text = viewModel.circle.title;
}

+ (CGFloat)defaultHeight {
    return kPDDefaultHeight + [UIView pdSafeAreaInsets].top;
}

@end
