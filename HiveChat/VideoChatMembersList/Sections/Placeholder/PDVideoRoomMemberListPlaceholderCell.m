//
//  PDVideoRoomMemberListPlaceholderCell.m
//  PlayDay
//
//  Created by Marina Shilnikova on 30.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListPlaceholderCell.h"
#import "PDActivityIndicatorView.h"
#import "PDVideoRoomMemberListPlaceholderPrimaryInfo.h"

@interface PDVideoRoomMemberListPlaceholderCell ()

/**
 Placeholder label
 */
@property (nonatomic, strong) UILabel *placeholderLabel;
/**
 Loader indicator view
 */
@property (nonatomic, strong) PDActivityIndicatorView *loaderIndicatorView;

@end

@implementation PDVideoRoomMemberListPlaceholderCell

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholderLabel = [[UILabel alloc] initWithFrame:frame];
        [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
        self.placeholderLabel.font = [PDVideoRoomMemberListPlaceholderCell textAttributes][NSFontAttributeName];
        self.placeholderLabel.textColor = [UIColor whiteColor];
        self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
        self.placeholderLabel.numberOfLines = 0;
        [self addSubview:self.placeholderLabel];
        
        self.loaderIndicatorView = [[PDActivityIndicatorView alloc] initWithFrame:self.frame];
        self.loaderIndicatorView.style = PDActivityIndicatorStyleWhite;
        [self addSubview:self.loaderIndicatorView];
    }
    return self;
}

#pragma mark - public

+ (UIEdgeInsets)placeholderInsets {
    return UIEdgeInsetsMake(72, 24, 72, 24);
}

+ (NSDictionary *)textAttributes {
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:16]
             };
}

#pragma mark - default

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.frame = UIEdgeInsetsInsetRect(self.bounds, [PDVideoRoomMemberListPlaceholderCell placeholderInsets]);
    self.loaderIndicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

#pragma mark - PDGenericCollectionViewCellConfiguration

- (void)configureWithPrimaryInfo:(PDVideoRoomMemberListPlaceholderPrimaryInfo *)info {
    self.placeholderLabel.text = info.placeholderText;
    [self.loaderIndicatorView setAnimating:info.showLoader];
    self.placeholderLabel.hidden = info.showLoader;
}

@end
