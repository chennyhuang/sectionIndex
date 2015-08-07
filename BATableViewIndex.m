//
//  ABELTableViewIndex.m
//  ABELTableViewDemo
//
//  Created by abel on 14-4-28.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import "BATableViewIndex.h"

#if !__has_feature(objc_arc)
#error BATableViewIndex must be built with ARC.
// You can turn on ARC for only AIMTableViewIndexBar files by adding -fobjc-arc to the build phase for each of its files.
#endif

@interface BATableViewIndex (){
    CGFloat fontSize;
}

@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, assign) CGFloat letterHeight;
@end

@implementation BATableViewIndex

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        if (frame.size.height > 480) {
            self.letterHeight = 15;
            fontSize = 13;
        } else {
            self.letterHeight = 12;
            fontSize = 11;
        }
    }
    return self;
}

- (NSArray *)letters
{
    if (!_letters) {
        _letters = [self.tableViewIndexDelegate tableViewIndexTitle:self];
    }
    return _letters;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.letters enumerateObjectsUsingBlock:^(NSString *letter, NSUInteger idx, BOOL *stop) {
        CGFloat originY = idx * self.letterHeight;
        CATextLayer *ctl = [self textLayerWithSize:fontSize
                                            string:letter
                                          andFrame:CGRectMake(0, originY, self.frame.size.width, self.letterHeight)];
        [self.layer addSublayer:ctl];
    }];
}

- (void)reloadLayout:(UIEdgeInsets)edgeInsets
{
    CGRect rect = self.frame;
    rect.size.height = self.indexes.count * self.letterHeight;
    rect.origin.y = edgeInsets.top + ([self superview].bounds.size.height - edgeInsets.top - edgeInsets.bottom - rect.size.height) / 2;
    self.frame = rect;
}

- (CATextLayer*)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *textLayer = [CATextLayer layer];
    [textLayer setFont:@"ArialMT"];
    [textLayer setFontSize:size];
    [textLayer setFrame:frame];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [textLayer setForegroundColor:RGB(168, 168, 168, 1).CGColor];
    [textLayer setString:string];
    return textLayer;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
    [self.tableViewIndexDelegate tableViewIndexTouchesBegan:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved");
    [super touchesMoved:touches withEvent:event];
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    [super touchesEnded:touches withEvent:event];
    [self.tableViewIndexDelegate tableViewIndexTouchesEnd:self];
}

- (void)sendEventToDelegate:(UIEvent*)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger indx = ((NSInteger) floorf(point.y) / self.letterHeight);
    
    if (indx< 0 || indx > self.letters.count - 1) {
        return;
    }
    
    [self.tableViewIndexDelegate tableViewIndex:self didSelectSectionAtIndex:indx withTitle:self.letters[indx]];
}


@end
