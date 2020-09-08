def unique_everseen(iterable):
    "List unique elements, preserving order. Remember all elements ever seen."
    # unique_everseen('AAAABBBCCDAABBB') --> A B C D
    # unique_everseen('ABBCcAD', str.lower) --> A B C D
    import itertools
    seen = set()
    seen_add = seen.add
    for element in itertools.filterfalse(seen.__contains__, iterable):
        seen_add(element)
        yield element

python add_feature_overrides () {
    feature_overrides = filter(None, d.getVar('FEATUREOVERRIDES').split(':'))
    if feature_overrides:
        d.prependVar('OVERRIDES', ':'.join(unique_everseen(feature_overrides)) + ':')
}
add_feature_overrides[eventmask] = "bb.event.ConfigParsed"
addhandler add_feature_overrides
