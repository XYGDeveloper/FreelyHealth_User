//
//  ContactDateHelper.m
//  Pods
//
//  Created by 展祥叶 on 2017/7/14.
//
//

#import "ContactDateHelper.h"

@interface ContactDateHelper ()
@property (nonatomic, strong) NSArray *dayNames;
@property (nonatomic, strong) NSArray *daySammNames;
@end

@implementation ContactDateHelper

+ (instancetype)sharedInstance {
    static ContactDateHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ContactDateHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        _dayNames = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        _daySammNames = @[@"后天 ", @"明天 ", @"", @"昨天 ", @"前天 "];
    }
    return  self;
}

- (NSString *)getTimeSammName:(NSInteger)hour {
    NSString *am_pm = @"";
    if (hour >= 0 && hour < 6) {
        am_pm = @"凌晨";
    } else if (hour >= 6 && hour < 12) {
        am_pm = @"早上";
    } else if (hour == 12) {
        am_pm = @"中午";
    } else if (hour > 12 && hour < 18) {
        am_pm = @"下午";
    } else if (hour >= 18) {
        am_pm = @"晚上";
    }
    return am_pm;
}

- (NSString *)getTimeWithTime:(NSDate *)date timeFormat:(NSString *)timeFormat {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = timeFormat;
    return [df stringFromDate:date];
}

- (NSString *)getNewChatTime:(NSDate *)date {
    
    NSString *result = @"";
    NSDate *currentDate = [NSDate date];
    
     NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                    | NSHourCalendarUnit | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                    | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit;
    NSDateComponents *todayComponents = [calendar components:unitFlags fromDate:currentDate];
    NSDateComponents *otherComponents = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [otherComponents hour];
    NSString *am_pm = [self getTimeSammName:hour];
    
    NSString *time12Format = [NSString stringWithFormat:@"%@ h:mm", am_pm];
    NSString *time24Format = [NSString stringWithFormat:@"%@ H:mm", am_pm];
    NSString *monthDayFormat = [NSString stringWithFormat:@"M月d日 %@", time24Format];
    NSString *yearDayFormat = [NSString stringWithFormat:@"yyyy年M月d日 %@", time24Format];
    
    NSInteger temp = [currentDate timeIntervalSinceDate:date] / 3600 / 24;
    if (temp >= -2 && temp <= 2) {
        NSString *formatTime = [self getTimeWithTime:date timeFormat:time12Format];
        result = [NSString stringWithFormat:@"%@%@", _daySammNames[temp + 2], formatTime];
    } else {
        NSInteger dayOfMonth = otherComponents.weekOfMonth;
        NSInteger todayOfMonth = todayComponents.weekOfMonth;
        if (dayOfMonth == todayOfMonth) { //表示同一周
            NSInteger dayOfWeek = otherComponents.weekday;
            NSString *formatTime = [self getTimeWithTime:date timeFormat:time24Format];
            result = [NSString stringWithFormat:@"%@%@", _dayNames[dayOfWeek - 1], formatTime];
        } else {
            BOOL yearTemp = todayComponents.year == otherComponents.year;
            if (yearTemp) {
                result = [self getTimeWithTime:date timeFormat:monthDayFormat];
            } else {
                result = [self getTimeWithTime:date timeFormat:yearDayFormat];
            }
        }
    }
    
    
    return result;
}



@end
