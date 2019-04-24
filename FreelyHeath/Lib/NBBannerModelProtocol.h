//
//  NBBannerModelProtocol.h
//  页面分离
//
//  Created by xxzx on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NBBannerModelProtocol <NSObject>
/**  图片 */
@property (nonatomic, copy, readonly) NSURL *adImgURL;
/**  标题 */
@property (nonatomic, copy) NSString *title;
@end
