module Renalware
  # The role of this module is currently just to list all variations of css colour classes that
  # might be needed as a result of the postgres enum_colour_name (green rose etc) which can be
  # assigned for example to drug_types, pathology_observation_descriptions, and in the view layer
  # interpolated into eg
  #   tr(class="bg-rose-100 hover:bg-rose-200")
  module TailwindHelper
    # Options from the The enum_colour_name
    # bg-slate-50 bg-slate-100 bg-slate-200 hover:bg-slate-100 hover:bg-slate-200
    # bg-gray-50 bg-gray-100 bg-gray-200 hover:bg-gray-100 hover:bg-gray-200
    # bg-zinc-50 bg-zinc-100 bg-zinc-200 hover:bg-zinc-100 hover:bg-zinc-200
    # bg-neutral-50 bg-neutral-100 bg-neutral-200 hover:bg-neutral-100 hover:bg-neutral-200
    # bg-stone-50 bg-stone-100 bg-stone-200 hover:bg-stone-100 hover:bg-stone-200
    # bg-red-50 bg-red-100 bg-red-200 hover:bg-red-100 hover:bg-red-200
    # bg-orange-50 bg-orange-100 bg-orange-200 hover:bg-orange-100 hover:bg-orange-200
    # bg-amber-50 bg-amber-100 bg-amber-200 hover:bg-amber-100 hover:bg-amber-200
    # bg-yellow-50 bg-yellow-100 bg-yellow-200 hover:bg-yellow-100 hover:bg-yellow-200
    # bg-lime-50 bg-lime-100 bg-lime-200 hover:bg-lime-100 hover:bg-lime-200
    # bg-green-50 bg-green-100 bg-green-200 hover:bg-green-100 hover:bg-green-200
    # bg-emerald-50 bg-emerald-100 bg-emerald-200 hover:bg-emerald-100 hover:bg-emerald-200
    # bg-teal-50 bg-teal-100 bg-teal-200 hover:bg-teal-100 hover:bg-teal-200
    # bg-cyan-50 bg-cyan-100 bg-cyan-200 hover:bg-cyan-100 hover:bg-cyan-200
    # bg-sky-50 bg-sky-100 bg-sky-200 hover:bg-sky-100 hover:bg-sky-200
    # bg-blue-50 bg-blue-100 bg-blue-200 hover:bg-blue-100 hover:bg-blue-200
    # bg-indigo-50 bg-indigo-100 bg-indigo-200 hover:bg-indigo-100 hover:bg-indigo-200
    # bg-violet-50 bg-violet-100 bg-violet-200 hover:bg-violet-100 hover:bg-violet-200
    # bg-purple-50 bg-purple-100 bg-purple-200 hover:bg-purple-100 hover:bg-purple-200
    # bg-fuchsia-50 bg-fuchsia-100 bg-fuchsia-200 hover:bg-fuchsia-100 hover:bg-fuchsia-200
    # bg-pink-50 bg-pink-100 bg-pink-200 hover:bg-pink-100 hover:bg-pink-200
    # bg-rose-50 bg-rose-100 bg-rose-200 hover:bg-rose-100 hover:bg-rose-200
  end
end
