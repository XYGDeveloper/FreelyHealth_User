//
//  UdeskSDKStyle.m
//  UdeskSDK
//
//  Created by Udesk on 16/8/29.
//  Copyright © 2016年 Udesk. All rights reserved.
//

#import "UdeskSDKStyle.h"
#import "UdeskSDKStyleBlue.h"

@implementation UdeskSDKStyle

+ (instancetype)createWithStyle:(UDChatViewStyleType)type {
    switch (type) {
        case UDChatViewStyleTypeBlue:
            return [UdeskSDKStyleBlue new];
        default:
            return [UdeskSDKStyle new];
    }
}

+ (instancetype)customStyle {
    return [self createWithStyle:(UDChatViewStyleTypeDefault)];
}

+ (instancetype)defaultStyle {
    return [self createWithStyle:(UDChatViewStyleTypeDefault)];
}

+ (instancetype)blueStyle {
    return [self createWithStyle:(UDChatViewStyleTypeBlue)];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //customer
        self.customerTextColor = [UIColor whiteColor];
        self.customerBubbleColor = [UIColor colorWithHexString:@"#0B84FE"];
        self.customerBubbleImage = [UIImage ud_bubbleSendImage];
        self.customerVoiceDurationColor = [UIColor colorWithHexString:@"#8E8E93"];;
        
        //agent
        self.agentTextColor = [UIColor blackColor];
        self.agentBubbleColor = [UIColor colorWithHexString:@"#F1F0F0"];
        self.agentBubbleImage = [UIImage ud_bubbleReceiveImage];
        self.agentVoiceDurationColor = [UIColor colorWithHexString:@"#8E8E93"];
        
        //im
        self.tableViewBackGroundColor = [UIColor whiteColor];
        self.chatViewControllerBackGroundColor = [UIColor whiteColor];
        self.chatTimeColor = [UIColor colorWithHexString:@"#8E8E93"];
        self.inputViewColor = [UIColor whiteColor];
        self.textViewColor = [UIColor whiteColor];
        self.messageContentFont = [UIFont systemFontOfSize:16];
        self.messageTimeFont = [UIFont systemFontOfSize:12];
        
        //nav
        self.navBackButtonColor = [UIColor colorWithHexString:@"#007AFF"];
        self.navRightButtonColor = [UIColor colorWithHexString:@"#007AFF"];
        self.navBackButtonImage = nil;
        self.navigationColor = [UIColor colorWithRed:0.976f  green:0.976f  blue:0.976f alpha:1];
        self.navBarBackgroundImage = nil;
        
        //title
        self.titleFont = [UIFont systemFontOfSize:16];
        self.titleColor = [UIColor blackColor];
        
        //right
        self.transferButtonColor = [UIColor colorWithHexString:@"#0B84FE"];
        
        //record
        self.recordViewColor = [UIColor colorWithHexString:@"#FAFAFA"];
        
        //faq
        self.searchCancleButtonColor = UDRGBCOLOR(32, 104, 235);
        self.searchContactUsColor = UDRGBCOLOR(32, 104, 235);
        self.contactUsBorderColor = UDRGBCOLOR(32, 104, 235);
        self.promptTextColor = [UIColor darkGrayColor];
        
        //product
        self.productBackGroundColor = [UIColor colorWithHexString:@"#F1F0F0"];
        self.productTitleColor = [UIColor colorWithHexString:@"#000000"];
        self.productDetailColor = [UIColor colorWithHexString:@"#FF3B30"];
        self.productSendBackGroundColor = [UIColor colorWithHexString:@"#FF3B30"];
        self.productSendTitleColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
