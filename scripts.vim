if expand('%:e')==#'' && !isdirectory(expand('%')) && expand('%:p') =~ '/org/' |
  setfiletype org |
endif
