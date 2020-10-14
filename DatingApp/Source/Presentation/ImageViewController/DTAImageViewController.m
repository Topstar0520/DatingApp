//
//  DTAImageViewController.m
//  DatingApp
//
//  Created by Maksim on 16.09.15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAImageViewController.h"
#import "Image+Extensions.h"
#import "DTAPageItemController.h"

@interface DTAImageViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *contentImages;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) BOOL transitionInProgress;

@end

@implementation DTAImageViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [self.imageArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.contentImages = [NSMutableArray new];
    
    [self createPageViewController];
    
    [self setupPageControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Private

- (void) createPageViewController {
    for (Image *image in self.imageArray) {
        [self.contentImages addObject:image.fetchPictureUrl];
    }
    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"DTAPageViewControllerID"];
    pageController.dataSource = self;
    
    if([self.contentImages count]) {
        if (!_transitionInProgress) {
            _transitionInProgress = YES;
        
            NSArray *startingViewControllers = @[[self itemControllerForIndex:self.startImageIndex]];
        
            [pageController setViewControllers: startingViewControllers direction: UIPageViewControllerNavigationDirectionForward animated: NO completion: ^(BOOL finished) {
                _transitionInProgress = !finished;
            }];
        }
    }
    
    self.pageViewController = pageController;
    
    [self addChildViewController: self.pageViewController];
    
    [self.view addSubview: self.pageViewController.view];
    
    [self.pageViewController didMoveToParentViewController: self];
}

- (void) setupPageControl {
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController {
    DTAPageItemController *itemController = (DTAPageItemController *) viewController;
    
    if (itemController.itemIndex > 0) {
        return [self itemControllerForIndex: itemController.itemIndex - 1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController {
    DTAPageItemController *itemController = (DTAPageItemController *) viewController;
    
    if (itemController.itemIndex + 1 < [self.contentImages count]) {
        return [self itemControllerForIndex: itemController.itemIndex + 1];
    }
    
    return nil;
}

- (DTAPageItemController *) itemControllerForIndex: (NSInteger) itemIndex {
    if (itemIndex < [self.contentImages count]) {
        DTAPageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"DTAPageItemControllerID"];
        
        pageItemController.imageUrl = self.contentImages[itemIndex];
        pageItemController.itemIndex = itemIndex;
        
        return pageItemController;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Page Indicator

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController {
    return [self.contentImages count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController {
    return pageViewController.viewControllers.count ? [pageViewController.viewControllers[0] itemIndex] : 0; //avoid crash without internet
}

@end
