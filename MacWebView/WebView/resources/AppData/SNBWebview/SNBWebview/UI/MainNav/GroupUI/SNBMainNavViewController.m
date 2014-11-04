//
//  SNBMainNavViewController.m
//  QQMSFContact
//
//  Created by xxing on 14-9-25.
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
//#import "SNBMainNavBannerModel.h"
#import "SNBAsynUrlImageView.h"
#import "TOWebViewController.h"

NSString *const SNBMainNavViewControllerDidClickTransferURLNotification = @"SNBMainNavViewControllerDidClickTransferURLNotification";


#define GroupSearchViewBannerH 70

NS_ENUM(NSUInteger, SNBMainNavViewSection){
    SNBMainNavViewSectionSearchField = 0,
    SNBMainNavViewSectionBannerAndHotItem,
    SNBMainNavViewSectionFirstCard
};

@interface SNBMainNavViewController () <UITableViewDelegate, UITableViewDataSource,KDCycleBannerViewDataource,KDCycleBannerViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) KDCycleBannerView *bannerView;
@property(nonatomic, strong) UIView *hotItemsView;

@property(nonatomic,strong) SNBAsynUrlImageView *hotItemsIconView;

@property(nonatomic,strong) NSDictionary *bannerUrl2Action;
@property(nonatomic,strong) NSArray *bannerUrlArray;


@property(nonatomic) BOOL hasBeenAppear;


@end

@implementation SNBMainNavViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"小游戏";
        self.hidesBottomBarWhenPushed = YES;
        self.hasBeenAppear = NO;

        self.bannerView = nil;
        self.uiModel =  nil;
        
        [self updateUIData];

    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferURLClickedNotify:) name:SNBMainNavViewControllerDidClickTransferURLNotification object:nil];
  
    }
    return self;
}



- (void)transferURLClickedNotify:(NSNotification *)notify{
    [self doActionURL:[notify userInfo][@"url"]];
}

-(void)updateUIData
{
    self.uiModel = [[SNBMainNavUIModel alloc] init];
    
    self.uiModel.bannerUrlArray = @[@"http://d.hiphotos.baidu.com/image/w%3D2048/sign=ed59838948ed2e73fce9812cb339a08b/58ee3d6d55fbb2fb9835341f4d4a20a44623dca5.jpg",
                                    @"http://d.hiphotos.baidu.com/image/w%3D2048/sign=ed59838948ed2e73fce9812cb339a08b/58ee3d6d55fbb2fb9835341f4d4a20a44623dca5.jpg"];
    
    //hotItmes
    
    SNBMainNavHotItemModel* hotModel1 = [[SNBMainNavHotItemModel alloc] init];
    hotModel1.name = @"益智游戏";
    hotModel1.transferURL = @"http://m.edianyou.com/game/list.html?categoryid=1";
    hotModel1.imageURL = @"http://m.edianyou.com/images/ty_1.png";
    
    SNBMainNavHotItemModel* hotModel2 = [[SNBMainNavHotItemModel alloc] init];
    hotModel2.name = @"休闲游戏";
    hotModel2.transferURL = @"http://m.edianyou.com/game/list.html?categoryid=3";
    hotModel2.imageURL = @"http://m.edianyou.com/images/ty_3.png";
    
    SNBMainNavHotItemModel* hotModel3 = [[SNBMainNavHotItemModel alloc] init];
    hotModel3.name = @"射击游戏";
    hotModel3.transferURL = @"http://m.edianyou.com/game/list.html?categoryid=4";
    hotModel3.imageURL = @"http://m.edianyou.com/images/ty_4.png";
    


    self.uiModel.hotItemTitle  = @"热门游戏";
    self.uiModel.hotItems = @[hotModel1,hotModel2,hotModel3,hotModel1,hotModel2,hotModel3,hotModel1,hotModel2,hotModel3,hotModel1,hotModel2,hotModel3];
    
    //card
    
    SNBMainNavType1Card *card1 = [[SNBMainNavType1Card alloc] init];
    card1.name = @"热门游戏";
    card1.iconURL = @"http://m.edianyou.com/images/logo.gif";
    
    card1.transferDescription = @"更多";
    card1.transferURL = @"http://m.edianyou.com/";
    
    
    SNBMainNavType1Model *card1_model =  [[SNBMainNavType1Model alloc] init];
    card1_model.name = @"是男人就上一百层";
    card1_model.transferURL = @"http://m.edianyou.com/game/detail.html?gameid=199";
    card1_model.imageURL = @"http://www.edianyou.com/h5img/icon/nanren.png";

    
    card1.type1Models = @[card1_model,card1_model,card1_model];
    
    self.uiModel.cards = @[card1];
  
    
    
}



