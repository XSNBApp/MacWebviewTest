//
//  SNBMainNavViewController.m
//  QQMSFContact
//
//  Created by brightshen on 14-9-25.
//
//

#import "SNBMainNavViewController.h"

#import "SNBMainNavCard.h"
#import "SNBMainNavCardHeaderCell.h"
#import "SNBMainNavType1Card.h"
#import "SNBMainNavType2Card.h"
#import "SNBMainNavType3Card.h"

#import "SNBMainNavHotItemButton.h"
#import "SNBMainNavHotItemModel.h"
#import "KDCycleBannerView.h"
#import "SNBMainNavBannerModel.h"

NSString *const SNBMainNavViewControllerDidClickTransferURLNotification = @"SNBMainNavViewControllerDidClickTransferURLNotification";


#define GroupSearchViewBannerH 70

NS_ENUM(NSUInteger, SNBMainNavViewSection){
    SNBMainNavViewSectionSearchField = 0,
    SNBMainNavViewSectionBannerAndHotItem,
    SNBMainNavViewSectionFirstCard
};

@interface SNBMainNavViewController () <UITableViewDelegate, UITableViewDataSource,KDCycleBannerViewDataource,KDCycleBannerViewDelegate>

//@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *cards;
@property(nonatomic, strong) NSArray *hotItems;
@property(nonatomic, strong) KDCycleBannerView *bannerView;
@property(nonatomic, strong) UIView *hotItemsView;

@property(nonatomic,strong) SNBMainNavBannerModel *bannerModel;
@property(nonatomic,strong) NSDictionary *bannerUrl2Action;
@property(nonatomic,strong) NSArray *bannerUrlArray;

@property(nonatomic,strong) QQGroupCardUIModel * uiModel;
@property(nonatomic,strong) QQGroupBannerAndHotIconModel *bannerAndHotIconModel;

@property(nonatomic, strong) QQAsynUrlImageView *hotItemsIconView;

@property(nonatomic, strong) ODRefreshControl *refreshControl;
@property(nonatomic) BOOL hasBeenAppear;

@property(nonatomic, strong) QQGroupCardUIModel* serverCardUIModel;

@end

@implementation SNBMainNavViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"群";
        self.hidesBottomBarWhenPushed = YES;
        self.hasBeenAppear = NO;

        self.bannerView = nil;
        //banner
        self.bannerAndHotIconModel = [[SNBMainNavUIDataMgr getInstance] getBannerAndHotIconModel];
        self.bannerModel = self.bannerAndHotIconModel.bannerModel;
        self.hotItems = self.bannerAndHotIconModel.hotItemArray;
        //card
        self.uiModel =  [[SNBMainNavUIDataMgr getInstance] getCardUIModel];
        self.cards  = self.uiModel.cardArray;
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferURLClickedNotify:) name:SNBMainNavViewControllerDidClickTransferURLNotification object:nil];
  
    }
    return self;
}

- (UINavigationController*)navigationController{
    if (self.parentViewController == nil) {
        return self.containerController.navigationController;
    }
    else return [super navigationController];
}

+ (NSString *)segmentTitle
{
    return @"群";
}

- (void)transferURLClickedNotify:(NSNotification *)notify{
    [self doActionURL:[notify userInfo][@"url"]];
}

-(void)updateUIData
{
    self.refreshControl.tag = 2;
    
    __weak SNBMainNavViewController *weakSelf = self;
    
    [[SNBMainNavUIDataMgr getInstance] updateUIConfig:^(BOOL bOK,QQGroupBannerAndHotIconModel* uiModel)
     {
         if (bOK)
         {
             weakSelf.bannerModel = uiModel.bannerModel;
             //
             weakSelf.hotItems = uiModel.hotItemArray;
             [weakSelf reloadHotItemsView];
             [weakSelf.tableView reloadData];
         }

         
         weakSelf.refreshControl.tag--;
         if (weakSelf.refreshControl.tag <= 0) {
             [weakSelf.refreshControl endRefreshing:YES];
         }
     } groupCardCallback:^(BOOL bOK,QQGroupCardUIModel* uiModel){
         
         if (bOK)
         {
             weakSelf.cards  = uiModel.cardArray;
            [weakSelf.tableView reloadData];
         }
        

         weakSelf.refreshControl.tag--;
         if (weakSelf.refreshControl.tag <= 0) {
             [weakSelf.refreshControl endRefreshing:YES];
         }
     }];
}

