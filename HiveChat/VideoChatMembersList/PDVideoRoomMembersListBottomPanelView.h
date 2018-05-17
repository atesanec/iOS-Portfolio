//
//  PDVideoRoomMembersListBottomPanelView.h
//  PlayDay
//
//  Created by Pavel Sokolov on 27/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDVideoRoomMembersListBottomPanelView : UIView

/**
 On tap action handler
 */
@property (nonatomic, copy) void (^onTapActionHandler)();

/**
 Default height

 @return height
 */
+ (CGFloat)defaultHeight;

@end
