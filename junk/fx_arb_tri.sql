use fx
drop table if exists fx_tri_arb

create table fx_tri_arb (
    datetime timestamp,
    amount real,
    from_code char(3),
    new_amount real,
    to_code char(3),
    next_amount real,
    last_code char(3),
    last_amount real
    closing_code char(3),
    );