-(void)setBannerModel:(SNBMainNavBannerModel *)bannerModel
{
    _bannerModel = bannerModel;
    
    
    NSMutableDictionary *url2ActionDic = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:3];
    
    for (SNBMainNavBannerItem *item in _bannerModel.itemArray)
    {
        if (item.imageURL.length > 0 )
        {
            NSString *aUrl = item.actionURL.length > 0?item.actionURL:@"";
            url2ActionDic[item.imageURL] = aUrl;
            [urlArray addObject:item.imageURL];
        }
    }
    
    
    self.bannerUrl2Action = url2ActionDic;
    self.bannerUrlArray = urlArray;

}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [UITableView commonGroupStyledTableView:self dataSource:self frame:CGRectZero];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] > 6.99) self.tableView.separatorInset = UIEdgeInsetsMake(-1, 0, 0, 0);
        if ([[UIDevice currentDevice].systemVersion floatValue] > 7.99) self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (void)loadView{
    [super loadView];


    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView refreshTimeKey:@"SNBMainNavViewController"];
    [self.refreshControl addTarget:self action:@selector(updateUIData) forControlEvents:UIControlEventValueChanged];
}

#define HOT_ITEM_BUTTON_SPACE_H hotItemSpace
#define HOT_ITEM_BUTTON_SPACE_V 17