- (UITableView *)tableView{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] > 6.99) self.tableView.separatorInset = UIEdgeInsetsMake(-1, 0, 0, 0);
        if ([[UIDevice currentDevice].systemVersion floatValue] > 7.99) self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}

- (void)loadView
{
    [super loadView];


    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
 
}

#define HOT_ITEM_BUTTON_SPACE_H hotItemSpace
#define HOT_ITEM_BUTTON_SPACE_V 17

- (void)reloadHotItemsView{
    
    if ([self.uiModel.hotItems count] == 0) {
        self.hotItemsView = [UIView new];
        return;
    }
    
    CGFloat width = ([[UIDevice currentDevice].systemVersion floatValue]>6.9)?[UIScreen mainScreen].bounds.size.width:300;
    
    CGFloat hotItemSpace = (width - 30 - HOT_ITEM_BUTTON_WIDTH*4)/3;
    NSUInteger numberOfRow = ([self.uiModel.hotItems count]+3)/4;
    self.hotItemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 42+numberOfRow*HOT_ITEM_BUTTON_HEIGHT+(numberOfRow-1)*HOT_ITEM_BUTTON_SPACE_V+20)];
    self.hotItemsIconView = [[SNBAsynUrlImageView alloc] initWithFrame:CGRectMake(15, 10, 17, 17)];
    [self.hotItemsIconView sd_setImageWithURL:[NSURL URLWithString: self.uiModel.hotItemTitleIconURL] ];
    [self.hotItemsView addSubview:self.hotItemsIconView];

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 9, 200, 20)];

    nameLabel.text = self.uiModel.hotItemTitle.length > 0?self.uiModel.hotItemTitle: @"热门分类";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.hotItemsView addSubview:nameLabel];

    for (int i = 0; i < [self.uiModel.hotItems count]; i++) {
        SNBMainNavHotItemButton *button = [[SNBMainNavHotItemButton alloc] initWithFrame:CGRectMake(15+i%4*(HOT_ITEM_BUTTON_SPACE_H+HOT_ITEM_BUTTON_WIDTH), 42+i/4*(HOT_ITEM_BUTTON_SPACE_V+HOT_ITEM_BUTTON_HEIGHT), HOT_ITEM_BUTTON_WIDTH, HOT_ITEM_BUTTON_HEIGHT)];
        button.model = self.uiModel.hotItems[i];
        [button addTarget:self action:@selector(hotItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.hotItemsView addSubview:button];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)hotItemButtonClicked:(SNBMainNavHotItemButton*)button{

    NSString*  newURL = [self addURLLBS:button.model.transferURL];
    [self doActionURL:newURL];

}


- (NSString*)addURLLBS:(NSString*)urlStr
{
    return urlStr;
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
        

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.uiModel.cards count] + SNBMainNavViewSectionFirstCard;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SNBMainNavViewSectionSearchField) {
        return 1;
    }
    else if (section == SNBMainNavViewSectionBannerAndHotItem ) {
        return 1;
    }
    else if (section >= SNBMainNavViewSectionFirstCard) {
        SNBMainNavCard *groupSearchCard = self.uiModel.cards[section-SNBMainNavViewSectionFirstCard];
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
        SNBMainNavCard *groupSearchCard = self.uiModel.cards[indexPath.section-SNBMainNavViewSectionFirstCard];
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
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
        
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
            self.bannerView.autoPlayTimeInterval = self.uiModel.bannerInterval;
            [cell addSubview:self.bannerView];
            
            bannerH = bv.frame.size.height;
        }


        self.hotItemsView.frame = CGRectMake(0, bannerH , self.hotItemsView.frame.size.width, self.hotItemsView.frame.size.height);

        [cell addSubview:self.hotItemsView];
        
        return cell;
    }
    else if (indexPath.section >= SNBMainNavViewSectionFirstCard) {
        SNBMainNavCard *groupSearchCard = self.uiModel.cards[indexPath.section-SNBMainNavViewSectionFirstCard];
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
        SNBMainNavCard *groupSearchCard = self.uiModel.cards[indexPath.section-SNBMainNavViewSectionFirstCard];
        if (indexPath.row == 0)
        {

        }
        else if (indexPath.row <= groupSearchCard.numberOfRows)
        {
            
        }
        else
        {
            [self doActionURL:groupSearchCard.transferURL];
            
        }
    }

}


#pragma mark - KDCycleBannerViewDataource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return self.bannerUrlArray;
    
    return @[
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
    

}

- (BOOL)doActionURL:(NSString* )urlStr
{
    if (urlStr.length <= 0)
    {
        return NO;
    }
    
    if ([urlStr.lowercaseString hasPrefix:@"http"]  || [urlStr.lowercaseString hasPrefix:@"https"])
    {
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
        //[self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
        
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }

        
    
  
    return NO;
}





@end
