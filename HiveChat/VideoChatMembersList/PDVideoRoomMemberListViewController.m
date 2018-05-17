//
//  PDVideoRoomMemberListViewController.m
//  PlayDay
//
//  Created by Pavel Sokolov on 23/03/17.
//  Copyright © 2017 PlayDay. All rights reserved.
//

#import "PDVideoRoomMemberListViewController.h"

#import "MTKObserving.h"

#import "PDNewAPIEntityListLoader.h"
#import "PDNewAPIEntityListLoaderUICoordinator.h"
#import "PDGenericCollectionViewSectionManagerAggregate.h"
#import "PDFlowCollectionViewWithBlocksAdapter.h"
#import "PDGenericCollectionViewSectionAggregateDataSource.h"
#import "PDNewAPIGenericCollectionViewDataManager.h"
#import "PDCollectionViewSelectionBlocksAdapter.h"
#import "PDNewAPICollectionViewInstantReloadAnimator.h"
#import "PDGenericCollectionViewControllerConfigurator.h"

#import "PDCollectionViewSeparatorFlowLayout.h"

#import "PDVideoRoomMembersListTranslationSectionManager.h"
#import "PDVideoRoomMemberListPeopleSectionManager.h"
#import "PDVideoRoomMemberListPlaceholderSectionManager.h"
#import "PDGenericLoaderSectionManager.h"
#import "PDVideoRoomMemberListChannelsSectionManager.h"
#import "PDVideoRoomMemberListChannelsLoaderSectionManager.h"

#import "PDVideoRoomBackgroundView.h"
#import "PDVideoRoomMembersListHeaderView.h"
#import "PDVideoRoomMembersListBottomPanelView.h"

#import "PDVideoRoomViewModel.h"
#import "PDVideoRoomMemberListViewModel.h"

#import "UIView+NibLoading.h"

static const NSUInteger kDefaultBatchSize = 50;
static const NSUInteger kPDCollectionContentInsets = 8;

typedef NS_ENUM(NSUInteger, PDVideoRoomMemberListSection){
    /**
     *  Translations section
     */
    PDVideoRoomMemberListSectionTranslations,
    /**
     *  Translations section
     */
    PDVideoRoomMemberListSectionChannels,
    /**
     *  Translations section
     */
    PDVideoRoomMemberListSectionChannelsLoader,
    /**
     *  People section
     */
    PDVideoRoomMemberListPeopleSection,
    /**
     *  Placeholder section
     */
    PDVideoRoomMemberListPeoplePlaceholder,
    /**
     *  Loader section
     */
    PDVideoRoomMemberListLoaderSection,
    /**
     *  Number of sections in Collection View
     */
    PDVideoRoomMemberListSectionCount,
};

@interface PDVideoRoomMemberListViewController ()

/**
 *  CollectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  CollectionView
 */
@property (nonatomic, strong) PDVideoRoomBackgroundView *backgroundView;
/**
 Header view
 */
@property (nonatomic, strong) PDVideoRoomMembersListHeaderView *headerView;
/**
 Footer view
 */
@property (nonatomic, strong) PDVideoRoomMembersListBottomPanelView *footerView;

/**
 View model
 */
@property (nonatomic, strong) PDVideoRoomMemberListViewModel *viewModel;
/**
 *  Loader UI coordinator
 */
@property (nonatomic, strong) PDNewAPIEntityListLoaderUICoordinator *loaderUICoordinator;
/**
 *  Channels loader UI coordinator
 */
@property (nonatomic, strong) PDNewAPIEntityListLoaderUICoordinator *channelsLoaderUICoordinator;
/**
 *  Section managers aggregate
 */
@property (nonatomic, strong) PDGenericCollectionViewSectionManagerAggregate *sectionManagerAggregate;
/**
 *  CollectionView adapter
 */
@property (nonatomic, strong) PDFlowCollectionViewWithBlocksAdapter *collectionViewAdapter;
/**
 *  Data source
 */
@property (nonatomic, strong) PDGenericCollectionViewSectionAggregateDataSource *collectionViewDataSource;
/**
 *  Tracking change data source
 */
@property (nonatomic, strong) PDNewAPIGenericCollectionViewDataManager *collectionViewDataManager;
/**
 *  Load data from WS
 */
@property (nonatomic, strong) PDNewAPIEntityListLoader *loadManager;
/**
 *  Adapter for cell selection
 */
@property (nonatomic, strong) PDCollectionViewSelectionBlocksAdapter *selectionAdapter;

@end

@implementation PDVideoRoomMemberListViewController

#pragma mark - initialization

- (void)dealloc {
    [self stopObservers];
}

