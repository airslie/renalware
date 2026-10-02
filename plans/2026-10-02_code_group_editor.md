# Pathology code group editor (superadmin)

## Scope
- Superadmin-only Admin page to list, create and edit all code groups. New groups are `context_specific = false`.
  System groups (`context_specific = true`, e.g. letters, virology) can be edited but not renamed or deleted.
- A group has: name (locked after creation), title, description, subgroup titles and colours,
  and memberships (observation description, subgroup, position).
- `default` and system groups cannot be deleted.

## UX
- One form, one Save. Nothing persists until Save.
- Subgroup panels: each has a title, a colour select and an ordered member list.
  Members are dragged within/between panels (SortableJS) – JS rewrites hidden `subgroup` and
  `position_within_subgroup` fields.
- Add member: slim-select ajax search by code or name -> posts the draft to `draft` which re-renders the form.
  Remove member / add subgroup also round-trip the draft (no persistence).
- Live preview: the form posts to `preview` (debounced on change) and replaces a turbo frame that renders the
  current-results grid with sample values.

## Server
- `accepts_nested_attributes_for :memberships`; positions normalised before validation.
- Routes on `pathology/code_groups`: `new/create/edit/update/destroy` plus `draft`, `preview`, `description_search` (json).
- `CodeGroupPolicy`: super admin only for everything incl. index/show.

## Tests (TDD)
- Model: `deletable?`, title required on design, position normalisation, nested memberships.
- Policy.
- System: create, edit, add/remove member, subgroup colours/titles, preview, delete, system group edit restrictions.
