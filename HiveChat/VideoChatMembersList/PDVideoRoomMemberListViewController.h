//
//  PDVideoRoomMemberListViewController.h
//  PlayDay
//
//  Created by Pavel Sokolov on 23/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDVideoRoomViewModel;
@class PDVideoRoomMembersListBottomPanelView;

@interface PDVideoRoomMemberListViewController : UIViewController
/**
 *  Bottom panel view
 */
@property (nonatomic, strong, readonly) UIView *bottomPanelView;
/**
 Init

 @param viewModel view model
 @return instance
 */
- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __unavailable;
- (instancetype)init __unavailable;
- (instancetype)initWithCoder:(NSCoder *)aDecoder __unavailable;

@end
