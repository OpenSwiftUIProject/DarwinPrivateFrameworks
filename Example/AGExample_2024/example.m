// example.m
// AttributeGraph C API usage from Objective-C
//
// Build (macOS, linking against the private AttributeGraph framework):
//   clang -framework Foundation -F /path/to/AttributeGraph example.m -o example

#import <Foundation/Foundation.h>
#include <AttributeGraph/AGGraph.h>
#include <AttributeGraph/AGAttribute.h>
#include <AttributeGraph/AGSubgraph.h>

// MARK: - 1. Graph Creation & Lifecycle

void demo_graph_lifecycle(void) {
    NSLog(@"=== Graph Lifecycle ===");

    // Create a graph (CF-type, must be released)
    AGGraphRef graph = AGGraphCreate();
    NSLog(@"Created graph: %@", graph);

    // Create a shared graph from an existing one
    AGGraphRef shared = AGGraphCreateShared(graph);
    NSLog(@"Created shared graph: %@", shared);

    // Attach an opaque context pointer
    NSDictionary *userInfo = @{@"name": @"MyGraph"};
    AGGraphSetContext(graph, (__bridge const void *)userInfo);

    // Retrieve it later
    const void *raw = AGGraphGetContext(graph);
    NSDictionary *retrieved = (__bridge NSDictionary *)raw;
    NSLog(@"Graph context: %@", retrieved);

    // Get the graph context object
    // TODO: Fix AGGraphGetGraphContext crash.
    // AGGraphGetGraphContext crashes when the graph has no context set.
    // A context is typically provided by the host (e.g. SwiftUI) during graph setup.
    // AGGraphContextRef ctx = AGGraphGetGraphContext(graph);
    // NSLog(@"GraphContext: %@", ctx);

    // Invalidate and release
    AGGraphInvalidate(graph);
    CFRelease(shared);
    CFRelease(graph);
}

// MARK: - 2. Subgraph Tree (Parent/Child)

void demo_subgraph_tree(void) {
    NSLog(@"=== Subgraph Tree ===");

    AGGraphRef graph = AGGraphCreate();

    // Create subgraphs
    AGSubgraphRef parent = AGSubgraphCreate(graph);
    AGSubgraphRef child1 = AGSubgraphCreate(graph);
    AGSubgraphRef child2 = AGSubgraphCreate(graph);

    // Build hierarchy
    AGSubgraphAddChild(parent, child1);
    AGSubgraphAddChild2(parent, child2, /* tag */ 42);

    // Query children
    uint32_t childCount = AGSubgraphGetChildCount(parent);
    NSLog(@"Parent has %u children", childCount);

    // TODO: Fix AGSubgraphGetChild infinite loop.
    // AGSubgraphGetChild is likely linked-list based (not index-based),
    // causing an infinite loop when called with sequential indices 0, 1, ...
//    for (uint32_t i = 0; i < childCount; i++) {
//        uint8_t tag = 0;
//        AGSubgraphRef child = AGSubgraphGetChild(parent, i, &tag);
//        NSLog(@"  child[%u]: %@ (tag=%u)", i, child, tag);
//    }

    // Query parents
    uint64_t parentCount = AGSubgraphGetParentCount(child1);
    NSLog(@"child1 has %llu parents", parentCount);

    // Ancestor check
    bool isAnc = AGSubgraphIsAncestor(parent, child1);
    NSLog(@"parent is ancestor of child1: %d", isAnc);

    // Remove a child
    AGSubgraphRemoveChild(parent, child1);
    NSLog(@"After removal: %u children", AGSubgraphGetChildCount(parent));

    // Validity
    NSLog(@"parent isValid: %d", AGSubgraphIsValid(parent));

    // Get owning graph
    AGGraphRef ownerGraph = AGSubgraphGetGraph(parent);
    NSLog(@"Owner graph: %@", ownerGraph);

    // Cleanup
    AGSubgraphInvalidate(child2);
    AGSubgraphInvalidate(child1);
    AGSubgraphInvalidate(parent);
    AGGraphInvalidate(graph);
    CFRelease(child2);
    CFRelease(child1);
    CFRelease(parent);
    CFRelease(graph);
}

// MARK: - 3. Current Subgraph & Attribute Basics

void demo_current_subgraph(void) {
    NSLog(@"=== Current Subgraph ===");

    AGGraphRef graph = AGGraphCreate();
    AGSubgraphRef subgraph = AGSubgraphCreate(graph);

    // Set/get the thread-local current subgraph
    AGSubgraphSetCurrent(subgraph);
    AGSubgraphRef current = AGSubgraphGetCurrent();
    NSLog(@"Current subgraph: %@", current);

    // Get current graph context (if any)
    // TODO: Fix AGSubgraphGetCurrentGraphContext crash.
    // AGSubgraphGetCurrentGraphContext crashes (EXC_BAD_ACCESS) when no
    // graph context has been set. Same as AGGraphGetGraphContext — the context
    // is provided by the host (e.g. SwiftUI) and is not available in standalone usage.
    // AGGraphContextRef gctx = AGSubgraphGetCurrentGraphContext();
    // NSLog(@"Current graph context: %@", gctx);

    // The nil attribute sentinel
    AGAttribute nilAttr = AGAttributeNil;
    NSLog(@"AGAttributeNil = %u", nilAttr);

    // Get current attribute (valid only during an update callback)
    AGAttribute currentAttr = AGGraphGetCurrentAttribute();
    NSLog(@"Current attribute: %u", currentAttr);

    // Check if attribute has a value
    // TODO: Fix "non-direct attribute id" precondition failure.
    // AGGraphHasValue expects a direct attribute, but the attribute created here
    // may be indirect. Need to investigate how to create a direct attribute.
    // bool hasVal = AGGraphHasValue(currentAttr);
    // NSLog(@"Has value: %d", hasVal);

    // Clear current subgraph
    AGSubgraphSetCurrent(NULL);

    AGSubgraphInvalidate(subgraph);
    AGGraphInvalidate(graph);
    CFRelease(subgraph);
    CFRelease(graph);
}

