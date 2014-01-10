def copy_persist_domain(d, domain, other_db_path, restore=False):
    import contextlib

    source_table = bb.persist_data.persist(domain, d)
    dest_table = bb.persist_data.SQLTable(other_db_path, domain)
    if restore:
        source_table, dest_table = dest_table, source_table

    with contextlib.nested(source_table, dest_table):
        dest_table.update(source_table)

def dump_headrevs(d, dump_db_path):
    copy_persist_domain(d, 'BB_URI_HEADREVS', dump_db_path)

def restore_headrevs(d, dump_db_path):
    copy_persist_domain(d, 'BB_URI_HEADREVS', dump_db_path, restore=True)

DUMP_HEADREVS_DB ?= '${COREBASE}/saved_persist_data.db'
DUMP_HEADREVS_STAMP ?= '${STAMP}.restored_headrevs'

python restore_dumped_headrevs() {
    if not isinstance(e, bb.event.ConfigParsed):
        return

    stamp_path = e.data.getVar('DUMP_HEADREVS_STAMP', True)
    dump_db_path = e.data.getVar('DUMP_HEADREVS_DB', True)
    if not os.path.exists(stamp_path) and os.path.exists(dump_db_path):
        restore_headrevs(e.data, dump_db_path)
        bb.utils.mkdirhier(os.path.dirname(stamp_path))
        open(stamp_path, 'w').close()
}
addhandler restore_dumped_headrevs
