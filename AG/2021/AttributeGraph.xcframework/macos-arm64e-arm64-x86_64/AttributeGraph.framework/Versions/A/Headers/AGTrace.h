//
//  AGTrace.h
//  AttributeGraph

#ifndef AGTrace_h
#define AGTrace_h

#include <AttributeGraph/AGBase.h>
#include <AttributeGraph/AGGraph.h>

AG_ASSUME_NONNULL_BEGIN

typedef AG_ENUM(uint64_t, AGTraceEvents) {
    AGTraceEventsCustom = 1,
    AGTraceEventsNamed = 2,
    AGTraceEventsDeadline = 3,
    AGTraceEventsCompareFailed = 4,
} AG_SWIFT_NAME(TraceEvents);

typedef struct AGTrace {
    AGTraceEvents events;

    void (*_Nullable begin_trace)(void *_Nullable context, AGGraphRef graph);
    void (*_Nullable end_trace)(void *_Nullable context, AGGraphRef graph);

    void (*_Nullable begin_update_subgraph)(void *_Nullable context, AGSubgraphRef subgraph, uint32_t options);
    void (*_Nullable end_update_subgraph)(void *_Nullable context, AGSubgraphRef subgraph);
    void (*_Nullable begin_update_stack)(void *_Nullable context, AGAttribute attribute);
    void (*_Nullable end_update_stack)(void *_Nullable context, bool changed);
    void (*_Nullable begin_update_attribute)(void *_Nullable context, AGAttribute attribute);
    void (*_Nullable end_update_attribute)(void *_Nullable context, AGAttribute attribute, bool changed);
    void (*_Nullable begin_update_graph)(void *_Nullable context, AGGraphRef graph);
    void (*_Nullable end_update_graph)(void *_Nullable context, AGGraphRef graph);

    void (*_Nullable begin_invalidation)(void *_Nullable context, AGGraphRef graph, AGAttribute attribute);
    void (*_Nullable end_invalidation)(void *_Nullable context, AGGraphRef graph, AGAttribute attribute);

    void (*_Nullable begin_modify)(void *_Nullable context, AGAttribute attribute);
    void (*_Nullable end_modify)(void *_Nullable context, AGAttribute attribute);

    void (*_Nullable begin_event)(void *_Nullable context, AGAttribute attribute, const char *event_name);
    void (*_Nullable end_event)(void *_Nullable context, AGAttribute attribute, const char *event_name);

    void (*_Nullable created_graph)(void *_Nullable context, AGGraphRef graph);
    void (*_Nullable destroy_graph)(void *_Nullable context, AGGraphRef graph);
    void (*_Nullable needs_update)(void *_Nullable context, AGGraphRef graph);

    void (*_Nullable created_subgraph)(void *_Nullable context, AGSubgraphRef subgraph);
    void (*_Nullable invalidate_subgraph)(void *_Nullable context, AGSubgraphRef subgraph);
    void (*_Nullable add_child_subgraph)(void *_Nullable context, AGSubgraphRef subgraph, AGSubgraphRef child);
    void (*_Nullable remove_child_subgraph)(void *_Nullable context, AGSubgraphRef subgraph, AGSubgraphRef child);

    void (*_Nullable added_attribute)(void *_Nullable context, AGAttribute attribute);
    void (*_Nullable add_edge)(void *_Nullable context, AGAttribute attribute, AGAttribute input, unsigned int flags);
    void (*_Nullable remove_edge)(void *_Nullable context, AGAttribute attribute, size_t index);
    void (*_Nullable set_edge_pending)(void *_Nullable context, AGAttribute attribute, AGAttribute input, bool pending);

    void (*_Nullable set_dirty)(void *_Nullable context, AGAttribute attribute, bool dirty);
    void (*_Nullable set_pending)(void *_Nullable context, AGAttribute attribute, bool pending);
    void (*_Nullable set_value)(void *_Nullable context, AGAttribute attribute);
    void (*_Nullable mark_value)(void *_Nullable context, AGAttribute attribute);

    void (*_Nullable added_indirect_attribute)(void *_Nullable context, AGAttribute attribute);
    void (*_Nullable set_source)(void *_Nullable context, AGAttribute attribute, AGAttribute source);
    void (*_Nullable set_dependency)(void *_Nullable context, AGAttribute attribute, AGAttribute dependency);

    void (*_Nullable mark_profile)(void *_Nullable context, const char *event_name);

    void (*_Nullable custom_event)(void *_Nullable context, AGGraphRef graph, const char *event_name, const void *value,
                                   AGTypeID type);
    void (*_Nullable named_event)(void *_Nullable context, AGGraphRef graph, uint32_t eventID, uint32_t eventArgCount,
                                  const void *eventArgs, CFDataRef data, uint32_t arg6);
    bool (*_Nullable named_event_enabled)(void *_Nullable context);

    void (*_Nullable set_deadline)(void *_Nullable context);
    void (*_Nullable passed_deadline)(void *_Nullable context);

    void (*_Nullable compare_failed)(void *_Nullable context, AGAttribute attribute, AGComparisonState comparisonState);
} AGTrace AG_SWIFT_NAME(Trace);

AG_ASSUME_NONNULL_END

#endif /* AGTrace_h */
