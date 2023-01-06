# frozen_string_literal: true

# Some safety-net routes in case we happen to fall through the above routes without a match.
# For example, redirect to the HD dashboard if they hit just /hd/
# In theory we should only ever hit these routes if the user manually edits/enters the URL.
get "/patients/:id/hd", to: redirect("/patients/%{id}/hd/dashboard")
get "/patients/:id/pd", to: redirect("/patients/%{id}/pd/dashboard")
get "/patients/:id/transplants", to: redirect("/patients/%{id}")
get "/patients/:id/transplants/donor",
    to: redirect("/patients/%{id}/transplants/donor/dashboard")
get "/patients/:id/transplants/recipient",
    to: redirect("/patients/%{id}/transplants/recipient/dashboard")

# Azure healthcheck sends requests like '/robots3455.txt' and if we raise an error it pollutes the
# logs so instead handle these by redirecting to the errors controller which will return
# a 404 (and display a 404 page)
get "/robots:id.txt", to: "system/errors#not_found", constraints: { id: /\d+/ }