- (instancetype)initWithViewModel:(PDVideoRoomViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];

    if (self == nil) {
        return self;
    }
    
    self.viewModel = [[PDVideoRoomMemberListViewModel alloc] init];
    self.viewModel.videoRoomViewModel = viewModel;
    
    [self startObservers];
    
    self.loadManager = [[PDNewAPIEntityListLoader alloc] init];
    self.loadManager.batchItemCount = kDefaultBatchSize;
    
    return self;
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundView = [[PDVideoRoomBackgroundView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.backgroundViewStyle = PDVideoRoomBackgroundViewStyleDarkTransparent;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backgroundView];
    
    [self setupHeaderView];
    [self setupFooterView];
    
    [self setupCollectionView];
    [self setupControllerConfigurator];
    [self setupLoaderUICoordinator];
}

#pragma mark - Setup

- (UIView *) bottomPanelView {
    [self view];
    return (UIView *)self.footerView;
}

- (void)setupHeaderView {
    CGRect headerFrame = CGRectMake(0, 0, self.view.bounds.size.width, [PDVideoRoomMembersListHeaderView defaultHeight]);
    self.headerView = [PDVideoRoomMembersListHeaderView viewFromDefaultNib];
    self.headerView.frame = headerFrame;
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.headerView configureWithViewModel:self.viewModel.videoRoomViewModel];
    
    [self.backgroundView.contentContainerView addSubview:self.headerView];
}

- (void)setupFooterView {
    __weak typeof(self) wSelf = self;
    
    CGFloat height = [PDVideoRoomMembersListBottomPanelView defaultHeight];
    CGRect footerFrame = CGRectMake(0, self.backgroundView.bounds.size.height-height, self.backgroundView.bounds.size.width, height);
    self.footerView = [PDVideoRoomMembersListBottomPanelView viewFromDefaultNib];
    self.footerView.frame = footerFrame;
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    self.footerView.onTapActionHandler = ^() {
        wSelf.viewModel.videoRoomViewModel.hideMemberListControllerSignal = [[NSObject alloc] init];
    };
    
    [self.backgroundView.contentContainerView addSubview:self.footerView];
}

- (void)setupCollectionView {
    PDCollectionViewSeparatorFlowLayout *layout = [[PDCollectionViewSeparatorFlowLayout alloc] init];
    CGRect frame = self.view.bounds;
    frame.origin.y = self.headerView.bounds.size.height;
    frame.size.height -= self.headerView.bounds.size.height + self.footerView.frame.size.height;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(kPDCollectionContentInsets, 0, kPDCollectionContentInsets, 0);
    [self.backgroundView.contentContainerView addSubview:self.collectionView];
}

