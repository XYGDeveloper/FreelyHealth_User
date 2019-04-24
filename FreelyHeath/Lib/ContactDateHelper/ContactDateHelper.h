//
//  ContactDateHelper.h
//  Pods
//
//  Created by 展祥叶 on 2017/7/14.
//
//

#import <Foundation/Foundation.h>

@interface ContactDateHelper : NSObject
+ (instancetype)sharedInstance;
- (NSString *)getNewChatTime:(NSDate *)date;
@end
