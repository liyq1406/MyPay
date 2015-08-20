//
//  YRSignView.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/27.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRSignView.h"

@interface YRSignView()
{
    //每次触摸结束前经过的点，形成线的点数组
    NSMutableArray *_pointArray;
    //每次触摸结束后的线数组
    NSMutableArray *_lineArray;
    //删除的线的数组，方便重做时取出来
    NSMutableArray *_deleArray;
}

@end

@implementation YRSignView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //初始化颜色数组，将用到的颜色存储到数组里
        _pointArray=[[NSMutableArray alloc]init];
        
        //线条数组
        _lineArray=[[NSMutableArray alloc]init];
        _deleArray=[[NSMutableArray alloc]init];
    
    }
    return self;
}

//uiview默认的drawRect方法，覆盖重写，可在界面上重绘
-(void)drawRect:(CGRect)rect{
    
    //获取当前上下文
    self.isEmptyName = NO;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 5.0f);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    //线条拐角样式，平滑
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //线条开始样式，平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    
    //查看line中是否有线条，有就将之前的重画，没有就画当前
    if (_lineArray.count > 0) {
        for (int i = 0; i < _lineArray.count; i++) {
            NSArray * array = [NSArray arrayWithArray:[_lineArray objectAtIndex:i]];
            
            if (array.count > 0) {
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j = 0; j < array.count - 1; j++) {
                    CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                    //--------------------------------------------------------
                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                }
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    
    //画当前线
    if (_pointArray.count > 0) {
        CGContextBeginPath(context);
        CGPoint myStartPoint=CGPointFromString([_pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for (int j=0; j<[_pointArray count]-1; j++)
        {
            CGPoint myEndPoint=CGPointFromString([_pointArray objectAtIndex:j+1]);
            //--------------------------------------------------------
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        CGContextStrokePath(context);
    }
    
    else{
        self.isEmptyName = YES;
    }
    
}

//在touch结束前将获取到的点，放到pointArray里
-(void)addPA:(CGPoint)nPoint{
    NSString *sPoint=NSStringFromCGPoint(nPoint);
    [_pointArray addObject:sPoint];
}

//在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
-(void)addLA{
//    NSNumber *wid=[[NSNumber alloc]initWithInt:widthCount];
//    NSNumber *num=[[NSNumber alloc]initWithInt:colorCount];
//    [colorArray addObject:num];
//    [WidthArray addObject:wid];
    NSArray *array=[NSArray arrayWithArray:_pointArray];
    [_lineArray addObject:array];
    _pointArray=[[NSMutableArray alloc]init];
}

//手指开始触屏开始
static CGPoint MyBeganpoint;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch=[touches anyObject];
    MyBeganpoint=[touch locationInView:self];
    NSString *sPoint=NSStringFromCGPoint(MyBeganpoint);
    [_pointArray addObject:sPoint];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addLA];
    
}

//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

//撤销，将当前最后一条信息移动到删除数组里，方便恢复时调用
-(void)revocation{
    if ([_lineArray count]) {
        [_deleArray addObject:[_lineArray lastObject]];
        [_lineArray removeLastObject];
    }

    //界面重绘方法
    [self setNeedsDisplay];
}

//将删除线条数组里的信息，移动到当前数组，在主界面重绘
-(void)refrom{
    if ([_deleArray count]) {
        [_lineArray addObject:[_deleArray lastObject]];
        [_deleArray removeLastObject];
    }
    [self setNeedsDisplay];
    
}

-(void)clear{
    //移除所有信息并重绘
    [_deleArray removeAllObjects];
    [_lineArray removeAllObjects];
    [_pointArray removeAllObjects];
//    [self removeFromSuperview];
    [self setNeedsDisplay];
}

@end
