/*
	Copyright (C) 2008 Quentin Mathe

	Author:  Quentin Mathe <qmathe@club-internet.fr>
	Date:  December 2008
	License:  Modified BSD (see COPYING)
 */

#import "SketchController.h"
#import <EtoilePaint/ETBezierEditingFreeLayout.h>

@implementation SketchController

- (instancetype)init
{

	self = [super initWithObjectGraphContext: [ETUIObject defaultTransientObjectGraphContext]];
	return	(self);
}

- (void) applicationDidFinishLaunching: (NSNotification *)notif
{
	ETLayoutItemFactory *itemFactory = [ETLayoutItemFactory factory];

	/* Shows the graphics editing related menu which contains commands like 
	   'group', 'ungroup', 'send backward' etc. */
	[[ETApp mainMenu] addItem: [ETApp arrangeMenuItem]];

	mainItem = [itemFactory itemGroup];
	
	/* Set up main item to behave like a very basic compound document editor */

	// NOTE: Uncomment next line to test the example with a content coordinate 
	// base located in the bottom left.
	//[mainItem setFlipped: NO];
	[mainItem setSize: NSMakeSize(500, 400)];
	[mainItem setLayout: [ETBezierFreeLayout layoutWithObjectGraphContext: [self objectGraphContext]]];

	/* Make mainItem visible by inserting it inside the window layer */

	[[itemFactory windowGroup] addItem: mainItem];
	
	/* Insert a bit of everything as content (widgets and shapes) */

	[mainItem addItem: [itemFactory horizontalSlider]];
	[mainItem addItem: [itemFactory textField]];
	[mainItem addItem: [itemFactory labelWithTitle: @"Hello World!"]];
	[mainItem addItem: [itemFactory button]];
	[mainItem addItem: [itemFactory rectangle]];
	[mainItem addItem: [itemFactory oval]];
	/* Selection rubber-band is a layout item too, which means we can use it 
	   in the same way than other shape-based items... */
	[mainItem addItem: AUTORELEASE([[ETSelectionAreaItem alloc] init])];

	/* ... A less useless use case would be to replace the shape bound to it or 
	   alter its shape as below. */

	ETSelectTool *tool = [[mainItem layout] attachedTool];
	[[[tool selectionAreaItem] style] setStrokeColor: [NSColor orangeColor]];

	[[mainItem layout] setAttachedTool: [ETBrushTool toolWithObjectGraphContext: [self objectGraphContext]]];

	/* Give grid-like positions to items initially */

	ETFlowLayout *flow = [ETFlowLayout layoutWithObjectGraphContext: [self objectGraphContext]];
	[flow setItemSizeConstraintStyle: ETSizeConstraintStyleNone];
	[(ETFreeLayout *)[mainItem layout] resetItemPersistentFramesWithLayout: flow];

	/* Open an inspector that allows us to easily switch the tool and the 
	   layout in use */

	[[itemFactory windowGroup] inspect: nil];
	
	// FIXME: [ETApp explore: nil];
}

@end
