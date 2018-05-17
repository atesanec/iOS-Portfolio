//
//  PDVideoRoomMemberListPlaceholderCell.h
//  PlayDay
//
//  Created by Marina Shilnikova on 30.03.17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDGenericCollectionViewCellConfiguration.h"

/**
 Placeholder cell for video room member list
 */
@interface PDVideoRoomMemberListPlaceholderCell : UICollectionViewCell <PDGenericCollectionViewCellConfiguration>

/**
 Placeholder insets
 */
+ (UIEdgeInsets)placeholderInsets;
/**
 Text attributes
 */
+ (NSDictionary *)textAttributes;

@end
