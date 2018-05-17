//
//  PDVideoRoomMembersListBottomPanelView.m
//  PlayDay
//
//  Created by Pavel Sokolov on 27/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMembersListBottomPanelView.h"

#import "PDOnePixelSeparatorView.h"

#import "UIColor+PDColorScheme.h"

@interface PDVideoRoomMembersListBottomPanelView ()

/**
 Separator
 */
@property (weak, nonatomic) IBOutlet PDOnePixelSeparatorView *topSeparator;

@end

@implementation PDVideoRoomMembersListBottomPanelView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topSeparator.backgroundColor = [UIColor pd_colorWhite23];
}

- (IBAction)onTapGestureRecognizer:(id)sender {
    self.onTapActionHandler();
}

+ (CGFloat)defaultHeight {
    return 48.;
}

@end
