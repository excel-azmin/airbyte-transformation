{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "rma_server",
    post_hook = ["
                    {%
                        set scd_table_relation = adapter.get_relation(
                            database=this.database,
                            schema=this.schema,
                            identifier='item_scd'
                        )
                    %}
                    {%
                        if scd_table_relation is not none
                    %}
                    {%
                            do adapter.drop_relation(scd_table_relation)
                    %}
                    {% endif %}
                        "],
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('item_ab3') }}
select
    _id,
    idx,
    mrp,
    {{ adapter.quote('name') }},
    uoms['ids'],
    uuid,
    brand,
    image,
    {{ adapter.quote('owner') }},
    taxes,
    doctype,
    barcodes,
    creation,
    disabled,
    issynced,
    modified,
    docstatus,
    item_code,
    item_name,
    stock_uom,
    thumbnail,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_item_hashid
from {{ ref('item_ab3') }}
-- item from {{ source('rma_server', '_airbyte_raw_item') }}
where 1 = 1

