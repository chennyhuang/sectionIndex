//
//  HZCityViewController.m
//  sectionindex
//
//  Created by huangzhenyu on 15/8/7.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZCityViewController.h"
#import "BATableView.h"
#import "ChineseToPinyin.h"

@interface HZCityViewController ()<BATableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) BATableView *contactTableView;
@property (nonatomic, strong) UITableView *searchCityTableview;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary * citys;
@property (nonatomic, strong) NSMutableArray *titleHeaderArray;
@property (nonatomic, strong) NSMutableArray *indexArray;//右侧index
@property (nonatomic, strong) NSMutableArray *arrayHotCity;//热门城市

@property (nonatomic, strong) NSMutableArray *cityesArray;
@property (nonatomic, strong) NSMutableArray *cityesArrayCopy;
@end

@implementation HZCityViewController

- (NSMutableArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)arrayHotCity{
    if (!_arrayHotCity) {
        _arrayHotCity = [NSMutableArray array];
    }
    return _arrayHotCity;
}

- (NSMutableDictionary *)citys{
    if (!_citys) {
        _citys = [NSMutableDictionary dictionary];
    }
    return _citys;
}
- (NSMutableArray *)cityesArray{
    if (!_cityesArray) {
        _cityesArray = [NSMutableArray array];
    }
    return _cityesArray;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
        _searchBar.placeholder = @"搜索城市";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (BATableView *)contactTableView{
    if (!_contactTableView) {
        _contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)];
        _contactTableView.delegate = self;
        _contactTableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _contactTableView;
}

- (UITableView *)searchCityTableview{
    if (!_searchCityTableview) {
        _searchCityTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)];
        _searchCityTableview.tag = 100;
        _searchCityTableview.delegate = self;
        _searchCityTableview.dataSource = self;
        _searchCityTableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _searchCityTableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    //添加searchBar
    [self.view addSubview:self.searchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcityName:) name:@"getCityNameNotification" object:nil];
    self.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [self getCityData];
    
    [self.view addSubview:self.contactTableView];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCityNameNotification" object:nil];
}

- (void)cancelClick{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getcityName:(NSNotification *)note{
    NSString *cityStr = [[note object] objectForKey:@"cityName"];
    [self.citys setObject:@[cityStr] forKey:@"定"];
    [self.contactTableView.tableView reloadData];
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    self.citys = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [self.indexArray addObjectsFromArray:[[self.citys allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.titleHeaderArray = [NSMutableArray arrayWithArray:self.indexArray];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:[self.citys allValues]];
    for (NSArray *array in tempArray) {
        for (NSString *cityStr in array) {
            [self.cityesArray addObject:cityStr];//所有城市的集合
        }
    }
    self.cityesArrayCopy = [NSMutableArray arrayWithArray:self.cityesArray];
    
    //添加热门城市
    [self.indexArray insertObject:@"热" atIndex:0];
    [self.citys setObject:self.arrayHotCity forKey:@"热"];
    [self.titleHeaderArray insertObject:@"热门城市" atIndex:0];
    //添加定位城市
    [self.indexArray insertObject:@"定" atIndex:0];
    [self.citys setObject:@[self.cityName] forKey:@"定"];
    [self.titleHeaderArray insertObject:@"CPS定位" atIndex:0];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.contactTableView hideFlotage];
}

#pragma mark searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidBeginEditing");
    self.title = @"搜索城市";
    [self searchBar:searchBar textDidChange:searchBar.text];
    self.contactTableView.hidden = YES;
    [self.view addSubview:self.searchCityTableview];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.title = @"选择城市";
    if ([searchBar.text isEqualToString:@""]) {
        self.contactTableView.hidden = NO;
        [self.searchCityTableview removeFromSuperview];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([searchText isEqualToString:@""]) {
        tempArray = nil;
    } else {
        NSString *tempsearchText = [searchText uppercaseString];//大写
        
        [self.cityesArrayCopy enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL *stop) {
            NSString *name = cityName;//全名
            NSString *fullSpell = [ChineseToPinyin pinyinFromChineseString:name];//全拼
            NSString *shortSpell = [ChineseToPinyin spFromChineseString:name];//简拼
            
            if ([name rangeOfString:tempsearchText].length != 0 ||
                [fullSpell rangeOfString:tempsearchText].length != 0 ||
                [shortSpell rangeOfString:tempsearchText].length != 0
                ) {
                [tempArray addObject:cityName];
            }
        }];
    }
    self.cityesArray = tempArray;
    [self.searchCityTableview reloadData];
}

#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    if (tableView.tableView.tag != 100) {
        return self.indexArray;
    } else
        return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag != 100) {
        return self.titleHeaderArray[section];
    } else {
        return nil;
    }
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag != 100) {
        return self.indexArray.count;
    } else
        return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag != 100) {
        NSString *key = [self.indexArray objectAtIndex:section];
        NSArray *citySection = [self.citys objectForKey:key];
        return [citySection count];
    } else
        return self.cityesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellName = @"UITableViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if (tableView.tag != 100) {
        NSString *key = [self.indexArray objectAtIndex:indexPath.section];
        cell.textLabel.text = [[self.citys objectForKey:key] objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = self.cityesArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cityName;
    if (tableView.tag != 100) {
        NSString *key = [self.indexArray objectAtIndex:indexPath.section];
        cityName = [[self.citys objectForKey:key] objectAtIndex:indexPath.row];
    } else {
        cityName = self.cityesArray[indexPath.row];
    }
    if (self.dismissWithCityBlock) {
        self.dismissWithCityBlock(cityName);
    }
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