- (void)reloadHotItemsView{
    
    if ([self.hotItems count] == 0) {
        self.hotItemsView = [UIView new];
        return;
    }
    
    CGFloat width = ([[UIDevice currentDevice].systemVersion floatValue]>6.9)?[UIScreen mainScreen].bounds.size.width:300;
    
    CGFloat hotItemSpace = (width - 30 - HOT_ITEM_BUTTON_WIDTH*4)/3;
    NSUInteger numberOfRow = ([self.hotItems count]+3)/4;
    self.hotItemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 42+numberOfRow*HOT_ITEM_BUTTON_HEIGHT+(numberOfRow-1)*HOT_ITEM_BUTTON_SPACE_V+20)];
    self.hotItemsIconView = [[QQAsynUrlImageView alloc] initWithFrame:CGRectMake(15, 10, 17, 17) defaultImage:nil];
    [self.hotItemsIconView loadUrlImage:self.bannerAndHotIconModel.titleIconURL];
    [self.hotItemsView addSubview:self.hotItemsIconView];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 9, 200, 20)];
    nameLabel.skinTextColorNormal = kContentTitleTextColor;
    nameLabel.text = self.bannerAndHotIconModel.hotTitle.length > 0?self.bannerAndHotIconModel.hotTitle: @"热门分类";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.hotItemsView addSubview:nameLabel];

    for (int i = 0; i < [self.hotItems count]; i++) {
        SNBMainNavHotItemButton *button = [[SNBMainNavHotItemButton alloc] initWithFrame:CGRectMake(15+i%4*(HOT_ITEM_BUTTON_SPACE_H+HOT_ITEM_BUTTON_WIDTH), 42+i/4*(HOT_ITEM_BUTTON_SPACE_V+HOT_ITEM_BUTTON_HEIGHT), HOT_ITEM_BUTTON_WIDTH, HOT_ITEM_BUTTON_HEIGHT)];
        button.model = self.hotItems[i];
        [button addTarget:self action:@selector(hotItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.hotItemsView addSubview:button];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)hotItemButtonClicked:(SNBMainNavHotItemButton*)button{

    NSString*  newURL = [self addURLLBS:button.model.transferURL];
    [self doActionURL:newURL];
    
    [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_Clk_hotcal opEnter:0 opResult:0 reserve:@"",button.model.name,nil];
}


- (NSString*)addURLLBS:(NSString*)urlStr
{
    QQURLBuilder *builder = [[QQURLBuilder alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    [builder addQueryParameter:@"lon" withValue:[NSString stringWithFormat:@"%lu",[SNBMainNavUIDataMgr getInstance].lon]];
    [builder addQueryParameter:@"lat" withValue:[NSString stringWithFormat:@"%lu",[SNBMainNavUIDataMgr getInstance].lat]];
    [builder addQueryParameter:@"city" withValue:[SNBMainNavUIDataMgr getInstance].cityName];
    
    return [[builder getURL] absoluteString];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadHotItemsView];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, 30)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.hasBeenAppear)
    {
        [self updateUIData];
        
        self.hasBeenAppear = YES;
        
        [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_exp opEnter:0 opResult:0 reserve:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.cards count] + SNBMainNavViewSectionFirstCard;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SNBMainNavViewSectionSearchField) {
        return 1;
    }
    else if (section == SNBMainNavViewSectionBannerAndHotItem ) {
        return 1;
    }
    else if (section >= SNBMainNavViewSectionFirstCard) {
        SNBMainNavCard *groupSearchCard = self.cards[section-SNBMainNavViewSectionFirstCard];
        NSInteger numberOfRows = [groupSearchCard numberOfRows]+1;
        if ([groupSearchCard.transferDescription length] > 0 || [groupSearchCard.transferURL length]> 0) { //是否显示更多
            numberOfRows++;
        }
        return numberOfRows;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    if (indexPath.section == 1) {
        
        int bannerH = self.bannerUrlArray.count > 0?GroupSearchViewBannerH:0;
        return bannerH + self.hotItemsView.frame.size.height;
    }
    else if (indexPath.section >= SNBMainNavViewSectionFirstCard) {
        SNBMainNavCard *groupSearchCard = self.cards[indexPath.section-SNBMainNavViewSectionFirstCard];
        if (indexPath.row == 0) { //card头
            return 32;
        }
        else if (indexPath.row <= groupSearchCard.numberOfRows) {
            return groupSearchCard.rowHeight;
        }
        else return 32; //card尾部
    }
    else return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AddFriendTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendTextFieldCell"];
        if (cell == nil) {
            cell = [[AddFriendTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddFriendTextFieldCell"];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KDCycleBannerView"];
    
        int bannerH = 0;
        
        if (self.bannerUrlArray.count > 0)
        {
            
            CGRect rect =  CGRectMake(0, 0, self.view.bounds.size.width, GroupSearchViewBannerH);
            
            if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
                rect = CGRectMake(10, 0, self.view.bounds.size.width-20, GroupSearchViewBannerH);
            }
            
            KDCycleBannerView *bv = [[KDCycleBannerView alloc ] initWithFrame:rect];
            self.bannerView = bv;
            self.bannerView.datasource = self;
            self.bannerView.delegate = self;
            self.bannerView.autoPlayTimeInterval = self.bannerModel.interval;
            [cell addSubview:self.bannerView];
            
            bannerH = bv.frame.size.height;
        }


        self.hotItemsView.frame = CGRectMake(0, bannerH , self.hotItemsView.frame.size.width, self.hotItemsView.frame.size.height);

        [cell addSubview:self.hotItemsView];
        
        return cell;
    }
    else if (indexPath.section >= SNBMainNavViewSectionFirstCard) {
        SNBMainNavCard *groupSearchCard = self.cards[indexPath.section-SNBMainNavViewSectionFirstCard];
        if (indexPath.row == 0) {
            SNBMainNavCardHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionHeaderCell"];
            if (cell == nil) {
                cell = [[SNBMainNavCardHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SectionHeaderCell"];
            }
            [cell updateContentWithCard:groupSearchCard];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row <= groupSearchCard.numberOfRows) {
            return [groupSearchCard tableView:tableView cellForRow:indexPath.row-1];
        }
        else {
            UITableViewCell *cell = [UITableViewCell new];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = groupSearchCard.transferDescription;
            cell.textLabel.frame = CGRectMake(0, 0, cell.bounds.size.width,  cell.textLabel.frame.size.height);
            
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= SNBMainNavViewSectionFirstCard) {
        SNBMainNavCard *groupSearchCard = self.cards[indexPath.section-SNBMainNavViewSectionFirstCard];
        if (indexPath.row == 0)
        {

        }
        else if (indexPath.row <= groupSearchCard.numberOfRows)
        {
            
        }
        else
        {
            [self doActionURL:groupSearchCard.transferURL];
            
            [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_Clk_more opEnter:0 opResult:0 reserve:@"",groupSearchCard.name,nil];
        }
    }

}


#pragma mark - KDCycleBannerViewDataource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return self.bannerUrlArray;
    
    return @[ [UIImage imageNamed:@"Icon-80.png"],
             @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=ed59838948ed2e73fce9812cb339a08b/58ee3d6d55fbb2fb9835341f4d4a20a44623dca5.jpg",
             @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=5ad7fab780025aafd33279cbcfd5aa64/8601a18b87d6277f15eb8e4f2a381f30e824fcc8.jpg",
             @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=df5d0b61cdfc1e17fdbf8b317ea8f703/0bd162d9f2d3572c8d2b20ab8813632763d0c3f8.jpg",
             @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=a11d7b94552c11dfded1b823571f63d0/eaf81a4c510fd9f914eee91e272dd42a2934a4c8.jpg"];
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleToFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView
{
    return nil;
    //return [UIImage imageNamed:@"Icon-80.png"];
}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index {
    NSLog(@"didScrollToIndex:%ld", (long)index);
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    if (index >=  self.bannerUrlArray.count) {
        
        return;
    }
    
    NSString* imageURL = self.bannerUrlArray[index];
    NSString* aURL = self.bannerUrl2Action[imageURL];
    [self doActionURL:aURL];

    NSLog(@"didSelectedAtIndex:%ld", (long)index);
    
    
    //群搜索数据上报
//#define Group_Dept_Grp_Find_OPName_exp @"exp"
//#define Group_Dept_Grp_Find_OPName_Clk_banner @"Clk_banner"
//#define Group_Dept_Grp_Find_OPName_Clk_hotcal @"Clk_hotcal"
//#define Group_Dept_Grp_Find_OPName_Clk_grpdata @"Clk_grpdata"
//#define Group_Dept_Grp_Find_OPName_Clk_grpjoin @"Clk_grpjoin"
//    
//    
//#define Group_Dept_Grp_Find_OPName_Clk_join @"Clk_join" //加群点击
//#define Group_Dept_Grp_Find_OPName_Clk_more @"Clk_more" //统计群tab页面，“更多”按钮点击次数、人数
//#define Group_Dept_Grp_Find_OPName_Clk_localac @"Clk_localac" //同城活动点击
//#define Group_Dept_Grp_Find_OPName_Clk_tribe @"Clk_tribe" //兴趣部落点击
    NSString *idxStr = [NSString stringWithFormat:@"%d",index + 1];
    [[UniLogUploadEngine GetInstance] DataReportOpKey644:Group_Dept_Grp_find opType:Group_Dept_Grp_Find_OPType_grptab opName:Group_Dept_Grp_Find_OPName_Clk_banner opEnter:0 opResult:0 reserve:@"",idxStr,nil];
}

- (BOOL)doActionURL:(NSString* )urlStr
{
    if (urlStr.length <= 0)
    {
        return NO;
    }
    
    if ([urlStr.lowercaseString hasPrefix:@"http"]  || [urlStr.lowercaseString hasPrefix:@"https"])
    {
        QQWebViewController *vc = [[QQWebViewController alloc] initWith:urlStr forStyle:QQWebViewStyle_TopBarNoShare];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }

        
    
  
    return NO;
}

- (BOOL)isSupportRightDragToGoBack
{
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
