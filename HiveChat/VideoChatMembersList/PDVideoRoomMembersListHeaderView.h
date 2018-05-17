//
//  PDVideoRoomMembersListHeaderView.h
//  PlayDay
//
//  Created by Pavel Sokolov on 24/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDVideoRoomViewModel;

@interface PDVideoRoomMembersListHeaderView : UIView

/**
 Default height

 @return height
 */
+ (CGFloat)defaultHeight;
/**
 Configure with view model

 @param viewModel model
 */
- (void)configureWithViewModel:(PDVideoRoomViewModel *)viewModel;

@end