- (void)setupControllerConfigurator {
    self.collectionViewDataManager = [[PDNewAPIGenericCollectionViewDataManager alloc] init];
    self.collectionViewDataSource = [[PDGenericCollectionViewSectionAggregateDataSource alloc] init];
    self.collectionViewAdapter = [[PDFlowCollectionViewWithBlocksAdapter alloc] init];
    self.selectionAdapter = [[PDCollectionViewSelectionBlocksAdapter alloc] initWithCollectionView:self.collectionView];
    
    PDVideoRoomMemberListChannelsSectionManager *channelsSection = nil;
    channelsSection = [[PDVideoRoomMemberListChannelsSectionManager alloc] initWithViewModel:self.viewModel];
    channelsSection.sectionIndex = PDVideoRoomMemberListSectionChannels;

    PDVideoRoomMemberListChannelsLoaderSectionManager *channelsLoaderSection = nil;
    channelsLoaderSection = [[PDVideoRoomMemberListChannelsLoaderSectionManager alloc] initWithViewModel:self.viewModel];
    channelsLoaderSection.sectionIndex = PDVideoRoomMemberListSectionChannelsLoader;

    PDVideoRoomMemberListPeopleSectionManager *peopleSection = [[PDVideoRoomMemberListPeopleSectionManager alloc] initWithViewModel:self.viewModel.videoRoomViewModel];
    peopleSection.sectionIndex = PDVideoRoomMemberListPeopleSection;
    
    PDVideoRoomMemberListPlaceholderSectionManager *placeholderSection =
    [[PDVideoRoomMemberListPlaceholderSectionManager alloc] initWithViewModel:self.viewModel.videoRoomViewModel
                                                           peopleSectionIndex:PDVideoRoomMemberListPeopleSection
                                                                 entityLoader:self.loadManager];
    placeholderSection.sectionIndex = PDVideoRoomMemberListPeoplePlaceholder;
    
    PDGenericLoaderSectionManager *loaderSection = [[PDGenericLoaderSectionManager alloc] initWithLoadManager:self.loadManager];
    loaderSection.sectionIndex = PDVideoRoomMemberListLoaderSection;
    loaderSection.loaderStyle = PDActivityIndicatorStyleWhite;
    
    PDVideoRoomMembersListTranslationSectionManager *translationsSection = nil;
    translationsSection = [[PDVideoRoomMembersListTranslationSectionManager alloc] initWithViewModel:self.viewModel.videoRoomViewModel];
    translationsSection.sectionIndex = PDVideoRoomMemberListSectionTranslations;
    
    NSArray *array = @[
                       channelsSection,
                       channelsLoaderSection,
                       peopleSection,
                       placeholderSection,
                       loaderSection,
                       translationsSection,
                       ];
    
    self.sectionManagerAggregate = [[PDGenericCollectionViewSectionManagerAggregate alloc] initWithSectionManagers:array];
    
    PDNewAPICollectionViewInstantReloadAnimator *instantAnimator = [[PDNewAPICollectionViewInstantReloadAnimator alloc] init];
    
    PDGenericCollectionViewControllerConfigurator *controllerConfigurator = [[PDGenericCollectionViewControllerConfigurator alloc] init];
    controllerConfigurator.sectionManagerAggregate = self.sectionManagerAggregate;
    controllerConfigurator.entityListLoader = self.loadManager;
    controllerConfigurator.collectionViewDataManager = self.collectionViewDataManager;
    controllerConfigurator.collectionViewDataSource = self.collectionViewDataSource;
    controllerConfigurator.collectionViewAdapter = self.collectionViewAdapter;
    controllerConfigurator.collectionView = self.collectionView;
    controllerConfigurator.collectionViewLayout = self.collectionView.collectionViewLayout;
    controllerConfigurator.collectionViewSelectionAdapter = self.selectionAdapter;
    controllerConfigurator.sectionUpdateAnimator = instantAnimator;
    controllerConfigurator.fullUpdateAnimator = instantAnimator;
    controllerConfigurator.entityListLoader = self.loadManager;
    
    [controllerConfigurator configure];
}

- (void)setupLoaderUICoordinator {
    self.loaderUICoordinator = [[PDNewAPIEntityListLoaderUICoordinator alloc]
                                initWithRefreshControlStyle:PDNewAPIEntityListLoaderUICoordinatorRefreshControlStyleNone
                                scrollLimitAdapterStyle:PDNewAPIEntityListLoaderUICoordinatorScrollLimitAdaperStyleBottom
                                syncable:YES];
    self.loaderUICoordinator.collectionView = self.collectionView;
    self.loaderUICoordinator.entityListLoader = self.loadManager;
    self.loaderUICoordinator.sectionManagerAggregate = self.sectionManagerAggregate;
    [self.loaderUICoordinator setupAllComponents];
    
    self.channelsLoaderUICoordinator = [[PDNewAPIEntityListLoaderUICoordinator alloc]
                                initWithRefreshControlStyle:PDNewAPIEntityListLoaderUICoordinatorRefreshControlStyleNone
                                scrollLimitAdapterStyle:PDNewAPIEntityListLoaderUICoordinatorScrollLimitAdaperStyleNone
                                syncable:YES];
    self.channelsLoaderUICoordinator.collectionView = self.collectionView;
    self.channelsLoaderUICoordinator.entityListLoader = self.viewModel.channelsEntityListLoader;
    self.channelsLoaderUICoordinator.sectionManagerAggregate = self.sectionManagerAggregate;
    [self.channelsLoaderUICoordinator setupAllComponents];

    [self.loaderUICoordinator reloadCollectionData];
    [self.channelsLoaderUICoordinator reloadCollectionData];
}

- (void)startObservers {
    __weak typeof(self) wSelf = self;
    [self observeObject:self.viewModel.videoRoomViewModel
               property:@"activeTranslationId"
              withBlock:^(__weak PDVideoRoomMemberListViewController *weakSelf,
                          __weak id viewModel, id old, id newVal) {
                  [wSelf.collectionViewDataManager pushVisibleCellReconfigurationUpdate];
              }];
    [self observeObject:self.viewModel
               property:@"loadMoreChannelsSignal"
              withBlock:^(__weak PDVideoRoomMemberListViewController *weakSelf,
                          __weak id viewModel, id old, id newVal) {
                  [wSelf.channelsLoaderUICoordinator loadMoreData];
              }];
}

- (void)stopObservers {
    [self removeAllObservationsOfObject:self.viewModel.videoRoomViewModel];
    [self removeAllObservationsOfObject:self.viewModel];
}

@end
