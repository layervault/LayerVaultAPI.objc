//
//  LVCProjectOutlineViewController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/15/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCProjectOutlineViewController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LVCProjectOutlineViewController ()
@property (weak) IBOutlet NSOutlineView *outlineView;
@end

@implementation LVCProjectOutlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [RACObserve(self, project) subscribeNext:^(LVCProject *project) {
            [self.outlineView reloadData];
        }];
    }
    return self;
}

#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item) {
        if ([item isKindOfClass:LVCFolder.class]) {
            LVCFolder *folder = (LVCFolder *)item;
            return (folder.folders.count + folder.files.count);
        }
        return 0;
    }
    return (self.project.folders.count + self.project.files.count);
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return [item isKindOfClass:LVCFolder.class];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSSortDescriptor *dateModified = [NSSortDescriptor sortDescriptorWithKey:@"dateUpdated"
                                                                   ascending:NO];
    NSArray *children = nil;
    if (item) {
        if ([item isKindOfClass:LVCFolder.class]) {
            LVCFolder *folder = (LVCFolder *)item;
            children = [folder.folders arrayByAddingObjectsFromArray:folder.files];
        }
    }
    else {
        children = [self.project.folders arrayByAddingObjectsFromArray:self.project.files];
    }
    return [children sortedArrayUsingDescriptors:@[dateModified]][index];
}


#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:tableColumn.identifier
                                                                   owner:self];;
    if ([item isKindOfClass:LVCNode.class]) {
        LVCNode *node = (LVCNode *)item;
        if ([tableColumn.identifier isEqualToString:@"NameColumn"]) {
            [tableCellView.textField setStringValue:node.name];
            NSString *imageName = [node isKindOfClass:LVCFolder.class] ? NSImageNamePathTemplate : NSImageNameIChatTheaterTemplate;
            tableCellView.imageView.image = [NSImage imageNamed:imageName];
        }
        else if ([tableColumn.identifier isEqualToString:@"InfoColumn"]) {
            if ([node isKindOfClass:LVCFolder.class]) {
                LVCFolder *folder = (LVCFolder *)node;
                NSString *string = [NSString stringWithFormat:@"%lu Files", (unsigned long)folder.files.count];
                [tableCellView.textField setStringValue:string];
            }
            else {
                [tableCellView.textField setStringValue:@""];
            }
        }
        else if ([tableColumn.identifier isEqualToString:@"DateModifiedColumn"]) {
            [tableCellView.textField.cell setObjectValue:node.dateUpdated];
        }

    }
    return tableCellView;
}

@end
