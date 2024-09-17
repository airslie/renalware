The idea here is that eventually we will have, say, 4 formats: html, pdf, rtf, fhir
and the first three 'presentation' formats will render the document in exactly the same way, so
you should see visually the same result regardless of html/pdf/rtf/other.
This structure allows us to possibly use the same DSL for presentational formats, to ensure that all
parts of the document are included; using phlex for the html version would help us achieve this.
We should probably avoid the view-component 'mini-controller' approach of allowing the component to
query for data, and instead either pass down a repository object or presenter, as data consistency
between presentation formats is essential.
