# Overview

By default, Wiremock is not used as it can have some performance impacts.

It can be configured as a middle man between the API and upstream services, allowing requests to be selectively mocked.

To enable request proxying via wiremock update `.env.api.template`, commenting out all configuration in the section labeled '# Call upstream endpoints directly' and uncommenting all configuration in the section labeled '# Call upstream endpoints via wiremock'

We can then selectively mock a request by adding a mapping to the `mappings/overrides` folder with a priority < 100

Example overrides are checked in with a priority set greater than 100 so they're ignored by default

## Viewing Requests & Responses

If wiremock is used as a proxy we can use its API to view all upstream requests:

```curl http://localhost:9004/__admin/requests```

Combine with jq to make it more usable:

```curl http://localhost:9004/__admin/requests | jq '.requests[].request.url'```

Note that newest requests are shown at the top of the list