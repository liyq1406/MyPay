//
//  YRDrawCashDetailModel.m
//  YunRichMPCR
//
//  Created by YunRich on 15/5/18.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRDrawCashDetailModel.h"

@implementation YRDrawCashDetailModel

+ (void)getDrawCashDetalWithDateType:(DateDurationType)dateType pageNum:(NSInteger)pageNum drawCashRequest:(id)request successBlock:(void (^)(id))successBlock failureBlock:(void (^)(NSString *))failureBlock {
    
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps=[[NSDateComponents alloc]init];
    NSInteger unitFlags=NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    now=[NSDate date];
    comps=[calendar components:unitFlags fromDate:now];
    NSInteger week=[comps weekday];
    NSInteger year = [comps year];
    NSInteger month=[comps month];
    NSInteger day =[comps day];

    NSString * currentDate = [NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    NSString * startDate = nil;
    switch (dateType) {
        case DateDurationType_Today:
        {
            startDate = currentDate;
        }
            break;
        case DateDurationType_Yesterday:
        {
            startDate = [self calculateCurrentWeekDate:year month:month day:day week:1];
            currentDate = startDate;
        }
            break;
        case DateDurationType_CurrentWeek:
        {
            startDate = [self judgeTime:year month:month day:day week:week];
        }
            break;
        case DateDurationType_CurrentMonth:
        {
            startDate = [NSString stringWithFormat:@"%d%02d%02d",year,month,1];
        }
            break;
        case DateDurationType_ThreeMonth:
        {
            if (month == 2 || month == 1) {
                month = 12 - (2 - month);
                year -= 1;
            }
            startDate = [NSString stringWithFormat:@"%d%02d%02d",year,month,1];
        }
            break;
    }
    NSString * pages = [NSString stringWithFormat:@"%d",pageNum];
    
    NSDictionary * parameters = @{@"BEGINDATE" :startDate ,
                                  @"ENDDATE" : currentDate,
                                  @"PAGESIZE" : @"20",
                                  @"PAGENUM" : pages
                                  };
    [request queryDrawCashRecords:parameters successBlock:^(id responseObject) {
        
         successBlock(responseObject);
    } failureBlock:^(NSString *errInfo) {
        
        failureBlock(errInfo);
    }];
}

+ (NSString *)judgeTime:(NSInteger)year month:(NSInteger)month day:(NSInteger)day week:(NSInteger)week {
    
    NSString * dateStr = nil;
    switch (week) {
        case 1: //周日
        {
            dateStr = [self calculateCurrentWeekDate:year month:month day:day week:6];
            return dateStr;
        }
        case 2: // 周一
        {
            dateStr = [NSString stringWithFormat:@"%d%02d%02d",year,month,day];
            return dateStr;
        }
        case 3: // 周二
        {
            dateStr = [self calculateCurrentWeekDate:year month:month day:day week:1];
            return dateStr;
        }
        case 4: // 周三
        {
            dateStr = [self calculateCurrentWeekDate:year month:month day:day week:2];
            return dateStr;
        }
        case 5: // 周四
        {
            dateStr = [self calculateCurrentWeekDate:year month:month day:day week:3];
            return dateStr;
        }
        case 6: // 周五
        {
            dateStr = [self calculateCurrentWeekDate:year month:month day:day week:4];
            return dateStr;
        }
        case 7: // 周六
        {
            
            dateStr = [self calculateCurrentWeekDate:year month:month day:day week:5];
            return dateStr;
        }
    }
    return dateStr;
}

+ (NSString *)calculateCurrentWeekDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day week:(NSInteger)week {
    
    NSString * dateStr = nil;
    if (day - week > 0) {
        
        day -= week;
    }else {
        
        NSInteger balanceNum = week - day;
        if (month == 1) {
            
            month = 12;
            day = 31 - balanceNum;
            year -= 1;
        }else if (month == 3) {
            
            month -= 1;
            day = 28 - balanceNum;
        }else if (month == 4 || month == 6 || month == 9 || month == 11 || month == 2) {
            
            month -= 1;
            day = 31 - balanceNum;
        }else {
            
            month -= 1;
            day = 30 - balanceNum;
        }
    }
    dateStr = [NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    return dateStr;
}


@end
