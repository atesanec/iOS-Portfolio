//
//  PDVideoRoomMemberListActionManager.m
//  PlayDay
//
//  Created by Marina Shilnikova on 29.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListActionManager.h"
#import "PDVideoRoomViewModel.h"
#import "PDAlertViewBlocksAdapter.h"
#import "PDAlertView.h"
#import "UIViewController+PDControllerHierarchy.h"
#import "PDNewAPIVideoRoomTranslationPersistentAdapter.h"
#import "PDNewPersistentAPI.h"

@interface PDVideoRoomMemberListActionManager ()
/**
 View model
 */
@property (nonatomic, weak) PDVideoRoomViewModel *viewModel;

@end

@implementation PDVideoRoomMemberListActionManager

- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - Internal

- (void)inviteToTranslationForProfileId:(NSNumber *)profileId
                                 chatId:(NSNumber *)chatId
                             completion:(void(^)(BOOL success))completion {
    __weak typeof(self) wSelf = self;
    PDNewAPIVideoRoomTranslationPersistentAdapter *adapter = nil;
    adapter = [[PDNewAPIVideoRoomTranslationPersistentAdapter alloc] initWithAPI:[[PDNewPersistentAPI alloc] init]];
    [adapter inviteToTranslationForProfileId:profileId
                                      chatId:chatId
                                     success:^{
                                         completion(YES);
                                     }
                                     failure:^(NSOperation *operation, NSError *error, BOOL inviteLimitExceeded) {
                                         completion(NO);
                                         if (inviteLimitExceeded) {
                                             [wSelf presentToManyAttemptsAlert];
                                         }
                                     }];
}

- (void)presentToManyAttemptsAlert {
    PDAlertView *alertView = [[PDAlertView alloc] init];
    PDAlertViewBlocksAdapter *alertAdapter = [[PDAlertViewBlocksAdapter alloc] init];
    [alertAdapter attachToAlertView:alertView];
    alertAdapter.titleHandler = ^NSString *() {
        return LOCALIZED(@"AppTitle");
    };
    alertAdapter.messageHandler = ^NSString *() {
        return LOCALIZED(@"video_room_too_many_invites_alert");
    };
    [alertAdapter makeCancelButtonWithTitle:LOCALIZED(@"OK") handler:nil];
    [alertAdapter presentFromViewController:[UIViewController pdTopmostController]];
}

#pragma mark - public

- (void)inviteProfileWithId:(NSNumber *)profileId completion:(void(^)(BOOL success))completion {
    [self inviteToTranslationForProfileId:profileId chatId:nil completion:completion];
}

- (void)inviteChatWithId:(NSNumber *)chatId completion:(void(^)(BOOL success))completion {
    [self inviteToTranslationForProfileId:nil chatId:chatId completion:completion];
}

@end
