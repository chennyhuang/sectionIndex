//
//  ABELTableView.m
//  ABELTableViewDemo
//
//  Created by abel on 14-4-28.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import "BATableView.h"
#import "BATableViewIndex.h"

@interface BATableView()<BATableViewIndexDelegate>

@property (nonatomic, strong) UILabel * flotageLabel;
@property (nonatomic, strong) BATableViewIndex * tableViewIndex;

@end

@implementation BATableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:self.tableView];
        
        self.tableViewIndex = [[BATableViewIndex alloc] initWithFrame:(CGRect){self.tableView.frame.size.width - 24,0,24,frame.size.height}];
        [self addSubview:self.tableViewIndex];
        
        self.flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.bounds.size.width - 90 ) / 2,(self.bounds.size.height - 90) / 2,90,90}];
        self.flotageLabel.backgroundColor = RGB(18, 29, 45, 0.6);
        self.flotageLabel.hidden = YES;
        self.flotageLabel.font = [UIFont systemFontOfSize:40.0];
        self.flotageLabel.textAlignment = NSTextAlignmentCenter;
        self.flotageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.flotageLabel];
    }
    return self;
}

- (void)setDelegate:(id<BATableViewDelegate>)delegate {
    _delegate = delegate;
    self.tableView.delegate = delegate;
    self.tableView.dataSource = delegate;
    self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    [self.tableViewIndex reloadLayout:self.tableView.contentInset];
    self.tableViewIndex.tableViewIndexDelegate = self;
}

- (void)reloadData {
    [self.tableView reloadData];
    self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    [self.tableViewIndex reloadLayout:self.tableView.contentInset];
    self.tableViewIndex.tableViewIndexDelegate = self;
}

- (void)hideFlotage {
    self.flotageLabel.hidden = YES;
}

#pragma mark - BATableViewIndex delegate
- (void)tableViewIndex:(BATableViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title {
    if (index > -1){   // for safety, should always be YES
        NSArray *indexStrArray = [self.delegate sectionIndexTitlesForABELTableView:self];
        for (NSInteger i = 0; i < [self.delegate numberOfSectionsInTableView:self.tableView]; i++) {
            NSString *indexStr = indexStrArray[i];
//            if ([[self.delegate titleString:i] isEqualToString:title]) {
            if ([indexStr isEqualToString:title]) {
                
          
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:NO];
//                break;
//            }
                break;
                  }
        }
        self.flotageLabel.text = title;
    }
}

- (void)tableViewIndexTouchesBegan:(BATableViewIndex *)tableViewIndex {
    self.flotageLabel.hidden = NO;
}

- (void)tableViewIndexTouchesEnd:(BATableViewIndex *)tableViewIndex {
    self.flotageLabel.hidden = YES;
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [self.flotageLabel.layer addAnimation:animation forKey:nil];
}

- (NSArray *)tableViewIndexTitle:(BATableViewIndex *)tableViewIndex {
    return [self.delegate sectionIndexTitlesForABELTableView:self];
 
}


@end
