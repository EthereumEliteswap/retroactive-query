# @uniswap_v2/retroactive-query

[![Run Queries](https://github.com/EthereumEliteswap/retroactive-query/workflows/Run%20Queries/badge.svg)](https://github.com/EthereumEliteswap/retroactive-query/actions?query=workflow%3A%22Run+Queries%22)

This repository contains queries that produce the tables of retroactive ELT token distributions.

The queries run in [Google BigQuery](https://cloud.google.com/bigquery) against the 
[`bigquery-public-data.crypto_ethereum`](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=crypto_ethereum&page=dataset) 
dataset.

Data for this dataset is extracted to Google BigQuery using
[blockchain-etl/ethereum-etl](https://github.com/blockchain-etl/ethereum-etl).

## Specifications

All queries have a timestamp from `2020-11-18 00:00:00+00 GMT` to `2021-01-18 00:00:00+00 GMT`.

### All users

20000 ELT goes to:

- any account that directly `call`s a Uniswap v2 pairs or a Uniswap v2 routers or a Uniswap v2 Factory contracts
 
## Reproduction

You can reproduce the results of this query by forking this repository and adding your own secrets to run in your own GCP account.

1. Create a Google Cloud project [here](https://cloud.google.com/) 
1. Find your Project ID in the Google Cloud console [here](https://console.cloud.google.com/)
1. Fork this repository
1. Add the secret `GCP_PROJECT_ID` under Settings > Secrets containing your project ID from the GCP dashboard 
1. Add the secret `GCP_SA_KEY` under Settings > Secrets containing the base64 encoded JSON key of a service account
1. Go to the actions tab of your fork
1. Run the workflow
1. Inspect the resulting tables in GCP BigQuery Explorer

### Determinism notes

Note that, for floating point input types, the return result of aggregations is non-deterministic,
which means you will not get the exact same result each time you aggregate floating point columns.

These queries make use of floating point numbers. However in the final `all_earnings_hexadecimal` table,
we truncate to 6 decimal places so that the result used for production is the same across multiple runs.

See
[https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions)
for more information.

### Final results

The blob containing all the proofs of the retroactive distribution can be found at [mrkl.uniswap.org](https://mrkl.uniswap.org).
