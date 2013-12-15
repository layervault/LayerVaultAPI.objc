//
//  LVCMainWindowController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/14/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCMainWindowController.h"
#import "LVCOrganizationsViewController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>

@interface LVCMainWindowController () <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (weak) IBOutlet NSOutlineView *sourceList;
@property (weak) IBOutlet NSOutlineView *fileList;
@property (strong) IBOutlet LVCOrganizationsViewController *organizationsViewController;
@property (weak) IBOutlet NSView *sourceViewContainer;
@end

@implementation LVCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.organizationsViewController.organizations = self.user.organizations;
    NSView *contentView = self.organizationsViewController.view;
    contentView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    contentView.frame = self.sourceViewContainer.bounds;
    [self.sourceViewContainer addSubview:contentView];
}

#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item) {
        if ([item isKindOfClass:LVCOrganization.class]) {
            LVCOrganization *organization = (LVCOrganization *)item;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member = TRUE"];
            NSArray *filteredArray = [organization.projects filteredArrayUsingPredicate:predicate];
            return filteredArray.count;
        }
        return 0;
    }
    return self.user.organizations.count;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item isKindOfClass:LVCOrganization.class];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item) {
        if ([item isKindOfClass:LVCOrganization.class]) {
            LVCOrganization *organization = (LVCOrganization *)item;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"member = TRUE"];
            NSArray *filteredArray = [organization.projects filteredArrayUsingPredicate:predicate];
            return filteredArray[index];
        }
        return nil;
    }
    return self.user.organizations[index];
}


#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *tableCellView = nil;
    if (item) {
        if ([item isKindOfClass:LVCOrganization.class]) {
            LVCOrganization *organization = (LVCOrganization *)item;
            tableCellView = [outlineView makeViewWithIdentifier:@"HeaderCell"
                                                          owner:self];
            [tableCellView.textField setStringValue:organization.name];
        }
        else if ([item isKindOfClass:LVCProject.class]) {
            LVCProject *project = (LVCProject *)item;
            tableCellView = [outlineView makeViewWithIdentifier:@"DataCell"
                                                          owner:self];
            [tableCellView.textField setStringValue:project.name];
        }
    }
    return tableCellView;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return NO;
}


@end