// MARK: - 4. Profiling & Counters

void demo_profiling(void) {
    NSLog(@"=== Profiling ===");

    AGGraphRef graph = AGGraphCreate();

    // Start profiling
    AGGraphStartProfiling(graph);

    // ... perform graph operations ...

    // Stop and read counters
    AGGraphStopProfiling(graph);

    // TODO: AGGraphCounterQueryTypeNodeCount
    // uint64_t nodeCount = AGGraphGetCounter(graph, AGGraphCounterQueryTypeNodeCount);
    // NSLog(@"Node count: %llu", nodeCount);

    // Reset profile data
    AGGraphResetProfile(graph);

    AGGraphInvalidate(graph);
    CFRelease(graph);
}

// MARK: - 5. Subgraph Dirty Check & Update

void demo_subgraph_update(void) {
    NSLog(@"=== Subgraph Update ===");

    AGGraphRef graph = AGGraphCreate();
    AGSubgraphRef subgraph = AGSubgraphCreate(graph);

    AGAttributeFlags flags = 0;

    // Check if any attributes in the subgraph are dirty
    bool dirty = AGSubgraphIsDirty(subgraph, flags);
    NSLog(@"Is dirty: %d", dirty);

    // Check if subgraph intersects with given flags
    bool intersects = AGSubgraphIntersects(subgraph, flags);
    NSLog(@"Intersects: %d", intersects);

    // Trigger update for attributes matching flags
    AGSubgraphUpdate(subgraph, flags);

    AGSubgraphInvalidate(subgraph);
    AGGraphInvalidate(graph);
    CFRelease(subgraph);
    CFRelease(graph);
}

// MARK: - 6. Deferred Invalidation

void demo_deferred_invalidation(void) {
    NSLog(@"=== Deferred Invalidation ===");

    AGGraphRef graph = AGGraphCreate();

    // Begin batching invalidations (returns previous state)
    bool wasDeferring = AGGraphBeginDeferringSubgraphInvalidation(graph);

    // ... batch multiple changes without triggering invalidation ...
    AGGraphInvalidateAllValues(graph);

    // End deferring (flushes pending invalidations)
    AGGraphEndDeferringSubgraphInvalidation(graph, wasDeferring);

    AGGraphInvalidate(graph);
    CFRelease(graph);
}

// MARK: - 7. ARC Bridging Patterns

void demo_arc_bridging(void) {
    NSLog(@"=== ARC Bridging ===");

    // AGGraphRef/AGSubgraphRef are CF-bridged types.
    // You can bridge them to ARC-managed id for automatic lifetime:

    AGGraphRef graph = AGGraphCreate();

    // Transfer ownership to ARC (no need to CFRelease)
    id arcGraph = (__bridge_transfer id)graph;
    NSLog(@"ARC-managed graph: %@", arcGraph);
    // graph is now managed by ARC, released when arcGraph goes out of scope

    // Borrow without transferring ownership
    AGGraphRef graph2 = AGGraphCreate();
    id borrowed = (__bridge id)graph2;
    NSLog(@"Borrowed graph: %@", borrowed);
    CFRelease(graph2); // Still need to release manually
}

// MARK: - 8. Attribute Ownership Query

void demo_attribute_ownership(void) {
    NSLog(@"=== Attribute Ownership ===");

    AGGraphRef graph = AGGraphCreate();
    AGSubgraphRef subgraph = AGSubgraphCreate(graph);
    AGSubgraphSetCurrent(subgraph);

    // Given an attribute, find which graph/subgraph owns it
    AGAttribute attr = AGGraphGetCurrentAttribute();
    if (attr != AGAttributeNil) {
        AGGraphRef ownerGraph = AGGraphGetAttributeGraph(attr);
        AGSubgraphRef ownerSub = AGGraphGetAttributeSubgraph(attr);
        NSLog(@"Attribute %u -> graph: %@, subgraph: %@", attr, ownerGraph, ownerSub);

        // Get value state
        AGValueState state = AGGraphGetValueState(attr);
        NSLog(@"Value state: %u", state);

        // Get attribute flags
        AGAttributeFlags flags = AGGraphGetFlags(attr);
        NSLog(@"Flags: %u", flags);
    }

    AGSubgraphSetCurrent(NULL);
    AGSubgraphInvalidate(subgraph);
    AGGraphInvalidate(graph);
    CFRelease(subgraph);
    CFRelease(graph);
}

// MARK: - Entry

void ag_example_main(void) {
    @autoreleasepool {
        demo_graph_lifecycle();
        demo_subgraph_tree();
        demo_current_subgraph();
        demo_profiling();
        demo_subgraph_update();
        demo_deferred_invalidation();
        demo_arc_bridging();
        demo_attribute_ownership();
    }
}
