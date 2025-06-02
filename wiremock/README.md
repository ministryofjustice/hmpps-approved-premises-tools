# Overview

All upstream requests (excluding auth) are proxied via wiremock.

We can selectively mock a request by adding a mapping to the `mappings/overrides` folder with a priority < 100

Example overrides are checked in with a priority set greater than 100 so they're ignored by default

## Viewing Requests & Responses

Wiremock provides an API to view requests:

```curl http://localhost:9004/__admin/requests```

Combine with jq to make it more usable:

```curl http://localhost:9004/__admin/requests | jq '.requests[].request.url'```

Note that newest requests are shown at the top of the list