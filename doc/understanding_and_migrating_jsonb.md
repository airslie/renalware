# Understanding and migrating JSONB

[JSONB](https://www.postgresql.org/docs/9.4/datatype-json.html) columns are used in several places
in the Renalware PostgreSQL database schema.

They offer a sort of embedded [NoSQL](https://en.wikipedia.org/wiki/NoSQL)
approach in sections of patient data that are complex or
can vary from hospital to hospital. A hospital can for example augment a renalware data
`class` by adding a new, specific attribute, and this will be saved to the database in the jsonb
field without an actual change to the database schema being required (e.g. no addition of new
column required).

JSONB is used generally as the type of a column called `document` (for example the column
`document` in the table `patients`). These document columns correspond to classes in the
Renalware source code eg `class PatientDocument` whic define the structure of the JSONB stored.

So for example

```ruby
class ExampleDocument < Document::Embedded
  attribute :name, String
  attribute :over_21, Document::Enum, enums: %i(no yes)
end
```

might be saved by Rails as

```json
{
  "name": "Harry Potter",
  "over_21": "no"
}
```

When migrating you don't have the pleasure of Rails building the JSONB for you, so you need
to hand craft the json strings.

Some options are

### Concatenation an interpolation

```ruby
name = "x"
over_21 = false
json = "{ \"name\": \"#{name}\", \"over_21\": \"#{over_21 == true ? 'yes' : 'no'}\" }"
...
```

### A templating framework like [Jinja2](http://jinja.pocoo.org/) or [ERB](https://ruby-doc.org/stdlib-2.6.3/libdoc/erb/rdoc/ERB.html)

Jinja2:
```
from jinja2 import Template
t = Template("{ \"name\": \"{{ some_var }}\" }")
t.render(some_var="Harry Potter")
```

### SQL JSONB functions or SQL string concatenation

If you are constructing the JSONB in a SQL script, there are lots of
[JSONB functions and operators](https://www.postgresql.org/docs/9.5/functions-json.html)
to help you. There are lots of ways of going about it:
- put all your data in a temp table and then query it with JSON functions to build a document
- update the JSONB document column directly as and when you have the data, using eg jsonb upserts
- use string contanation eg ` '{' || '"name":' .... `


## Example

For example to migrate the `patients.document` you could try this approach:

1. Open a connection to an existing Renalware database an existing view a row in the `patients` table.
2. Copy the contents of the document column JSONB and paste into an editor and set all the values to
   null eg `{ ..., "diagnosed_on": null, ... }` . You can now use this as a template
3. For each patient, populate the template with either interpolation
   or by using a templating framework like Jinja2 or ERB, passing in variables as and when you know
   them.
   You can leave values as null until you know how you are going to populate them.
   You even omit parts of the json structure initially if you like.
   However if you put in attributes that Renalware does not recognise (perhaps you mis-spell an d
   attribute) you will get an error when viewing the patient or record in RW.

## Enums

In the above example `over_21` is defined as `Document::Enum` and has possible values of `null`,
`"no"` and `"yes"`. If you put anything else into the attribute you will get an error when you try
to view/edit the data in Renalware, so its best to build up the json slowly and test it as you go.

There are 2 possible locations in the Renalware source code where you can see the possible values
an enum can have. In the example

```ruby
class ExampleDocument < Document::Embedded
  attribute :name, String
  attribute :over_21, Document::Enum, enums: %i(no yes)
end
```

you can see that `over_21` can be "no" or "yes" (or null).
There will be other occasions where you see e.g.

```ruby
  attribute :some_attribute, Document::Enum
```

and in this case you the possible enums (as they are not explicitly listed inline) can be
found by finding the `config/locales/**/*.yml` i18n (internationalisation) file corresponding to
that class.

For example for the class

```ruby
module Renalware
  module Events
    class Biopsy < Event
      include Document::Base

      class Document < Document::Embedded
        attribute :result1, ::Document::Enum # See i18n for options
        ...
```

the file `config/locales/renalware/events/biopsy.en.yml` lists the possible values under the
`enumerize:` key:

```yml
enumerize:
  renalware/events/biopsy/document:
    result1:
      acute_amr: "Acute AMR"
      chronic_amr: "Chronic AMR"
      borderline_tcmr: "Borderline TCMR"
      tcmr_ia: "TCMR IA"
      tcmr_ib: "TCMR IB"
     ...
```

In this example the values you could save to the JSONB in result1` are:

```
"acute_amr"
"chronic_amr"
"borderline_tcmr"
"tcmr_ia"
"tcmr_ib"
```
