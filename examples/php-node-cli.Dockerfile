FROM nimbleco/mcc-base:master

COPY --from=nimbleco/mcc-node10.component:master / /
COPY --from=nimbleco/mcc-php73.component:master / /