# Source Inventory (Initial)

Source path: `C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze`

## Files discovered

- `colleges.csv`
- `deaths.csv`
- `demographics.csv`
- `economy.csv`
- `epidemiology.csv`
- `facilities.csv`
- `facility-boundary-us-all.csv`
- `geography.csv`
- `Google Covid Data Notes.txt`
- `google-search-trends.csv`
- `health.csv`
- `hospitalizations.csv`
- `index.csv`
- `lawatlas-emergency-declarations.csv`
- `mask-use-by-county.csv`
- `mobility.csv`
- `systems.csv`
- `us-counties-2020.csv`
- `us-counties-2021.csv`
- `us-counties-2022.csv`
- `us-states.csv`
- `us.csv`

## Initial classification

- Epidemiology and outcomes: `epidemiology.csv`, `deaths.csv`, `hospitalizations.csv`, `health.csv`
- Geography and boundaries: `geography.csv`, `facility-boundary-us-all.csv`, `us*.csv`
- Behavior and policy: `mobility.csv`, `mask-use-by-county.csv`, `lawatlas-emergency-declarations.csv`, `google-search-trends.csv`
- Contextual signals: `economy.csv`, `demographics.csv`, `colleges.csv`, `facilities.csv`, `systems.csv`

## Next profiling task

Profile row counts, grain, keys, date coverage, and join feasibility for each file before serving-layer design.

