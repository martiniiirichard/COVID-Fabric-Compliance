# Local Medallion Warehouse (Desktop POC)

This is a local medallion architecture you can run on desktop before Fabric migration.

## Layout

- `layers/bronze`: raw landed CSVs
- `layers/silver`: conformed outputs (`DateKey`, `GeoKey`, standardized keys)
- `layers/gold`: KPI-ready aggregates
- `sql`: migration-ready SQL templates for Fabric translation
- `logs`: run manifests and validation outputs

## Run order

1. `scripts/init-local-medallion.ps1`
2. `scripts/run-local-medallion-poc.ps1`

## Migration intent

Keep transformations deterministic and layer-pure so each step maps directly to Fabric notebooks/pipelines/Warehouse SQL.
