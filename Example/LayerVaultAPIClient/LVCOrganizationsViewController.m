//
//  LVCOrganizationsViewController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/15/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCOrganizationsViewController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LVCColorCircleView.h"

@interface LVCOrganizationsViewController ()  <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (weak) IBOutlet NSButton *addProjectButton;
@end

@implementation LVCOrganizationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [RACObserve(self, organizations) subscribeNext:^(NSArray *organizations) {
            [self.outlineView reloadData];
        }];
    }
    return self;
}


#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return (NSInteger)self.organizations.count;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item isKindOfClass:LVCOrganizationValue.class];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
//    if (item) {
//        if ([item isKindOfClass:LVCOrganizationValue.class]) {
//            LVCOrganizationValue *organization = (LVCOrganizationValue *)item;
//            return filteredArray[(NSUInteger)index];
//        }
//        return nil;
//    }
    return self.organizations[(NSUInteger)index];
}


#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *tableCellView = nil;
    if (item) {
        if ([item isKindOfClass:LVCOrganizationValue.class]) {
            LVCOrganizationValue *organization = (LVCOrganizationValue *)item;
            tableCellView = [outlineView makeViewWithIdentifier:@"HeaderCell"
                                                          owner:self];
            [tableCellView.textField setStringValue:organization.name];
            NSButton *button = [tableCellView viewWithTag:66];
            NSMutableAttributedString *title = button.attributedTitle.mutableCopy;
            [title addAttribute:NSForegroundColorAttributeName
                          value:[NSColor clearColor]
                          range:NSMakeRange(0, title.length)];
            button.attributedTitle = title;
        }
//        else if ([item isKindOfClass:LVCProject.class]) {
//            LVCProject *project = (LVCProject *)item;
//            tableCellView = [outlineView makeViewWithIdentifier:@"DataCell"
//                                                          owner:self];
//            [tableCellView.textField setStringValue:project.name];
//            tableCellView.imageView.image = [LVCColorCircleView circleImageWithColorLabel:project.colorLabel];
//        }
    }
    return tableCellView;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return NO;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
//    return [item isKindOfClass:LVCProject.class];
    return NO;
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
//    id selectedItem = [self.outlineView itemAtRow:self.outlineView.selectedRow];
//    NSAssert(selectedItem == nil || [selectedItem isKindOfClass:LVCProject.class],
//             @"selected item can only be project or nil");
//    self.selectedProject = [self.outlineView itemAtRow:self.outlineView.selectedRow];
}

@end
