//
//  LVCOrganizationsViewController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/15/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCOrganizationsViewController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>

@interface LVCOrganizationsViewController ()  <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (weak) IBOutlet NSOutlineView *outlineView;
@end

@implementation LVCOrganizationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    [self.outlineView expandItem:nil expandChildren:YES];
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
    return self.organizations.count;
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
    return self.organizations[index];
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
